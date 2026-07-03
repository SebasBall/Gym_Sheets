#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
  QCoreApplication::setOrganizationName("SebApps");
  QCoreApplication::setApplicationName("Gym_Sheets");
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  engine.loadFromModule("Gym_Sheets", "Main");
  return app.exec();
}
