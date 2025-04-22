import QtQuick
import QtSmartHome 1.0
BaseView{
    id:deviceView

    property var infoMap
    property int deviceId
    onInfoMapChanged:{
        //刷新信息
        //console.log("deviceView infoMap changed",infoMap,infoMap["name"])
        t.text=qsTr("device:"+infoMap["name"]);

    }
    Text{
        id:t
        text:qsTr("nothing")
    }
    ViewRowItem{
        id:enableItem
        anchors.top:t.bottom

        choosedComponent: 'switch'
        componentDiscription: qsTr("Enable")
    }
    Connections{
        target:enableItem
        function onRowItemTriggered(result: int){
            if(result==1){
                DeviceManager.changeDeviceStatus(deviceView.deviceId,true)
                //CommunManager.deviceEnable(deviceView.deviceId)
                //新api，api将往命令队列里放入信息等待处理
            }else{

            }
        }
    }
}