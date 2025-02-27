#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qquickview.h>

#include "inc/ProtocolControl.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    //qmlRegisterType<ProtocolControl>("QtSmartHome", 1, 0, "ProtocolControl");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QtSmartHome", "Main");

    return app.exec();
}
