/* LIST OF CONTENTS
 * - (int, QObject *) ThreadWorker::ThreadWorker | 22 - 28 | 14
 * - nil ThreadWorker::~ThreadWorker | 30 - 32 | 14
 * - void () ThreadWorker::startDbConnection | 34 - 73 | 19
 * - QString (QString, QString) ThreadWorker::callQuery | 75 - 102 | 22
 * - void () ThreadWorker::startDay | 104 - 126 | 19
 * - void () ThreadWorker::getExerciseData | 128 - 203 | 19
 * - void (QList<Record>) ThreadWorker::completeExercise | 205 - 276 | 19
 * - void () ThreadWorker::getOnTraining | 278 - 304 | 19
 * - void () ThreadWorker::getTodayRecords | 306 - 355 | 19
 * - void () ThreadWorker::completeTraining | 357 - 424 | 19
 * END OF CONTENTS */

#include "thread_worker.h"
#include <qcontainerfwd.h>
#include <qfiledevice.h>
#include <qhashfunctions.h>
#include <qlist.h>
#include <qlogging.h>
#include <qsqldatabase.h>
#include <qstandardpaths.h>

ThreadWorker::ThreadWorker(int id, QObject *parent) : QObject{parent} {
  m_id = id;
  qInfo() << "Created a ThreadWorker with the id:" << m_id;
  m_connectionName = QString("Sqlite %1").arg(m_id);
  connect(this, &ThreadWorker::addTask, &ThreadWorker::taskAdded);
  connect(this, &ThreadWorker::completeTask, &ThreadWorker::taskCompleted);
}

ThreadWorker::~ThreadWorker() {
  qInfo() << "Deleted the ThreadWorker with the id:" << m_id;
}

void ThreadWorker::startDbConnection() {
  emit addTask();

  QSqlDatabase sqliteDb =
      QSqlDatabase::addDatabase("QSQLITE", m_connectionName);

#ifdef Q_OS_ANDROID
  QString databasePath =
      QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
      "/storage.db";
#else
  QString databasePath =
      QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
      "/storage.db";
#endif

  QDir().mkpath(QFileInfo(databasePath).absolutePath());
  sqliteDb.setDatabaseName(databasePath);
  if (!sqliteDb.open()) {
    qWarning() << "Sqlite connection error on ThreadWorker" << m_id << ":"
               << sqliteDb.lastError().text();
  } else {
    qInfo() << "Sqlite connection completed on ThreadWorker" << m_id;

    QSqlQuery query(sqliteDb);

    if (!query.exec("PRAGMA foreign_keys = ON;")) {
      qWarning() << "Failed to enable foreign keys on ThreadWorker" << m_id
                 << ":" << query.lastError().text();
    }

    if (!query.exec("PRAGMA busy_timeout = 10000;")) {
      qWarning() << "Failed to busy timeout on ThreadWorker" << m_id << ":"
                 << query.lastError().text();
    }
  }
  emit completedDbConnection(m_id);

  emit completeTask();
}

QString ThreadWorker::callQuery(QString filePath, QString queryTitle) {
  QFile sqlFile(filePath);
  queryTitle.append("\n");
  if (!sqlFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
    qWarning() << "Unable to open file" << filePath << "to read the queries";
    return "";
  };

  QString fileContents = sqlFile.readAll();
  QStringList textBlocks = fileContents.split(";");
  QString title = queryTitle.trimmed();
  for (QString block : textBlocks) {
    QString blockTitle = block.trimmed().section('\n', 0, 0).trimmed();
    if (blockTitle.startsWith("--")) {
      blockTitle = blockTitle.mid(2).trimmed();
    }
    if (blockTitle == title) {
      qInfo() << "Successfully found the query" << queryTitle << "on the file"
              << filePath;
      qDebug() << block;
      return block;
    }
  }

  qWarning() << "Unable to find the query" << queryTitle << "on the file"
             << filePath;
  return "";
};

void ThreadWorker::startDay() {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;

  rawQuery = callQuery(":SQL/User.sql", "startDay");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Successfully completed start day";
  } else {
    qWarning() << "The query didn't set any value" << query.lastError().text();
  }

  emit startedDay();
  emit completeTask();
}

