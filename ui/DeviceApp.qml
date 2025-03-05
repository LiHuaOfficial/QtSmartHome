import QtQuick
import QtSmartHome 1.0

Rectangle {
    id:deviceApp//在MainView中出现每个deviceApp代表一个设备

    property string info:"None"
    property bool isActivate: false
    property int type

    width:40
    height:width

    radius:width/8

    color:"white"

    // border.width:2
    // border.color:"black"

    Rectangle{
        id:enableIndicator

        width:deviceApp.width/10
        height:width

        radius:width/2

        color:deviceApp.isActivate?"green":"red"

        anchors.left:deviceApp.left
        anchors.top:deviceApp.top
        anchors.leftMargin:deviceApp.width/10
        anchors.topMargin:deviceApp.width/10
    }
    Image{
        id:typeIcon
        anchors.left:enableIndicator.right

        width:deviceApp.width/8
        height:width

        source:{
            if (deviceApp.type==QtSmartHomeGlobal.BLE){
                return "../assets/bluetooth_icon.png"
            }else if(deviceApp.type==QtSmartHomeGlobal.Socket){
                return "../assets/wifi_icon.png"
            }else if(deviceApp.type==QtSmartHomeGlobal.HTTP){
                return "../assets/http_icon.png"
            }        
        }
    }
    Text{
        anchors.centerIn:parent
        text:deviceApp.info
    }

}
