#ifndef _DEVICE_INFO_
#define _DEVICE_INFO_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>

class DeviceInfo{
public:
    DeviceInfo(QString dvName):deviceName(){};
private:
    QString deviceName;
};
#endif
