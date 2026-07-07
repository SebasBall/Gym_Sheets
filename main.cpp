#include "thread_manager.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <cstdio>
#include <qlogging.h>
#include <qobject.h>

void colorMessageHandler(QtMsgType type, const QMessageLogContext &,
                         const QString &msg) {
  const char *color = "\033[0m";
  switch (type) {
  case QtDebugMsg:
    color = "\033[36m";
    break;
  case QtInfoMsg:
    color = "\033[32m";
    break;
  case QtWarningMsg:
    color = "\033[33m";
    break;
  case QtCriticalMsg:
    color = "\033[31m";
    break;
  case QtFatalMsg:
    color = "\033[41m";
    break;
  }
  fprintf(stderr, "%s%s\033[0m\n", color, msg.toStdString().c_str());
}

int main(int argc, char *argv[]) {
  qInstallMessageHandler(colorMessageHandler);
  //  qRegisterMetaType<Exercise>("Exercise");
  //  qRegisterMetaType<QList<Record>>("QList<Record>");

  QCoreApplication::setOrganizationName("SebApps");
  QCoreApplication::setApplicationName("Gym_Sheets");
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  engine.singletonInstance<ThreadManager *>("Gym_Sheets", "ThreadManager");
  engine.loadFromModule("Gym_Sheets", "Main");
  return app.exec();
}
