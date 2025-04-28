pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtSmartHome 1.0

import "../common"

BaseView{
    id:deviceView

    property var infoMap
    property int deviceId
    //property var enableMap:new Map()
    property var dataMap:new Map()

    readonly property color enableColor:"black"
    readonly property color disableColor:ColorStyle.greyLight3

    signal deviceEnableStatusChanged(int id,bool enable)

    onInfoMapChanged:{
        //刷新信息
        //console.log("deviceView infoMap changed",infoMap,infoMap["name"])
        t.text=qsTr("device:"+infoMap["name"]);

    }
    Text{
        id:t
        text:qsTr("nothing")
    }
    // ViewRowItem{
    //     id:enableItem
    //     anchors.top:t.bottom

    //     choosedComponent: 'switch'
    //     componentDiscription: qsTr("Enable")

    //     itemStatus:Common.enableMap[deviceView.deviceId]?1:0
    // }
    Switch{
        id:enableItem
        
        anchors.horizontalCenter:parent.horizontalCenter 

        checked:Common.enableMap[deviceView.deviceId]

        onCheckedChanged:{
            if(checked==true){
                DeviceManager.changeDeviceStatus(deviceView.deviceId,true)//子线程
                deviceView.deviceEnableStatusChanged(deviceView.deviceId,true)//绿灯
                Common.enableMap[deviceView.deviceId]=true
                //CommunManager.deviceEnable(deviceView.deviceId)
                //新api，api将往命令队列里放入信息等待处理
            }else{
                DeviceManager.changeDeviceStatus(deviceView.deviceId,false)
                deviceView.deviceEnableStatusChanged(deviceView.deviceId,false)
                Common.enableMap[deviceView.deviceId]=false
            }
        }
    }

    Timer {
        id: timer
        interval: 2000 // 1秒
        repeat: true   // 重复触发

        running:false

        //property int cnt:0
        onTriggered: {
            // for (i of deviceView.infoMap["Data"]) {
            //     dataMap[i]=DeviceManager.getDeviceData(deviceView.deviceId,i)
            // }

            // deviceView.infoMap["Data"].forEach(function (item, index) {
            //     dataMap[item]=DeviceManager.getDeviceData(deviceView.deviceId,item)
            // })
            //cnt++
            
            for (let i = 0; i < deviceView.infoMap["Data"].length; i++) {
                dataModel.get(i).variableValue=DeviceManager.getDeviceData(deviceView.deviceId,deviceView.infoMap["Data"][i])
            }
        }
    }
    onVisibleChanged:{
        if(!visible){
            timer.running=false;
            return; 
        }
        timer.running=true;
        //刷新信息框所有信息
        dataModel.clear()

        deviceView.infoMap["Data"].forEach(function (item, index) {
            console.log("refresh data",item)
            dataMap[item]="-"
            dataModel.append({variableName:item,variableValue:dataMap[item]})
        })
    }

    //信息框
    Rectangle{
        id:infoRect
        anchors.top:enableItem.bottom
        anchors.topMargin:10
        anchors.horizontalCenter:parent.horizontalCenter

        color:"white"

        width:parent.width
        height:parent.height*0.7

        radius:width/10
        Rectangle{
            id:dataViewRect
            anchors.left:parent.left
            
            //color:"red"
            width:parent.width/2
            height:parent.height
            ListView{
                id:dataView
                anchors.fill:parent

                model:ListModel{
                    id:dataModel
                }

                delegate:Text{
                    required property string variableName
                    required property string variableValue

                    text:variableName+":"+variableValue

                    width:dataView.width
                    height:20
                }
            }
        }

    }
}