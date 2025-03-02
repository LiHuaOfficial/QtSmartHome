#include "inc/DeviceManager.h"

DeviceManager::DeviceManager():configFile(QCoreApplication::applicationDirPath()+"/config.json"){
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
    }
    //初始化所有id以待取用，（初始化移到初始化QMLengine前会不会好些？）
    for(int i=1;i<=MAX_ID_NUM;i++){
        idSet.insert(i);
    }
    //把信息装入DeviceInfo
    //分配id，后续前端也可以通过map访问通信对象
    //id先对应一个配置信息对象->所有配置信息和关注的所有变量（发送端发送_变量：值_的格式）
    //默认不打开设备，打开设备后示例化通信对象
    //(通信不要写在主线程里面！！！)
    //所以在id实例化前id还是用map对应配置信息

    //DeviceInfo待实现，先实现ID功能
    //对每一个deviceInfo
    //idInfoMap[getID()]=DeviceInfo
}

int DeviceManager::getID(){
    if(!idSet.empty()){
        int res=*idSet.begin();
        idSet.erase(idSet.begin());
        return res;
    }else{
        return -1;
    }
}

bool DeviceManager::freeID(int id){
    return idSet.insert(id).second;
}

int DeviceManager::addDevice(DeviceInfo info){

}
