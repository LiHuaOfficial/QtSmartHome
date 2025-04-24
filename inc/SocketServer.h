#include <boost/asio.hpp>
#include <iostream>
#include <memory>
#include <utility>
#include <chrono>

#include "CommunManager.h"

using boost::asio::ip::tcp;

class Session : public std::enable_shared_from_this<Session> {
public:
    Session(int id,tcp::socket socket) : id_(id),socket_(std::move(socket)),sessionTick(socket_.get_executor(),std::chrono::seconds(1)) {}

    void start() {
        //auto self(shared_from_this());
        
        //开启定时器
        sessionTick.async_wait(std::bind(&Session::timer_handler, this, std::placeholders::_1));

        do_read();
    }

private:
    int id_;
    tcp::socket socket_;
    boost::asio::steady_timer sessionTick;

    enum { max_length = 512 };
    char dataRead_[max_length];
    char dataSend_[max_length];

    void timer_handler(const boost::system::error_code& error) {
        auto self(shared_from_this());
        if (!error) {
            auto str=CommunManager::getInstance(nullptr,nullptr)->getSendData(id_);

            int sendLenth=str.length()>max_length?max_length:str.length();
            memcpy(dataSend_,str.c_str(),sendLenth);

            do_write(str.length());
        } 
        sessionTick.expires_after(std::chrono::seconds(1));
        sessionTick.async_wait(std::bind(&Session::timer_handler, this, std::placeholders::_1));
    };

    void do_read() {
        auto self(shared_from_this());
        socket_.async_read_some(boost::asio::buffer(dataRead_, max_length),
                                [this, self](boost::system::error_code ec, std::size_t length) {
            if (!ec) {
                //数据放入队列
                CommunManager::getInstance(nullptr,nullptr)->recvData(CommunMessage(id_,CommunMessage::MessageType::TypeData,std::string(dataRead_,length)));
                do_read();

            } else {
                std::cerr << "Client disconnected with error: " << ec.message() << std::endl;
            }
        });
    }

    void do_write(std::size_t length) {
        auto self(shared_from_this());
        boost::asio::async_write(socket_, boost::asio::buffer(dataSend_, length),
                                 [this, self](boost::system::error_code ec, std::size_t /*length*/) {
            if (!ec) {
                do_read();
            } else {
                std::cerr << "Client disconnected with error: " << ec.message() << std::endl;
            }
        });
    }
};

class SocketServer {
public:
    SocketServer(int id,boost::asio::io_context& io_context, short port)
        : acceptor_(io_context, tcp::endpoint(tcp::v4(), port)) , id_(id){
        do_accept();
    }

private:
    tcp::acceptor acceptor_;
    int id_;

    void do_accept() {
        acceptor_.async_accept([this](boost::system::error_code ec, tcp::socket socket) {
            if (!ec) {
                std::make_shared<Session>(id_,std::move(socket))->start();
            } else {
                std::cerr << "Accept failed with error: " << ec.message() << std::endl;
            }
            do_accept();
        });
    }
};
