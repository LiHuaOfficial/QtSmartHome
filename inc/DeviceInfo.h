#ifndef _DEVICE_INFO_
#define _DEVICE_INFO_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <qcontainerfwd.h>
#include <qvariant.h>

#include "common/QtSmartHomeGlobal.h"

/*
这个类用于校验不同类型设备的ConfigInfo和ConfigInfoValue是否符合要求
*/
class DeviceInfoCheck{
public:
    virtual ~DeviceInfoCheck(){};
    //校验值的合法性返回不合法值的位置，0表示合法
    virtual int checkInfo(QVariantList& cfgInfo)=0;
};

class DeviceInfoCheckSocket:public DeviceInfoCheck{
public:
    ~DeviceInfoCheckSocket()override {};

    const QVariantList socketInfo={"ip","port"};
    //校验值的合法性返回不合法值的位置，0表示合法，1表示ip不合法，.......
    int checkInfo(QVariantList& cfgInfo) override;
};

class DeviceInfo{
public:
    //enum DeviceType{Socket,BLE,HTTP};
    using DeviceType=QtSmartHomeGlobal::DeviceType;
    
    DeviceInfo(){};
    DeviceInfo(QString dvName,DeviceType dvType,QVariantList cfgInfoValue,
        QVariantMap vars,QString varOnApp):deviceName(dvName),deviceType(dvType),
                configInfoValue(cfgInfoValue),variablesMap(vars),variableOnApp(varOnApp){
        switch (dvType) {
        case DeviceType::Socket:
            check=new DeviceInfoCheckSocket();
            break;
        default:
            return;//没实现功能的就不校验了
            break;
        }
        badInfo=check->checkInfo(cfgInfoValue);
    };

    //void setVariablesMap(QVariantMap map){variablesMap=map;};

    //return reference
    QVariantMap& getDeviceVariablesMap(){return variablesMap;};
    //return reference
    QString& getDeviceName(){return deviceName;};
    //return reference
    DeviceType& getDeviceType(){return deviceType;};

    //vaild Info returns false
    int getInfoCode(){return badInfo;};

    ~DeviceInfo(){
        delete check;
    };

//private:
    int8_t badInfo;

    QString deviceName;
    DeviceType deviceType;
    QVariantList configInfoValue;
    //QVector<QVector<QString>> variables;
    QVariantMap variablesMap;
    QString variableOnApp;

    DeviceInfoCheck* check;
};
#endif
