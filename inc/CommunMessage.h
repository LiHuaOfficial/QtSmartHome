#ifndef _COMMUN_MESSAGE_
#define _COMMUN_MESSAGE_

#include <string>
//
class CommunMessage{
public:
    enum MessageType{TypeData,TypeSyscmd};//data将会被传输到其他设备，syscmd控制后端的行为(前端需要往通信队列里塞命令)
    
    enum DataMessageType{ChartData,Command,Data};
    enum SyscmdMessageType{BoolStatus=3,String};

    CommunMessage(int id,DataMessageType dataType,std::string data):id_(id),messageType(TypeData),dataMessageType(dataType){
        dataSize_=data.size();
        assert(dataSize_<=64);
        memcpy(data_,data.c_str(),dataSize_);
    };
    CommunMessage(int id,SyscmdMessageType syscmdType,std::string data):id_(id),messageType(TypeSyscmd),syscmdMessageType(syscmdType){
        dataSize_=data.size();
        assert(dataSize_<=64);
        memcpy(data_,data.c_str(),dataSize_);
    };
    CommunMessage(int id,SyscmdMessageType syscmdType,bool status):id_(id),messageType(TypeSyscmd),syscmdMessageType(syscmdType),status_(status){
        dataSize_=0;
    };
    int getId(){return id_;};
    MessageType getMessageType(){return messageType;};
    DataMessageType getDataMessageType(){return dataMessageType;};
    SyscmdMessageType getSyscmdMessageType(){return syscmdMessageType;};

    std::string getData(){
        if (messageType==TypeData || (messageType==TypeSyscmd && syscmdMessageType==String)) {
            return std::string(data_,dataSize_);
        }else{
            return "";
        }
    };
    bool getStatus(){
        if (messageType==TypeSyscmd && syscmdMessageType==BoolStatus) {
            return status_; 
        }else{
            return false;
        }
    };
private:
    MessageType messageType;
    DataMessageType dataMessageType;
    SyscmdMessageType syscmdMessageType;

    int id_;
    int dataSize_;
    char data_[64];

    bool status_;
};

#endif