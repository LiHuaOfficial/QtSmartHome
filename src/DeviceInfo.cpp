#include "inc/DeviceInfo.h"

int DeviceInfoCheckSocket::checkInfo(QVariantList& cfgInfo){
    //校验ip
    QRegularExpression re("(^(?:\\d{1,3}\\.){3}\\d{1,3}$)");
    if(!re.match(cfgInfo[0].toString()).hasMatch()){
        return 1;//ip不合法
    }
    //校验端口
    if(cfgInfo[1].toInt()<0||cfgInfo[1].toInt()>65535){
        return 2;//端口不合法
    }
    if(cfgInfo.size()>2){
        return -1;
    }
    return 0;
}
