#include "inc/DeviceManager.h"

DeviceManager::DeviceManager(){
    testStr="hello";
    auto appDir=QCoreApplication::applicationDirPath();
    qDebug()<<"CurrentAppDir"<<appDir<<Qt::endl;
}

// DeviceManager *DeviceManager::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine){
//     DeviceManager *result=nullptr;
//     result=new DeviceManager();
//     return result;
// }