void ThreadWorker::getExerciseData() {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;
  Exercise exercise;
  QList<Record> records;
  QList<QString> routine;

  rawQuery = callQuery(":SQL/Exercises.sql", "getExercise");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    while (query.next()) {
      exercise.id = query.value(0).toInt();
      exercise.name = query.value(1).toString();
      exercise.video = query.value(2).toString();
      exercise.guide = query.value(3).toString();
      exercise.notes = query.value(4).toString();
    }
  } else {
    qWarning() << "The query didn't select any value:"
               << query.lastError().text();
  }

  query.clear();
  rawQuery = callQuery(":SQL/Records.sql", "getRecords");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  query.bindValue(":exerciseId", exercise.id);
  if (query.exec()) {
    while (query.next()) {
      Record record;
      record.resistance = query.value(0).toString();
      record.reps = query.value(1).toString();
      record.effort = query.value(2).toString();
      record.notes = query.value(3).toString();
      record.training = query.value(4).toInt();
      records.append(record);
    }
  } else {
    qWarning() << "The query didn't select any value:"
               << query.lastError().text();
  }

  query.clear();
  rawQuery = callQuery(":SQL/Series.sql", "getRoutine");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  query.bindValue(":exerciseId", exercise.id);
  if (query.exec()) {
    while (query.next()) {
      routine.append(query.value(0).toString());
    }
  } else {
    qWarning() << "The query didn't select any value:"
               << query.lastError().text();
  }

  emit gotExerciseData(exercise, records, routine);

  emit completeTask();
}

void ThreadWorker::completeExercise(QList<Record> records) {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;
  bool dayCompleted = false;

  rawQuery = callQuery(":SQL/Records.sql", "setTodayRecord");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  for (int i = 0; i < records.length(); i++) {
    query.prepare(rawQuery);
    query.bindValue(":ord", i + 1);
    query.bindValue(":resistance", records[i].resistance);
    query.bindValue(":reps", records[i].reps);
    query.bindValue(":training", records[i].training);

    if (records[i].notes.isEmpty()) {
      query.bindValue(":notes", QVariant());
    } else {
      query.bindValue(":notes", records[i].notes);
    }

    if (query.exec()) {
      qInfo() << "Successfully added a new record";
    } else {
      qWarning() << "Error inserting a new record:" << query.lastError().text();
    }

    query.clear();
  }

  rawQuery = callQuery(":SQL/User.sql", "checkDayCompleted");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    while (query.next()) {
      qInfo() << "Successfully checked if day was completed";
      dayCompleted = query.value(0).toBool();
    }
  } else {
    qWarning() << "Error checking if day completed:"
               << query.lastError().text();
  }
  query.clear();

  if (!dayCompleted) {
    rawQuery = callQuery(":SQL/User.sql", "updateCurrentExercise");
    if (rawQuery.isEmpty()) {
      emit completeTask();
      return;
    }

    query.prepare(rawQuery);
    if (query.exec()) {
      qInfo() << "Updated current exercise successfully";
    } else {
      qWarning() << "Error updating current day" << query.lastError().text();
    }
  }

  emit completedExercise(dayCompleted);
  emit completeTask();
}

void ThreadWorker::getOnTraining() {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;
  bool onTraining;

  rawQuery = callQuery(":SQL/User.sql", "getOnTraining");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    while (query.next()) {
      onTraining = query.value(0).toBool();
      qInfo() << "Successfully got on training status";
    }
  } else {
    qWarning() << "The query didn't got any value" << query.lastError().text();
  }
  emit gotOnTraining(onTraining);

  emit completeTask();
}

void ThreadWorker::getTodayRecords() {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;

  QVariantList todayData;

  QVariantMap listElement;
  QString exercise;
  QVariantList records;
  QVariantMap record;

  rawQuery = callQuery(":SQL/Records.sql", "getTodayRecords");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Succesfully got the data from today records view table";
    while (query.next()) {
      record.clear();
      if (exercise == "") {
        exercise = query.value(0).toString();
      } else if (exercise != query.value(0).toString()) {
        listElement.insert("name", exercise);
        listElement.insert("records", records);
        todayData.append(listElement);
        records.clear();
        listElement.clear();
        exercise = query.value(0).toString();
      }

      record.insert("resistance", query.value(1).toString());
      record.insert("reps", query.value(2).toString());
      record.insert("effort", query.value(3).toString());
      record.insert("notes", query.value(4).toString());
      records.append(record);
    }
  } else {
    qWarning() << "Failed to get the data from today records view table";
  }

  emit gotTodayRecords(todayData);

  emit completeTask();
}

void ThreadWorker::completeTraining() {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;

  rawQuery = callQuery(":SQL/User.sql", "dayCompleted");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Updated on training to false";
  } else {
    qWarning() << "Error updating on training value"
               << query.lastError().text();
  }

  query.clear();
  rawQuery = callQuery(":SQL/Records.sql", "setRecords");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Sent today records to records table";
  } else {
    qWarning() << "Error sending today records to records table"
               << query.lastError().text();
  }

  query.clear();
  rawQuery = callQuery(":SQL/Records.sql", "clearTodayRecords");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Successfully cleared today records";
  } else {
    qWarning() << "Failed to clear today records" << query.lastError().text();
  }

  query.clear();
  rawQuery = callQuery(":SQL/Records.sql", "resetTodayRecords");
  if (rawQuery.isEmpty()) {
    emit completeTask();
    return;
  }

  query.prepare(rawQuery);
  if (query.exec()) {
    qInfo() << "Succesfully reset today records count";
  } else {
    qWarning() << "Failed to reset today records count"
               << query.lastError().text();
  }

  emit completedTraining();
  emit completeTask();
}
