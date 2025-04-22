#ifndef COMMUNMANAGER_H
#define COMMUNMANAGER_H

#include <atomic>
#include <memory>
#include <queue>
#include <chrono>
#include <thread>

#include <QObject>
#include <QThread>
#include <thread>
#include <QMap>

#include "boost/lockfree/queue.hpp"

#include "inc/DeviceInfo.h"
/*
这个类将作为qml上下文出现，qml可以直接获取信号
engine.rootContext()->setContextProperty("worker", &worker);//如此便可获取worker的信号

关于设备通信管理
当DM::deviceEnable被调用
触发这里的槽函数
针对不同协议做不同处理
*/
class CommunManager{

public:
    explicit CommunManager();
    
    static CommunManager* getInstance(QQmlEngine* engine, QJSEngine* scriptEngine){
        static CommunManager instance;
        return &instance;
    }



    void changeDeviceStatus(int id,bool status){
        std::lock_guard<std::mutex> lock(sendQueueMutex);
        sendQueue.push(std::make_pair(id,status));
    };
    
    
private:
    
    void SocketWork(int id,int port);
    enum { max_buffer_length = 1024 };

    void deviceEnable(int id);
    //以下是通信线程（中间件，负责把队列信息搬入搬出，创建新的子线程）的管理
    std::mutex sendQueueMutex;
    std::queue<std::pair<int,bool>> sendQueue;

    std::mutex recvQueueMutex;
    //std::queue<std::pair<bool,int>> recvQueue;

    std::mutex threadStatusMutex;
    std::unordered_map<int,bool> threadStatusMap; 

    const std::chrono::milliseconds communManagerThreadInteval{5000}; 
};

#endif
