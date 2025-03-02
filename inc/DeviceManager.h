#ifndef _DEVICE_MANAGER_
#define _DEVICE_MANAGER_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class DeviceManager:public QObject{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    //生成或读取根目录下的config.JSON
    DeviceManager();//需要explicit

    Q_INVOKABLE QString test(){return testStr;};
private:
    static bool configLoaded;
    QString testStr;
    //QFile
};

#endif
