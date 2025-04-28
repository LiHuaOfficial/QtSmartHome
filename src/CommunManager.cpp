#include <iostream>

#include <QDebug>
#include <QByteArray>

#include "boost/asio.hpp"

#include "common/QtSmartHomeGlobal.h"
#include "inc/CommunManager.h"
#include "inc/DeviceManager.h"
#include "SocketServer.h"

CommunManager::CommunManager()
{
    //创建中间线程
    std::thread *communManagerThread=new std::thread([this]() {
        
        boost::asio::io_context io_context;

        boost::asio::steady_timer timer(io_context, communManagerThreadInteval);//定时器

        std::function<void(const boost::system::error_code&)> timer_handler = [&](const boost::system::error_code& error) {
            if (!error) {
                qDebug()<<"CM:timer work"<<QThread::currentThreadId();

                //根据命令创建线程或结束线程
                std::lock_guard<std::mutex> lock(sendQueueMutex);
                if(!sendQueue.empty()){//非空
                    if(sendQueue.front().getMessageType()==CommunMessage::MessageType::TypeSyscmd &&
                       sendQueue.front().getSyscmdMessageType()==CommunMessage::SyscmdMessageType::BoolStatus){//是控制命令

                        std::pair<int,bool> cmd={sendQueue.front().getId(),sendQueue.front().getStatus()};

                        std::lock_guard<std::mutex> lock(threadStatusMutex);
                        if (threadStatusMap[cmd.first].first!=cmd.second)//有效命令
                        {
                            if (cmd.second)//开启
                            {
                                deviceEnable(cmd.first);

                                threadStatusMap[cmd.first].first=true;
                                threadStatusMap[cmd.first].second=nullptr;
                                //sendData(1,"hello",true);//测试发送无误
                            }else{
                                //结束线程
                                threadStatusMap[cmd.first].first=false;//子线程检测这个值为false时结束
                                if(threadStatusMap[cmd.first].second!=nullptr){
                                    threadStatusMap[cmd.first].second->stop();
                                }
                            }
                        }
                        sendQueue.pop();
                    }else if(sendQueue.front().getMessageType()==CommunMessage::MessageType::TypeData &&
                             threadStatusMap[sendQueue.front().getId()].first==false){//该消息对应设备已关闭
                                sendQueue.pop();
                    }
                }
                timer.expires_after(communManagerThreadInteval);
                timer.async_wait(timer_handler);
            }else{

            }            
        };
        timer.async_wait(timer_handler);
        io_context.run();
    });
    communManagerThread->detach();
}

void CommunManager::SocketWork(int id,int port){

    auto socketThread=std::make_shared<std::thread>([this,id,port]() {
        using namespace boost::asio;
        try {
            
            auto io_context=std::make_shared<boost::asio::io_context>();
            
            threadStatusMutex.lock();
            threadStatusMap[id].second=io_context;
            threadStatusMutex.unlock();
            //TODO:server数据接收，数据发送，关闭server(context stop)
            SocketServer s(id,*io_context, port);

            io_context->run();
            qDebug()<<"CM:subthread end";
        } catch (std::exception& e) {
            std::cerr << "Exception: " << e.what() << std::endl;
        }

    });
    socketThread->detach();
}

void CommunManager::deviceEnable(int id)
{
    qDebug()<<"CM:deviceEnable:"<<id;
    //关注信息的生存期问题
    auto& info=DeviceManager::getInstance(nullptr,nullptr)->getDeviceInfoRaw(id);
    
    switch (info.getDeviceType()) {
        case QtSmartHomeGlobal::DeviceType::Socket: {
            
            SocketWork(id,info.configInfoValue[1].toInt());
            break;   
        }
        default: {
            break;
        }
    }
}

void CommunManager::recvData(int id,std::string data){
    //TODO:解析数据，调用这个函数
    //DeviceManager::getInstance(nullptr,nullptr)->addDataToMap()
    QJsonDocument recvDoc=QJsonDocument::fromJson(QByteArray(data.c_str()));
    QJsonObject rootObj=recvDoc.object();
    auto variablesMap=rootObj.toVariantMap();

    auto chartData=variablesMap["ChartData"].toMap();
    auto dataMap=variablesMap["Data"].toMap();

    qDebug()<<"CM:recvData:"<<id<<data;
    for(auto it=chartData.begin();it!=chartData.end();it++){
        qDebug()<<"CM:recvChartData:"<<id<<it.key()<<it.value().toString();
        DeviceManager::getInstance(nullptr,nullptr)->addDataToMap(id,it.key(),it.value().toString(),true);
    }
    for(auto it=dataMap.begin();it!=dataMap.end();it++){
        qDebug()<<"CM:recvData:"<<id<<it.key()<<it.value().toString();
        DeviceManager::getInstance(nullptr,nullptr)->addDataToMap(id,it.key(),it.value().toString()); 
    }
}

