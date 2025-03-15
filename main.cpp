#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qicon.h>
#include <qlogging.h>
#include <qquickview.h>

#include "inc/ProtocolControl.h"
#include "inc/DeviceManager.h"
#include "common/QtSmartHomeGlobal.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/assets/app_icon_ai.ico"));

    DeviceManager::create(nullptr, nullptr);//需要提前初始化，否则QML中无法访问？？？
    qmlRegisterType<ProtocolControl>("QtSmartHome", 1, 0, "ProtocolControl");
    qmlRegisterSingletonType<DeviceManager>("QtSmartHome", 1, 0, "DeviceManager", DeviceManager::create);
    qmlRegisterUncreatableType<QtSmartHomeGlobal>("QtSmartHome", 1, 0, "QtSmartHomeGlobal", "Cannot instantiate global type");
    QQmlApplicationEngine engine;
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QtSmartHome", "Main");
    
    //添加图标
    if (!engine.rootObjects().isEmpty()) {
        auto window = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
        if (window) {
            //qDebug() << "window is not empty"<<QCoreApplication::applicationDirPath();
            QIcon icon("../assets/app_icon_ai.png");
            window->setIcon(icon);  
        }
    }
    return app.exec();
}
