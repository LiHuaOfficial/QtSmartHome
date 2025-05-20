pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtSmartHome 1.0

import "../common"

BaseView{
    id:deviceView

    property var infoMap//进入时已经赋值，储存变量名
    property int deviceId
    //property var enableMap:new Map()
    //property var dataMap:new Map()

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

        checked:Common.enableMap[deviceView.deviceId]//忽略未初始化报错

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
        
        //为Data类型变量添加条目
        deviceView.infoMap["Data"].forEach(function (item, index) {
            console.log("refresh data",item)
            dataModel.append({variableName:item,variableValue:"-"})
        })

        //为Command类型变量添加条目
        deviceView.infoMap["Command"].forEach(function (item, index) {
            console.log("refresh command",item)
            commandModel.append({variableName:item})
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
            height:parent.height/2
            ListView{
                id:dataView//显示所有data类型变量
                anchors.fill:parent
                
                //spacing:2

                model:ListModel{
                    id:dataModel
                }

                delegate:Rectangle{
                    id:dataRect
                    required property string variableName
                    required property string variableValue
    
                    //color:"red"
                    border.color:ColorStyle.greyLight4
                    border.width:1
                    
                    width:dataView.width
                    height:dataViewRect.height/3
                    Text{
                        anchors.verticalCenter:parent.verticalCenter
                        anchors.rightMargin:parent.width/10
                        text:dataRect.variableName+":"+dataRect.variableValue
                        
                        font.pixelSize:height*0.8
                    }
                }
            }
        }
        Rectangle{
            id:commandViewRect

            anchors.top:dataViewRect.bottom

            width:parent.width/2
            height:parent.height/2

            //color:"blue"

            ListView{
                id:commandView//显示所有cmd类型变量
                anchors.fill:parent
                
                //spacing:2

                model:ListModel{
                    id:commandModel
                }

                delegate:Rectangle{
                    id:commandRect
                    required property string variableName
    
                    //color:"red"
                    border.color:ColorStyle.greyLight4
                    border.width:1

                    width:dataView.width
                    height:dataViewRect.height/3
                    Text{
                        id:commandText
                        anchors.verticalCenter:parent.verticalCenter
                        anchors.rightMargin:parent.width/10
                        text:commandRect.variableName
                        
                        font.pixelSize:height*0.8
                    }
                    Switch{
                        id:commandSwitch
                        anchors.right:parent.right
                        anchors.verticalCenter:parent.verticalCenter

                        width:parent.width/4
                        height:parent.height/2

    
                        onCheckedChanged:{
                            if(checked==true){
                                DeviceManager.sendToDevice(deviceView.deviceId,commandRect.variableName,true)
                            }else{
                                DeviceManager.sendToDevice(deviceView.deviceId,commandRect.variableName,false)
                            }
                        }
                    }
                }
            }
        }

    }
}