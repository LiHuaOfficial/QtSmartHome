import QtQuick
import QtQuick.Controls

import "ui"
import "common"

import QtSmartHome 1.0

Window {
    id: window
    visible: true
    width: 480
    height: 320
    color: ColorStyle.greyLight3
    title:"SmartHome"

    property int selectedView: 0
    
    Notification {
        id: notification
        z: 100
        width: parent.width<720?parent.width/2:360
        contentHeight: 50
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    TopBar{
        id:topBar

        z:5

        width:window.width
        height:window.height/8

        onSideBarButtonClicked:{
            sideBar.foldStatus=!sideBar.foldStatus
            notification.notify("message",Notification.Message,1000)
        }
    }
    SideBar{
        id:sideBar

        z:5

        anchors.top:topBar.bottom
        width: parent.width/6
        height: parent.height-topBar.height
    }

    Item{
        z:0

        anchors.top:topBar.bottom

        width:parent.width
        height:parent.height-topBar.height

        MainView{
            id:mainView
            index:0
            anchors.fill:parent
            selectedView:window.selectedView
        }
        AddView{
            id:addView
            index:1
            anchors.fill:parent
            selectedView:window.selectedView
        }
        SettingView{
            id:settingView
            index:2
            anchors.fill:parent
            selectedView:window.selectedView
        }
    }

    Connections {
        target: sideBar
        function onViewSwitched(index: int) {
            window.selectedView = index
            console.log("view switched",index)
            //pc.greet()
        }
    }

    Dialog {
        id: dialog
        title: qsTr("Sure to exit?")

        width: parent.width/2
        height: parent.height/4

        anchors.centerIn:parent

        modal: true

        visible: window.selectedView==3
        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: Qt.exit(0)
        onRejected: {
            window.selectedView=0
            sideBar.setSelectedContent(0)
        }
    }

    // ProtocolControl{
    //     id:pc
    //     author:"hello"
    // }
}
