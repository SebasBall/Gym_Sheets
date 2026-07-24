/* LIST OF CONTENTS
 * - // CLASS APPLIED MACROS | 2
 * - // QML PROPERTIES | 3
 * - // SIGNALS | 4
 * - // PUBLIC METHODS | 5
 * - // PRIVATE METHODS | 6
 * - // PRIVATE MEMBERS | 7
 * END OF CONTENTS */

#ifndef THREAD_WORKER_H
#define THREAD_WORKER_H

#include <QDebug>
#include <QDir>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>

struct Exercise {
  Q_GADGET
public:
  Q_PROPERTY(int id MEMBER id)
  Q_PROPERTY(QString name MEMBER name)
  Q_PROPERTY(QString video MEMBER video)
  Q_PROPERTY(QString guide MEMBER guide)
  Q_PROPERTY(QString notes MEMBER notes)
  int id;
  QString name;
  QString video;
  QString guide;
  QString notes;
};

struct Record {
  Q_GADGET
public:
  Q_PROPERTY(QString resistance MEMBER resistance)
  Q_PROPERTY(QString reps MEMBER reps)
  Q_PROPERTY(QString effort MEMBER effort)
  Q_PROPERTY(QString notes MEMBER notes)
  Q_PROPERTY(int training MEMBER training)
  QString resistance;
  QString reps;
  QString effort;
  QString notes;
  int training;
};

class ThreadWorker : public QObject {
  Q_OBJECT
public:
  explicit ThreadWorker(int id = 0, QObject *parent = nullptr);
  ~ThreadWorker();

  inline int getCurrentTasks() { return m_currentTasks; };

public slots:
  void startDbConnection();
  void startDay();
  void getExerciseData();
  void completeExercise(const QList<Record> records);
  void getOnTraining();
  void getTodayRecords();
  void completeTraining();

private:
  int m_currentTasks = 0;
  int m_id;
  QString m_connectionName;

  QString callQuery(QString filePath, QString queryTitle);

private slots:
  void taskAdded() {
    m_currentTasks++;
    qInfo() << "Added task on ThreadWorker" << m_id
            << "current tasks:" << m_currentTasks;
  };
  void taskCompleted() {
    m_currentTasks--;
    qInfo() << "Completed task on ThreadWorker" << m_id
            << "current tasks:" << m_currentTasks;
  };

signals:
  void completedDbConnection(int workerId);
  void addTask();
  void completeTask();
  void startedDay();
  void gotExerciseData(Exercise exercise, QList<Record> records,
                       QList<QString> routine);
  void completedExercise(bool dayCompleted);
  void gotOnTraining(bool onTraining);
  void gotTodayRecords(QVariantList todayData);
  void completedTraining();
};

#endif // THREAD_WORKER_H
