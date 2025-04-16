#ifndef COMMUNMANAGER_H
#define COMMUNMANAGER_H

#include <QObject>

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
    void communManagerReceivedData(int id,QString variable,QString data);

public slots:
    void deviceEnable(int id);
};

#endif
