#include "inc/CommunManager.h"
#include "inc/DeviceManager.h"

#include "common/QtSmartHomeGlobal.h"

#include <QDebug>

#include "boost/asio.hpp"

#include <iostream>

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
                if(!sendQueue.empty()){
                    auto cmd=sendQueue.front();
                    std::lock_guard<std::mutex> lock(threadStatusMutex);
                    if (threadStatusMap[cmd.first]!=cmd.second)//有效命令
                    {
                        if (cmd.second)//开启
                        {
                            deviceEnable(cmd.first);

                            threadStatusMap[cmd.first]=true;
                        }else{
                            //结束线程
                            threadStatusMap[cmd.first]=false;//子线程检测这个值为false时结束
                        }
                        
                    }
                    
                    sendQueue.pop();
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
    //deviceinfo怎么传参需要思考一下
    
    std::thread *socketThread=new std::thread([this]() {
          std::this_thread::sleep_for(std::chrono::seconds(1));//等待1s
          qDebug()<<"CM:SocketWork:"<<QThread::currentThreadId();

    });
    socketThread->detach();
    
    
}

void CommunManager::deviceEnable(int id)
{
    qDebug()<<"CM:deviceEnable:"<<id;
    // if(id==5 || id==6){
    //     return;
    // }
    
    //关注信息的生存期问题
    auto& info=DeviceManager::getInstance(nullptr,nullptr)->getDeviceInfoRaw(id);
    
    switch (info.getDeviceType()) {
        case QtSmartHomeGlobal::DeviceType::Socket: {
            
            SocketWork(id,1234);
            break;   
        }
        default: {
            break;
        }
    }
}

