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
    color: ColorStyle.greyLight1
    title:"SmartHome"

    property int selectedView: 0

    // SideBarButton{
    //     id:sideBarButton//open sideBar
    //     width:parent.width/8
    //     height:width

    //     onButtonClicked:sideBar.foldStatus=!sideBar.foldStatus
    // }
    TopBar{
        id:topBar

        width:window.width
        height:window.height/8

        onSideBarButtonClicked:sideBar.foldStatus=!sideBar.foldStatus
    }
    SideBar{
        id:sideBar
        anchors.top:topBar.bottom
        width: parent.width/6
        height: parent.height-topBar.height
    }

    Item{
        anchors.fill:parent

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
            pc.greet()
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

    ProtocolControl{
        id:pc
        author:"hello"
    }
}
