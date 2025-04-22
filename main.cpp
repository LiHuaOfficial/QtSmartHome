#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qicon.h>
#include <qlogging.h>
#include <qquickview.h>

#include "inc/DeviceManager.h"
#include "inc/CommunManager.h"
#include "common/QtSmartHomeGlobal.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/assets/app_icon_ai.ico"));

    qDebug() << "QtSmartHome main thread id:" << QThread::currentThreadId();
    
    CommunManager::getInstance(nullptr, nullptr);
    DeviceManager::getInstance(nullptr, nullptr);
    
    //auto t=DeviceManager::getInstance(nullptr, nullptr)->getDeviceInfoRaw2(1);
    //需要提前初始化，否则QML中无法访问？？？
    // QObject::connect(DeviceManager::getInstance(nullptr, nullptr),&DeviceManager::deviceEnable,
    //                  CommunManager::getInstance(nullptr, nullptr),&CommunManager::changeDeviceStatus);

    //测试用
    // QObject::connect(CommunManager::getInstance(),&CommunManager::triggerDeviceEnable,
    //                 CommunManager::getInstance(),&CommunManager::testWork2);
    
    // auto cm = CommunManager::getInstance();

    // cm->testWork();
    // cm->testWork2();//槽函数内可以创建线程


    //DeviceManager::create(nullptr, nullptr)->deviceEnable(1);

    //qmlRegisterSingletonType<CommunManager>("QtSmartHome", 1, 0, "CommunManager", CommunManager::getInstance);
    qmlRegisterSingletonType<DeviceManager>("QtSmartHome", 1, 0, "DeviceManager", DeviceManager::getInstance);
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
