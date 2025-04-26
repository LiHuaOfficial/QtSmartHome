pragma ComponentBehavior: Bound
//pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQml

import QtSmartHome 1.0

BaseView {
    id:base
    property int tempInfo: 0
    property var idIndexMap:new Map()//删除设备时记得更新这个Map
    
    signal deviceAppClicked(int deviceId)

    function modifyDeviceStatus(id:int,status){
        let app=modelApp.get(idIndexMap[id])
        app.active=status
    }

    Timer{
        id: timer
        interval: 1000
        repeat: true //重复
        running:true

        onTriggered:{
            base.tempInfo=base.tempInfo+1
            //console.log(DeviceManager.test())
        }
    }

    //用于debug
    Button{
        z:2
        anchors.right:parent.right
        width:parent.width/10
        onClicked:{
            base.modifyDeviceStatus(1,true)
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

        model:ListModel{
            id:modelApp

            //config.json为空时会无法添加
   
                    
        }
        delegate: DeviceApp{
            //提供一些可靠性，当类型错误时会有报错信息
            required property int deviceid
            required property bool active
            required property string name
            required property int deviceType

            objectName:"app"+deviceid.toString()

            deviceId:deviceid
            info:name
            isActivate:active
            width:gridView.appWidth
            type:deviceType

            onDeviceAppClicked:{
                //console.log("app clicked,id:",deviceid) 
                base.deviceAppClicked(deviceid)
            }
        }
    }

    // DeviceManager{
    //     id:deviceManager

    // }
    //启动时读取本地设备（C++类管理设备，在这里实例化）
    Component.onCompleted: {
        console.log("main view completed")
        //遍历Map，添加至ListModel
        //需要name id variables displayedInfo(viariable可以在展开后再显示，不放在GridView中)
        let id=0
        while ((id=DeviceManager.orderlyGetID())!=-1) {
            let infoMap=DeviceManager.getDeviceInfo(id)
            //console.log(infoMap["command"])里面是QVariantList
            
            modelApp.append({
                             deviceid:id,//DeviceManger可以获取id对应信息
                             name:infoMap["name"],
                             deviceType:infoMap["type"],
                             active:false
                             })
            base.idIndexMap.set(id,modelApp.count-1)
        }

    }
    Connections{
        target:DeviceManager
        function onDeviceAdded(id){
            console.log("main view onDeviceAdded")
            let infoMap=DeviceManager.getDeviceInfo(id)
            modelApp.append({deviceid:id,
                             name:infoMap["name"],
                             deviceType:infoMap["type"]})
            base.idIndexMap.set(id,modelApp.count-1)
        }
    }

}
