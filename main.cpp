#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "client.h"
#include <QQmlContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeComponent>
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

//    QtQuick2ApplicationViewer viewer;

    qmlRegisterType<Client>("Clients", 1,0, "Client");

    QQmlApplicationEngine engine;

    Client client(static_cast<QObject*>(&app), &engine);

    engine.rootContext()->setContextProperty("client", &client);
    qDebug() << engine.rootContext()->contextProperty("connectionModel");

    engine.load("qml/TheMaster/main.qml");

    //engine.setMainQmlFile(QStringLiteral("qml/TheMaster/main.qml"));
    //engine.showExpanded();

    return app.exec();
}
