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
#include "boost/asio.hpp"
#include "inc/DeviceInfo.h"
#include "inc/CommunMessage.h"
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


    //---------------call by DeviceManager----------------
    //前端发出控制线程开始或关闭命令
    void changeDeviceStatus(int id,bool status){
        sendQueue.push(CommunMessage(id,status));
    };
    //前端放入信息
    void sendData(int id,std::string variable,bool status){
        sendQueue.push(CommunMessage(id,CommunMessage::TypeData,"{"+variable+":"+(status?"true":"false")+"}"));
    }

    //---------------for server---------------------------
    //Server获取队列中数据
    std::string getSendData(int id){
        std::lock_guard<std::mutex> lock(sendQueueMutex);
        if(!sendQueue.empty() && sendQueue.front().getMessageType()==CommunMessage::MessageType::TypeData &&sendQueue.front().getId()==id){//是自己的消息
            std::string data=sendQueue.front().getData();
            sendQueue.pop();
            return data;
        }
        return "";
    }

    bool getThreadStatus(int id){
        std::lock_guard<std::mutex> lock(threadStatusMutex);
        return threadStatusMap[id].first;
    }

    //Server从接收队列中获取数据
    void recvData(CommunMessage&& msg){
        qDebug()<<"recv"<<msg.getData();
        std::lock_guard<std::mutex> lock(recvQueueMutex);
        recvQueue.push(msg);
    }
    //Server从接收队列中获取数据,发现好像没必要多此一举套一个CommunMessage
    void recvData(int id,std::string data);
private:
    void SocketWork(int id,int port);

    void deviceEnable(int id);

    //以下是通信线程（中间件，负责把队列信息搬入搬出，创建新的子线程）的管理
    //队列中直接保存json字符串
    std::mutex sendQueueMutex;
    std::queue<CommunMessage> sendQueue;

    std::mutex recvQueueMutex;
    std::queue<CommunMessage> recvQueue;

    std::mutex threadStatusMutex;
    std::unordered_map<int,std::pair<bool,std::shared_ptr<boost::asio::io_context> >> threadStatusMap; 

    const std::chrono::milliseconds communManagerThreadInteval{5000}; 
};

#endif
