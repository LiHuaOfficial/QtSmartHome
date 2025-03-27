pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls

import QtSmartHome 1.0
BaseView {
    // Text{
    //     font.pixelSize: 16
    //     anchors.centerIn: parent
    //     text: "addview"
    // }
    id:addView

    //设备信息为变量，点击add按钮，校验，成功后写入到本地
    property int deviceType:0
    property string deviceName:''

    property list<string> config//配置信息,顺序是固定的
    /*
    socket:ip,port
    ble:
    http:url
    */

    //添加设备的按钮
    Rectangle{
        id:addDeviceBtn

        z:3

        width:parent.width/10
        height:width
        
        radius:width/2

        readonly property int addDeviceBtnMarginWidth: 5
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        anchors.rightMargin:addDeviceBtnMarginWidth
        anchors.bottomMargin:addDeviceBtnMarginWidth
        color:ColorStyle.blue

        Image{
            width:parent.width*0.8
            height:width
            anchors.centerIn:parent

            source:'../assets/plus_icon.png'
        }
        MouseArea{
            anchors.fill:parent
            onClicked:{
                //检查信息非空,调用后端方法
                if(addView.deviceName.length===0){
                    addView.notificationTrigged(qsTr("Device name can't be empty"),Notification.Error,1000)
                    return
                }
                //长度根据状态的script确定，可以用索引直接访问
                for(var i=0;i<addView.config.length;i++){
                    if(addView.config[i].length===0){
                        addView.notificationTrigged(qsTr("Config can't be empty"),Notification.Error,1000)
                        return
                    }
                }
                if(variablesList.count===0){
                    addView.notificationTrigged(qsTr("Variables can't be empty"),Notification.Error,1000)
                    return
                }
                //考虑要不要加个map防止名字重复?

                //把variables构造成map
                var variablesMap={
                    'Command':[],
                    'Data':[],
                    'ChartData':[]
                }
                for(var i=0;i<variablesList.count;i++){
                    //console.log(variablesList.get(i).variableName)
                    variablesMap[varRect.dataTypeList[variablesList.get(i).variableType]].push(variablesList.get(i).variableName)
                }
                
                console.log(variablesMap['Command'])
                console.log(variablesMap['Data'])
                console.log(variablesMap['ChartData'])
                addView.notificationTrigged(qsTr("Device added"),Notification.Success,1000)
            }
        }
    }
    //表单框
    Rectangle{
        readonly property int seperatorHeight:1

        id:addRect
        //anchors.centerIn:addView

        anchors.horizontalCenter:addView.horizontalCenter
        anchors.top:addView.top
        anchors.topMargin:addView.width*0.01

        width:addView.width*0.96
        height:addView.height*0.96

        radius:width/20
        // border.width:2
        // border.color:"black"

        color:"white"


        //添加设备的表单
        //需要的值有设备类型，设备名称，链接需要的信息，关注的变量
        //不同的设备类型需要的信息不同，还得切换显示
        Column{
            id:column

            anchors.fill: parent

            //topPadding:10
            spacing: 10

            clip:true
            states: [
                State {
                    name: "BLE"
                    when: addView.deviceType == QtSmartHomeGlobal.BLE
                    PropertyChanges { target: bleItem; visible: true; opacity: 1 }
                    PropertyChanges { target: socketItem; visible: false; opacity: 0 }
                    PropertyChanges { target: httpItem; visible: false; opacity: 0 }
                    StateChangeScript{
                        script:{
                            addView.config=['','']//起一个清空的作用
                        }
                    }
                },
                State {
                    name: "Socket"
                    when: addView.deviceType == QtSmartHomeGlobal.Socket
                    PropertyChanges { target: bleItem; visible: false; opacity: 0 }
                    PropertyChanges { target: socketItem; visible: true; opacity: 1 }
                    PropertyChanges { target: httpItem; visible: false; opacity: 0 }
                    StateChangeScript{
                        script:{
                            addView.config=['','']
                        }
                    }
                },
                State {
                    name: "HTTP"
                    when: addView.deviceType == QtSmartHomeGlobal.HTTP
                    PropertyChanges { target: bleItem; visible: false; opacity: 0 }
                    PropertyChanges { target: socketItem; visible: false; opacity: 0 }
                    PropertyChanges { target: httpItem; visible: true; opacity: 1 }
                    StateChangeScript{
                        script:{
                            addView.config=['']
                        }
                    }
                }
            ]

            // 定义状态切换时的动画
            transitions: [
                Transition {
                    from: "*"; to: "*"
                    NumberAnimation {
                        properties: "opacity"
                        duration: 500
                    }
                }
            ]

            readonly property int itemHeight:column.height/6


            ViewRowItem{
                id:deviceTypeBox
                height:column.itemHeight

                choosedComponent: 'comboBox'
                componentDiscription: qsTr("Device type")
                comboBoxList: ['Socket', 'BLE','HTTP']
            }
            Connections{
                target:deviceTypeBox
                function onRowItemTriggered(index: int){
                    console.log("devicetype box change",index)
                    addView.deviceType=index
                }
            }
            ViewRowItem{
                id:deviceNameTextArea
                height:column.itemHeight

                choosedComponent:'textArea'
                componentDiscription:qsTr("Device name")
            }        
            Connections{
                target:deviceNameTextArea
                function onRowItemTriggeredStr(res: string){
                    if(res.length===0){
                        addView.notificationTrigged(qsTr("Device name empty"),Notification.Warning,1000)
                        return
                    }
                    addView.notificationTrigged(qsTr("Device name get"),Notification.Success,1000)
                    addView.deviceName=res
                }
            }
            //左边配置右边变量
            Row{
                id:row
                width:parent.width
                height:column.height-deviceTypeBox.height-deviceNameTextArea.height-20//spacing: 10
                spacing:10
                Item{//左半
                    width:parent.width/2
                    height:row.height

                    //根据设备显示不同item
                    Column{
                        id:bleItem
                        anchors.fill:parent

                        Text{
                            text:"ble item"
                        }
                    }
                    Column{
                        id:socketItem
                        anchors.fill:parent
                        Text{
                            text:"socket item"
                        }
                        ViewRowItem{
                            id:socketIpTextArea
                            height:column.itemHeight

                            choosedComponent:'textArea'
                            componentDiscription:qsTr("IP")
                        }        
                        Connections{
                            target:socketIpTextArea
                            function onRowItemTriggeredStr(res: string){
                                //console.log("socket ip get:",res)
                                if(res.length===0){
                                    addView.notificationTrigged(qsTr("IP empty"),Notification.Warning,1000)
                                    return
                                }
                                addView.notificationTrigged(qsTr("Socket IP get"),Notification.Success,1000)
                                addView.config[0]=res
                            }
                        }

                        ViewRowItem{
                            id:socketPortTextArea
                            height:column.itemHeight

                            choosedComponent:'textArea'
                            componentDiscription:qsTr("Port")
                        }        
                        Connections{
                            target:socketPortTextArea
                            function onRowItemTriggeredStr(res: string){
                                //console.log("socket port get:",res)
                                if(res.length===0){
                                    addView.notificationTrigged(qsTr("Port empty"),Notification.Warning,1000)
                                    return
                                }
                                addView.notificationTrigged(qsTr("Socket port get"),Notification.Success,1000)
                                addView.config[1]=res
                            }   
                        }
                    }
                    Column{
                        id:httpItem
                        anchors.fill:parent
                        Text{
                            text:"http item"
                        }

                        ViewRowItem{
                            id:httpUrlTextArea
                            height:column.itemHeight

                            choosedComponent:'textArea'
                            componentDiscription:qsTr("URL")
                        }        
                        Connections{
                            target:httpUrlTextArea
                            function onRowItemTriggeredStr(res: string){
                                console.log("http url get:",res)
                                if(res.length===0){
                                    addView.notificationTrigged(qsTr("URL empty"),Notification.Warning,1000)
                                    return
                                }
                                addView.notificationTrigged(qsTr("HTTP URL get"),Notification.Success,1000)
                                addView.config[0]=res
                            }
                        }
                    }
                }
                Item{//右半
                    id:varRect
                    width:parent.width/2
                    height:row.height
                    //color:"yellow"
                    readonly property var dataTypeList:['Command','Data','ChartData']

                    Column{//标题和添加变量框
                        id:varInfoColumn
                        width:parent.width
                        height:varText.height+addVarItem.height


                        Text{
                            id:varText
                            text:qsTr("Variables")
                        }

                        Row{
                            id:addVarItem
                            width:parent.width
                            height:varRect.height/6
                            ComboBox{
                                id:addvarCombobox
                                width:parent.width/10*3.5
                                height:parent.height
                                model:varRect.dataTypeList
                            }
                            TextField{
                                id:addvarTextArea
                                width:parent.width/10*5
                                height:parent.height
                            }
                            Rectangle{
                                height:parent.height
                                width:height
                                //color:ColorStyle.blue

                                Image{
                                    anchors.fill:parent
                                    source:'../assets/add_icon.png'
                                }
                                MouseArea{
                                    anchors.fill:parent
                                    onClicked:{
                                        if(addvarTextArea.text.length===0){
                                            addView.notificationTrigged(qsTr("Variable name empty"),Notification.Warning,1000)
                                            return
                                        }
                                        addView.notificationTrigged(qsTr("Variable added"),Notification.Success,1000)
                                        variablesList.append({variableType:addvarCombobox.currentIndex,
                                                              variableName:addvarTextArea.text})
                                    }
                                }
                            }
                        }
                    }
                    Rectangle{//删除所有var的按钮
                        color:ColorStyle.pinkyRed

                        width:parent.width/7
                        height:width

                        radius:width/10
                        z:2

                        anchors.right:parent.right
                        anchors.rightMargin:width/4
                        anchors.top:varInfoColumn.bottom
                        //anchors.rightMargin:height/2
                        //anchors.verticalCenter:parent.verticalCenter
                        Image{
                            anchors.fill:parent
                            source:'../assets/delete_icon.png'
                        }
                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                addView.notificationTrigged(qsTr("All variables deleted"),Notification.Warning,1000)
                                variablesList.clear()
                            }
                        }
                    }
                    ListView{
                        id:variablesListView

                        anchors.top:varInfoColumn.bottom

                        width:parent.width
                        height:parent.height-varInfoColumn.height
                        
                        clip:true//防止

                        model:ListModel{
                            id:variablesList
                            ListElement{
                                variableType:1
                                variableName:'hello'
                            }
                            ListElement{
                                variableType:2
                                variableName:'hfvcavava'                                
                            }
                        }

                        delegate:Rectangle{
                            id:singleVar
                            required property int variableType
                            required property string variableName

                            width:varRect.width
                            height:varRect.height/4
                            //color:'yellow'
                            //显示变量和删除框
                            Text{
                                id:variableText

                                font.pixelSize:singleVar.height*0.4
                                anchors.verticalCenter:parent.verticalCenter

                                text:'%1:%2'.arg(varRect.dataTypeList[parent.variableType]).arg(parent.variableName)//指定宽度
                            }
                        }
                    }

                }
            }
        }
    }
}
