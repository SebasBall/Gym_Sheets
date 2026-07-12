#ifndef THREAD_MANAGER_H
#define THREAD_MANAGER_H

#include "thread_worker.h"
#include <QDebug>
#include <QObject>
#include <QQmlEngine>
#include <QThread>

class ThreadManager : public QObject {
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON
public:
  // Methods
  explicit ThreadManager(QObject *parent = nullptr);
  ~ThreadManager();

  Q_INVOKABLE void startDay();
  Q_INVOKABLE void getExerciseData();
  Q_INVOKABLE void completeExercise(QVariantList records);

private:
  // Methods
  void threadCountUpdate();

  // Member variables
  QList<QThread *> m_threadList;
  QList<ThreadWorker *> m_workersList;
  int m_threadCounter = -1;
  int m_maxThreads;

private slots:
  void startDbConnection(int workerId);

signals:
  void startedDay();
  void gotExerciseData(Exercise exercise, QList<Record> records);
  void completedExercise(bool dayCompleted);
};

#endif // THREAD_MANAGER_H
