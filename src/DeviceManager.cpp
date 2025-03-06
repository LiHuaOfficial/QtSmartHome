#include "inc/DeviceManager.h"
#include "DeviceInfo.h"
#include <cstdio>
#include <qcontainerfwd.h>
#include <qdebug.h>
#include <qjsonarray.h>
#include <qjsonobject.h>
#include <qlogging.h>

void ConvertJsonArrayToQVector(QJsonArray &jsonArray, QVector<QString> &vector) {
    for (int i = 0; i < jsonArray.size(); i++) {
        vector.push_back(jsonArray.at(i).toString());
    }
}
DeviceManager::DeviceManager():configFile(QCoreApplication::applicationDirPath()+"/config.json"){
    qDebug()<<configFile.fileName();
    
    //初始化所有id以待取用，（初始化移到初始化QMLengine前会不会好些？）
    for(int i=1;i<=MAX_ID_NUM;i++){
        freeIdSet.insert(i);
    }

    //读取或创建JSON配置信息
    if(!configFile.exists()){
        //仅创建结构,源程序根目录下有JSON文件的格式
        QJsonObject rootObj;
        QJsonArray devicesArray;
        rootObj.insert("devices",devicesArray);
        if(configFile.open(QIODevice::WriteOnly)){
            configFile.write(QJsonDocument(rootObj).toJson(QJsonDocument::Indented));
            configFile.close();
            return;
        }else{
            //文件打开失败，发送信号，前端至少得显示吧
        }
    }else{
        //读取JSON文件
        if(configFile.open(QIODevice::ReadOnly)){
            QJsonDocument doc=QJsonDocument::fromJson(configFile.readAll());
            QJsonObject rootObj=doc.object();
            QJsonArray devicesArray=rootObj.value("devices").toArray();
            for(int i=0;i<devicesArray.size();i++){
                QJsonObject deviceObj=devicesArray.at(i).toObject();

                QJsonArray cfgInfo=deviceObj.value("config").toArray();
                QJsonObject variables=deviceObj.value("variables").toObject();
                
                QVector<QString> vecCfgInfo,vecVarCmd,vecVarData,vecVarDataOnChart;
                
                ConvertJsonArrayToQVector(cfgInfo,vecCfgInfo);

                QVector<QVector<QString>> vec={vecVarCmd,vecVarData,vecVarDataOnChart};
                DeviceInfo info(deviceObj.value("name").toString(),
                                static_cast<DeviceInfo::DeviceType>(deviceObj.value("type").toInt()),
                                vecCfgInfo,
                                variables.toVariantMap(),
                                deviceObj.value("variableOnApp").toString());

                int infoCode=info.isBadInfo();
                if(!infoCode) {
                    idInfoMap.insert(getID(),info);
                    qDebug()<<"info added";
                }else{
                    qDebug()<<QString("Error:infocode %1").arg(infoCode);
                }
                
            }
            configFile.close();
        }
    }
    //把信息装入DeviceInfo
    //分配id，后续前端也可以通过map访问通信对象
    //id先对应一个配置信息对象->所有配置信息和关注的所有变量（发送端发送_变量：值_的格式）
    //默认不打开设备，打开设备后示例化通信对象
    //(通信不要写在主线程里面！！！)
    //所以在id实例化前id还是用map对应配置信息

    /*
    在MainView中onComplete时读入
    */
    
}

int DeviceManager::getID(){
    if(!freeIdSet.empty()){
        int res=*freeIdSet.begin();
        freeIdSet.erase(freeIdSet.begin());
        idSet.insert(res);
        return res;
    }else{
        return -1;
    }
}

bool DeviceManager::freeID(int id){
    idSet.erase(id);
    return freeIdSet.insert(id).second;
}

//将信息固化到本地
int DeviceManager::addDevice(DeviceInfo info){

}

int DeviceManager::orderlyGetID(){
    static auto it=idSet.begin();
    if(it==idSet.end()){
        it=idSet.begin();
        return -1;
    }else{
        return *it++;
    }
}