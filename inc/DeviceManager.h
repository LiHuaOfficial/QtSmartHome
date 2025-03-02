#ifndef _DEVICE_MANAGER_
#define _DEVICE_MANAGER_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class DeviceManager:public QObject{
    QObject

    QML_ELEMENT

public:
    explicit DeviceManager(QObject* parent = nullptr) : QObject(parent) {}
    //生成或读取根目录下的config.JSON
    bool initDevices();

};

#endif
