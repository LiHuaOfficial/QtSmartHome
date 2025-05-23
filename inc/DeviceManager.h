#ifndef _DEVICE_MANAGER_
#define _DEVICE_MANAGER_

#include <string>

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <qlist.h>
#include <qobject.h>
#include <qtmetamacros.h>
#include <qvariant.h>
#include <set>
#include <QMap>
#include <QByteArray>

#include "QtSmartHomeGlobal.h"
#include "inc/DeviceInfo.h"
#include "inc/CommunManager.h"
#include "inc/VariableInfo.h"

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

    //Map中仅包含variables信息（效率有点低，考虑优化？）
    Q_INVOKABLE QVariantMap getDeviceInfo(int id,bool variablesOnly=false){
        if(variablesOnly){//仅返回variables信息
            return idInfoMap[id].getDeviceVariablesMap();
        }
        auto variablesMap=idInfoMap[id].getDeviceVariablesMap();//command,data,dataOnChart
        variablesMap.insert("name",idInfoMap[id].getDeviceName());
        variablesMap.insert("type",idInfoMap[id].getDeviceType());
        //variablesMap.insert("id",)
        return variablesMap;
    };
    
    Q_INVOKABLE void changeDeviceStatus(int id,bool status){
        CommunManager::getInstance(nullptr,nullptr)->changeDeviceStatus(id,status);
    }

    //开始通信后被调用，后续实现删除设备的功能要注意这里引用的问题
    DeviceInfo& getDeviceInfoRaw(int id){
        //由于DeviceInfo没有拷贝构造函数，返回值会报错(值为nullptr好像不会报错？)
        return idInfoMap[id];
    };

    bool addDataToMap(int id,QString key,QString value,bool isChartData=false){
        if(!getIdDataMap().contains(id)){//不存在
            return false;
        }
        if(isChartData){ 
            return getIdDataMap()[id].addToChartData(key,value);
        }else{
            return getIdDataMap()[id].addToData(key,value);
        }
        return false;
    };

    //前端获取DataMap信息
    Q_INVOKABLE QString getDeviceData(int id,QString key){
        return getIdDataMap()[id].getData(key);
    }
    //前端发送信息
    Q_INVOKABLE void sendToDevice(int id,QString key,bool value){

       CommunManager::getInstance(nullptr,nullptr)->sendData(id,key.toStdString(),value);
    }
signals:
    //所有错误将通过信号和其参数发出,前端全局通知
    void deviceAdded(int id);
    void deviceManagerError(QString errorMsg);
    
private:
    using IDSet=std::set<int>;
    IDSet freeIdSet,idSet;  
    //获取唯一标识设备的ID
    int getID();
    bool freeID(int id);
    
    /*
    在创建子线程和添加设备时访问，可以保证线程安全。
    */
    using IDInfoMap=QMap<int,DeviceInfo>;
    IDInfoMap idInfoMap;

    /*
    前端访问，后端写入需要加锁。
    */
    std::mutex idDataMapMtx;
    QMap<int,VariableInfo> idDataMap;
    QMap<int,VariableInfo>& getIdDataMap(){
        std::lock_guard<std::mutex> lock(idDataMapMtx);
        return idDataMap;
    }
    
    QString testStr;
    QFile configFile;
    //通过id找到对应信息，要求QML也能访问（用方法实现访问比较好）



};

#endif
