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
        width:parent.width/8
        height:width

        onButtonClicked:sideBar.foldStatus=!sideBar.foldStatus
    }

    SideBar{
        id:sideBar
        width: parent.width/6
        height: parent.height

        x: -width
    }

}
