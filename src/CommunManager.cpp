#include "inc/CommunManager.h"
#include "CommunManager.h"

#include <QDebug>

#include "boost/asio.hpp"
#include <chrono>
#include <thread>

//测试QThread
class TestWorkeThread : public QThread {
    //Q_OBJECT
public:
    TestWorkeThread(int time):_time(time) {};
    void run() override {
        qDebug()<<"testwork thread:"<<QThread::currentThreadId();

        boost::asio::io_context io_context;
        boost::asio::deadline_timer timer(io_context,boost::posix_time::seconds(_time));
    
        timer.async_wait([&](const boost::system::error_code& error) {
            emit CommunManager::getInstance()->triggerDeviceEnable(_time);
            if (!error) {
                qDebug() << "in testwork Timer expired!";
            } else {
                qDebug() << "in testwork Timer error: " << error.message();
            }
        });
    
        io_context.run();
    };
private:
    int _time;
};

CommunManager::CommunManager(QObject *parent)
{
    // testThread = new QThread();
    // this->moveToThread(testThread);
    // testThread->start();
}

//测试QThread异步，以及信号触发
void CommunManager::testWork()
{
    TestWorkeThread *testThread = new TestWorkeThread(5);
    testThread->start();
}

//测试std::thread异步，以及信号触发
void CommunManager::testWork2()
{
    std::thread t([this]() {
        qDebug()<<"testwork thread:"<<QThread::currentThreadId();

        boost::asio::io_context io_context;
        boost::asio::deadline_timer timer(io_context,boost::posix_time::seconds(6));
    
        timer.async_wait([&](const boost::system::error_code& error) {
            emit CommunManager::getInstance()->triggerDeviceEnable(6);
            if (!error) {
                qDebug() << "in testwork Timer expired!";
            } else {
                qDebug() << "in testwork Timer error: " << error.message();
            }
        });
    
        io_context.run();
    });
    t.detach();
}

void CommunManager::deviceEnable(int id)
{
    qDebug()<<"CM:deviceEnable:"<<id;
}
