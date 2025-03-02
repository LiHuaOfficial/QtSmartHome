import QtQuick

Rectangle {
    id:deviceApp//在MainView中出现每个deviceApp代表一个设备

    property string info:"None"
    property bool isActivate: false
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
    Text{
        anchors.centerIn:parent
        text:deviceApp.info
    }

}
