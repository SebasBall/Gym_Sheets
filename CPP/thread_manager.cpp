#include "thread_manager.h"
#include "CPP/thread_worker.h"
#include <qlogging.h>

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
  }

  startDbConnection(-1);
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
