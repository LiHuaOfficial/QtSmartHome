#ifndef COMMUNMANAGER_H
#define COMMUNMANAGER_H

#include <QObject>
#include <QThread>
#include <thread>
/*
这个类将作为qml上下文出现，qml可以直接获取信号
engine.rootContext()->setContextProperty("worker", &worker);//如此便可获取worker的信号

关于设备通信管理
当DM::deviceEnable被调用
触发这里的槽函数
针对不同协议做不同处理
*/
class CommunManager : public QObject{
    Q_OBJECT
public:
    explicit CommunManager(QObject *parent = nullptr);
    
    static CommunManager* getInstance(){
        static CommunManager instance;
        return &instance;
    }



signals:
    //底层通信模块收到数据的信号，传递到gui层
    void communManagerReceivedData(int id,QString variable,QString data);
    
    //测试用，触发deviceEnable槽函数
    void triggerDeviceEnable(int id);
public slots:
    //DeviceManager::deviceEnable触发
    //根据id获取设备信息，然后根据协议发送数据
    void deviceEnable(int id);

    //测试用
    void testWork();
    //测试用
    void testWork2();
private:

    QMap<int,std::thread> enabledSocketMap;
};

#endif
