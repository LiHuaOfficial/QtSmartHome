#ifndef _QTSMARTHOMEGLOBAL_H_
#define _QTSMARTHOMEGLOBAL_H_

#include <QObject>
#include <QtQml>

class QtSmartHomeGlobal:public QObject{
    Q_OBJECT
    QML_ELEMENT
    //QML_UNCREATABLE("global info obj")//main.cpp中已经设置了不可实例化

public:
    enum DeviceType{Socket,BLE,HTTP};
    Q_ENUM(DeviceType)
};

#endif
