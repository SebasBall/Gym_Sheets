#include "thread_worker.h"
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
  QString databasePath =
      QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
      "/storage.db";
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
  for (QString block : textBlocks) {
    if (block.contains(queryTitle)) {
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

  emit gotExerciseData(exercise, records);

  emit completeTask();
}

void ThreadWorker::completeExercise(QList<Record> records) {
  emit addTask();

  QSqlDatabase db = QSqlDatabase::database(m_connectionName);
  QSqlQuery query(db);
  QString rawQuery;
  bool dayCompleted = false;

  rawQuery = callQuery(":SQL/Records.sql", "setRecord");
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
