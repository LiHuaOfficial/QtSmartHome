#ifndef _DEVICE_MANAGER_
#define _DEVICE_MANAGER_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <qlist.h>
#include <qobject.h>
#include <qtmetamacros.h>
#include <qvariant.h>
#include <set>
#include <QMap>

#include "QtSmartHomeGlobal.h"
#include "inc/DeviceInfo.h"
#include "inc/CommunManager.h"

class DeviceManager:public QObject{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    using DeviceType=QtSmartHomeGlobal::DeviceType;

    const int MAX_ID_NUM=20;//id:1~MAX_ID_NUM

    //生成或读取根目录下的config.JSON
    explicit DeviceManager();
    ~DeviceManager();
    
    //在QML前初始化
    static DeviceManager* getInstance(QQmlEngine* engine, QJSEngine* scriptEngine) {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        static DeviceManager instance;
        return &instance;
    };

    Q_INVOKABLE QString test(){return testStr;};
    Q_INVOKABLE int addDevice(DeviceInfo info);
    //qml 能调用的函数不支持自定义类型
    Q_INVOKABLE void addDevice(QString name,int type,QVariantMap variablesMap,QVariantList config,QString displayedData="None");
    //(会不会有被并发访问的问题)从第一个值开始，每调用一次返回一个ID，直到返回-1
    Q_INVOKABLE int orderlyGetID();

    //Map中仅包含variables信息
    Q_INVOKABLE QVariantMap getDeviceInfo(int id){
        auto variablesMap=idInfoMap[id].getDeviceVariablesMap();//command,data,dataOnChart
        variablesMap.insert("name",idInfoMap[id].getDeviceName());
        variablesMap.insert("type",idInfoMap[id].getDeviceType());
        //variablesMap.insert("id",)
        return variablesMap;
    };
    
    Q_INVOKABLE void changeDeviceStatus(int id,bool status){
        CommunManager::getInstance(nullptr,nullptr)->changeDeviceStatus(id,status);
    }

    //后续实现删除设备的功能要注意这里引用的问题
    DeviceInfo& getDeviceInfoRaw(int id){
        //由于DeviceInfo没有拷贝构造函数，返回值会报错(值为nullptr好像不会报错？)
        return idInfoMap[id];
    };

signals:
    //所有错误将通过信号和其参数发出,前端全局通知
    void deviceAdded(int id);
    void deviceManagerError(QString errorMsg);
    
private:
    using IDSet=std::set<int>;
    using IDInfoMap=QMap<int,DeviceInfo>;

    QString testStr;
    QFile configFile;

    IDSet freeIdSet,idSet;
    
    IDInfoMap idInfoMap;
    
    //通过id找到对应信息，要求QML也能访问（用方法实现访问比较好）


    //获取唯一标识设备的ID
    int getID();
    bool freeID(int id);
};

#endif
