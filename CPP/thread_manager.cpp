/* LIST OF CONTENTS
 * - (QObject *) ThreadManager::ThreadManager | 18 - 53 | 15
 * - nil ThreadManager::~ThreadManager | 55 - 69 | 15
 * - void () ThreadManager::threadCountUpdate | 71 - 84 | 20
 * - void (int) ThreadManager::startDbConnection | 86 - 96 | 20
 * - void () ThreadManager::startDay | 98 - 102 | 20
 * - void () ThreadManager::getExerciseData | 104 - 108 | 20
 * - void (QVariantList) ThreadManager::completeExercise | 110 - 127 | 20
 * - void () ThreadManager::getOnTraining | 129 - 133 | 20
 * - void () ThreadManager::getTodayRecords | 135 - 139 | 20
 * - void () ThreadManager::completeTraining | 141 - 145 | 20
 * END OF CONTENTS */
#include "thread_manager.h"
#include "CPP/thread_worker.h"
#include <qeventloop.h>
#include <qlogging.h>
#include <qobjectdefs.h>

ThreadManager::ThreadManager(QObject *parent) : QObject{parent} {
  qInfo() << "Created the ThreadManager";

  m_maxThreads = QThread::idealThreadCount() - 1;
  if (m_maxThreads <= 0) {
    m_maxThreads = 1;
  }

  for (int i = 0; i < m_maxThreads; i++) {
    QThread *newThread = new QThread();
    ThreadWorker *newWorker = new ThreadWorker(i);

    m_threadList.append(newThread);
    m_workersList.append(newWorker);

    newWorker->moveToThread(newThread);
    newThread->start();

    connect(newWorker, &ThreadWorker::completedDbConnection, this,
            &ThreadManager::startDbConnection);
    connect(newWorker, &ThreadWorker::gotExerciseData, this,
            &ThreadManager::gotExerciseData);
    connect(newWorker, &ThreadWorker::startedDay, this,
            &ThreadManager::startedDay);
    connect(newWorker, &ThreadWorker::completedExercise, this,
            &ThreadManager::completedExercise);
    connect(newWorker, &ThreadWorker::gotOnTraining, this,
            &ThreadManager::gotOnTraining);
    connect(newWorker, &ThreadWorker::gotTodayRecords, this,
            &ThreadManager::gotTodayRecords);
    connect(newWorker, &ThreadWorker::completedTraining, this,
            &ThreadManager::completedTraining);
  }

  startDbConnection(m_threadCounter);
}

ThreadManager::~ThreadManager() {
  for (int i = 0; i < m_workersList.size(); ++i) {
    m_workersList[i]->deleteLater();
  }

  for (int i = 0; i < m_threadList.size(); ++i) {
    m_threadList[i]->quit();
    m_threadList[i]->wait();
  }

  qDeleteAll(m_threadList);
  m_threadList.clear();
  m_workersList.clear();
  qInfo() << "Deleted the ThreadManager";
}

void ThreadManager::threadCountUpdate() {
  m_threadCounter++;

  if (m_threadCounter >= m_maxThreads) {
    m_threadCounter = 0;
  }

  for (int i = 0; i < m_maxThreads; i++) {
    if (m_workersList[i]->getCurrentTasks() <
        m_workersList[m_threadCounter]->getCurrentTasks()) {
      m_threadCounter = i;
    }
  }
}

void ThreadManager::startDbConnection(int workerId) {
  if (workerId + 1 < m_maxThreads) {
    workerId++;
    QMetaObject::invokeMethod(m_workersList[workerId], "startDbConnection");
  } else {
    for (int i = 0; i < m_workersList.size(); ++i) {
      disconnect(m_workersList[i], &ThreadWorker::completedDbConnection, this,
                 &ThreadManager::startDbConnection);
    }
  }
}

void ThreadManager::startDay() {
  qDebug() << "Thread Manager: Sent start day request";
  threadCountUpdate();
  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "startDay");
}

void ThreadManager::getExerciseData() {
  qDebug() << "Thread Manager: Sent get exercise data request";
  threadCountUpdate();
  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "getExerciseData");
}

void ThreadManager::completeExercise(QVariantList records) {
  qDebug() << "Thread Manager: Sent get records data request";
  threadCountUpdate();
  QList<Record> recordsList;

  for (const QVariant &row : records) {
    QVariantList r = row.toList();
    Record record;
    record.resistance = r[0].toString();
    record.reps = r[1].toString();
    record.notes = r[2].toString();
    record.training = r[3].toInt();
    recordsList.append(record);
  }

  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "completeExercise",
                            Q_ARG(QList<Record>, recordsList));
}

void ThreadManager::getOnTraining() {
  qDebug() << "Thread Manager: Sent get on training request";
  threadCountUpdate();
  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "getOnTraining");
}

void ThreadManager::getTodayRecords() {
  qDebug() << "Thread Manager: Sent get today records request";
  threadCountUpdate();
  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "getTodayRecords");
}

void ThreadManager::completeTraining() {
  qDebug() << "Thread Manager: Sent complete training request";
  threadCountUpdate();
  QMetaObject::invokeMethod(m_workersList[m_threadCounter], "completeTraining");
}
