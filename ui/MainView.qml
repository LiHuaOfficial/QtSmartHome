//pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQml

import QtSmartHome 1.0

BaseView {
    id:base
    property int tempInfo: 0
    Timer{
        id: timer
        interval: 1000
        repeat: true //重复
        running:true

        onTriggered:{
            base.tempInfo=base.tempInfo+1
            console.log(DeviceManager.test())
        }
    }
    ListModel{
        id:modelH
        ListElement {
            active:true
            name:"Hello"
        }
        ListElement {
            active:false
            name:"Test"
        }
        ListElement {
            active:true
            name:"TEST"
        }
        // ListElement {
        //     info:base.tempInfo
        // }
    }
    Button{
        z:2
        anchors.right:parent.right
        width:parent.width/10
        onClicked:{
            console.log("main btn clicked")
            modelH.append({name:base.tempInfo.toString()})
        }
    }
    GridView {
        id:gridView
        property int appWidth: base.width/6
        anchors.fill:parent

        topMargin:base.height/12
        leftMargin:base.width/20

        cellWidth:appWidth*1.1
        cellHeight:appWidth*1.1
        model:modelH
        delegate: DeviceApp{
            info:name
            isActivate:active
            width:gridView.appWidth
        }
    }

    // DeviceManager{
    //     id:deviceManager

    // }
    //启动时读取本地设备（C++类管理设备，在这里实例化）
    //设备有唯一id
    //添加设备获得id
    //id可以访问到设备信息

    //此处要求id可以获取到element并更新信息
    function add(){

    }
}
// Item{
//     width:20
//     height:20
//     Rectangle{
//         color:"red"
//         anchors.fill:parent
//     }
//     Column {
//         Text { text: portrait; anchors.horizontalCenter: parent.horizontalCenter }
//         Text { text: name; anchors.horizontalCenter: parent.horizontalCenter }
//     }
//     MouseArea {
//         anchors.fill: parent;
//         onClicked: {
//              console.log("Listview item clicked")
//         }
//     }
// }
