#ifndef _COMMUN_MESSAGE_
#define _COMMUN_MESSAGE_

#include <string>
#include <unordered_map>

//
class CommunMessage{
public:
    enum MessageType{TypeData,TypeSyscmd};//data将会被传输到其他设备，syscmd控制后端的行为(前端需要往通信队列里塞命令)
    
    enum SyscmdMessageType{BoolStatus=2,String};

    //构造函数
    CommunMessage(int id,MessageType dataType,std::string data__):id_(id),messageType(dataType),data_(data__){
        
    };

    CommunMessage(int id,bool status):id_(id),messageType(TypeSyscmd),syscmdMessageType(BoolStatus),status_(status){

    };
    int getId(){return id_;};
    MessageType getMessageType(){return messageType;};
    SyscmdMessageType getSyscmdMessageType(){return syscmdMessageType;};

    std::string getData(){
        if (messageType==TypeData || (messageType==TypeSyscmd && syscmdMessageType==String)) {
            return data_;
        }
        return "";
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
    SyscmdMessageType syscmdMessageType;

    int id_;

    std::string data_;

    bool status_;
};

#endif