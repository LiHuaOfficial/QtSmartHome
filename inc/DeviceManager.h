#ifndef _DEVICE_MANAGER_
#define _DEVICE_MANAGER_

#include <QtQml>
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <set>
#include <QMap>

#include "inc/DeviceInfo.h"

class DeviceManager:public QObject{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    const int MAX_ID_NUM=20;

    //生成或读取根目录下的config.JSON
    explicit DeviceManager();

    //在QML前初始化
    static DeviceManager* create(QQmlEngine* engine, QJSEngine* scriptEngine) {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        static DeviceManager instance;
        return &instance;
    };

    Q_INVOKABLE QString test(){return testStr;};
    Q_INVOKABLE int addDevice(DeviceInfo info);
signals:
    //所有错误将通过信号和其参数发出,前端全局通知
    void error_json(int idx);
private:
    using IDSet=std::set<int>;
    using IDInfoMap=QMap<int,DeviceInfo>;

    QString testStr;
    QFile configFile;
    IDSet idSet;
    IDInfoMap idInfoMap;
    //通过id找到对应信息，要求QML也能访问（用方法实现访问比较好）


    //获取唯一标识设备的ID
    int getID();
    bool freeID(int id);
};

#endif
