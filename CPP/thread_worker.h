#ifndef THREAD_WORKER_H
#define THREAD_WORKER_H

#include <QDebug>
#include <QDir>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>

class ThreadWorker : public QObject {
  Q_OBJECT
public:
  explicit ThreadWorker(int id = 0, QObject *parent = nullptr);
  ~ThreadWorker();

  inline int getCurrentTasks() { return m_currentTasks; };

public slots:
  void startDbConnection();

private:
  int m_currentTasks = 0;
  int m_id;
  QString m_connectionName;

private slots:
  void taskAdded() {
    qInfo() << "Added task on ThreadWorker" << m_id;
    m_currentTasks++;
  };
  void taskCompleted() {
    qInfo() << "Completed task on ThreadWorker" << m_id;
    m_currentTasks--;
  };

signals:
  void completedDbConnection(int workerId);
  void addTask();
  void completeTask();
};

#endif // THREAD_WORKER_H
