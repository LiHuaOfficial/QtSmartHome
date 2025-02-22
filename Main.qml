import QtQuick
import QtQuick.Controls

import "ui"

Window {
    id: window
    visible: true
    width: 480
    height: 320
    color: "white"
    title:"SmartHome"


    SideBarButton{
        id:sideBarButton//open sideBar
        width:parent.width/8
        height:width

        onButtonClicked:sideBar.foldStatus=!sideBar.foldStatus
    }

    Button{
        anchors.top:sideBarButton.bottom
        width:30
        onClicked:console.log("hello")
    }

    SideBar{
        anchors.top:sideBarButton.bottom
        id:sideBar
        width: parent.width/6
        height: parent.height-sideBarButton.height

    }


}
