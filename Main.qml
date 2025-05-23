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
        width: parent.width/3*2
        contentHeight: 50
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    //主界面信号处理
    Connections{
        target:Common
        function onIsFullScreenChanged(){
            if(Common.isFullScreen){
                console.log("fullscreen on")
                window.visibility=Window.FullScreen
                notification.notify(qsTr("Fullscreen On"),Notification.Success)
            }else{
                console.log("fullscreen off")
                window.visibility=Window.Windowed
                notification.notify(qsTr("Fullscreen Off"),Notification.Success)
            }
        }
    }

    //device manager信号处理
    Connections{
        target:DeviceManager
        function onDeviceManagerError(msg:string){
            notification.notify(msg,Notification.Error,3000)
        } 
    }

    TopBar{
        id:topBar
        z:5

        width:window.width
        height:window.height/8

        onSideBarButtonClicked:{
            sideBar.foldStatus=!sideBar.foldStatus
            //notification.notify("message",Notification.Message,1000)
        }
        onReturnButtonClicked:{
            window.selectedView=0
            //console.log("return button clicked")
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
        Connections{//target只能指定一个对象...
            target:mainView
            function onNotificationTrigged(message: string,type: int,timeout: int){
                notification.notify(message,type,timeout)
            }
        }
        Connections{//topbar浮现返回按钮
            target:mainView
            function onDeviceAppClicked(deviceId: int){
                window.selectedView=4
                topBar.topBarInDeviceView=true
                deviceView.infoMap=DeviceManager.getDeviceInfo(deviceId)
                deviceView.deviceId=deviceId
            }
        }

        AddView{
            id:addView
            index:1
            anchors.fill:parent
            selectedView:window.selectedView
        }
        Connections{
            target:addView
            function onNotificationTrigged(message: string,type: int,timeout: int){
                notification.notify(message,type,timeout)
            }
        }
        SettingView{
            id:settingView
            index:2
            anchors.fill:parent
            selectedView:window.selectedView
        }
        Connections{
            target:settingView
            function onNotificationTrigged(message: string,type: int,timeout: int){
                notification.notify(message,type,timeout)
            }
        }
        
        //单独显示每个设备
        DeviceView{
            id:deviceView
            index:4
            anchors.fill:parent
            selectedView:window.selectedView
        }
        Connections{
            target:deviceView
            function onNotificationTrigged(message: string,type: int,timeout: int){
                notification.notify(message,type,timeout)
            }
        }
        Connections{
            target:deviceView
            function onDeviceEnableStatusChanged(deviceId: int,enable: bool){
                mainView.modifyDeviceStatus(deviceId,enable)
            }
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
