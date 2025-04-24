#include "inc/CommunManager.h"
#include "inc/DeviceManager.h"

#include "common/QtSmartHomeGlobal.h"

#include <QDebug>

#include "boost/asio.hpp"

#include <iostream>
#include "CommunManager.h"

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
                if(!sendQueue.empty() &&
                    sendQueue.front().getMessageType()==CommunMessage::MessageType::TypeSyscmd &&
                    sendQueue.front().getSyscmdMessageType()==CommunMessage::SyscmdMessageType::BoolStatus){//有控制命令

                    std::pair<int,bool> cmd={sendQueue.front().getId(),sendQueue.front().getStatus()};

                    std::lock_guard<std::mutex> lock(threadStatusMutex);
                    if (threadStatusMap[cmd.first]!=cmd.second)//有效命令
                    {
                        if (cmd.second)//开启
                        {
                            deviceEnable(cmd.first);

                            threadStatusMap[cmd.first]=true;//TODO：一段时间内禁止调整
                        }else{
                            //结束线程
                            //TODO:调用io_context.stop()？
                            threadStatusMap[cmd.first]=false;//子线程检测这个值为false时结束
                        }
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

     std::thread *socketThread=new std::thread([this,id,port]() {
        using namespace boost::asio;
        try {
            boost::asio::io_context io_context;

            //TODO:server数据接收，数据发送，关闭server(context stop)
            SocketServer s(io_context, port);

            io_context.run();
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

