#include "thread_worker.h"
#include <qhashfunctions.h>
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
