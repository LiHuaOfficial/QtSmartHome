pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

//这个是设置界面/添加界面每一行的item
Rectangle{
    id:rowItem
    color: "white"
    radius:width/10

    width: parent.width
    height: parent.height/5

    property string choosedComponent: 'default'
    property string componentDiscription: 'None'
    property var comboBoxList: ['中文', 'English', 'Español']
    property int itemStatus: 0 

    //上层统一处理,Combox的选择,switch的开关
    signal rowItemTriggered(int result)
    signal rowItemTriggeredStr(string result)
    Text{
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: parent.width/30

        text:rowItem.componentDiscription

        fontSizeMode: Text.Fit
        font.pixelSize: rowItem.height*0.5
    }
    
    Loader{
        id: loader
        
        //anchors.right:parent.right

        active: true  // 启用加载

        sourceComponent: {
            switch(rowItem.choosedComponent){
                case 'switch':
                    return switchComponent
                case 'comboBox':
                    return comboBoxComponent
                case 'textArea':
                    return textAreaComponent
                default:
                    return defaultComponent
            }
        }

        onLoaded:{
            loader.item.parent=rowItem
            loader.item.anchors.right=rowItem.right
            loader.item.anchors.verticalCenter=rowItem.verticalCenter
            //loader.item.anchors.rightMargin=rowItem.width/10
        }
    }

    Component {
        id: switchComponent
        Switch {
            width:parent.width/4
            height:parent.height
            checked: rowItem.itemStatus
            onCheckedChanged:{
                rowItem.rowItemTriggered(checked)
            }
        }
    }

    Component {
        id: comboBoxComponent
        ComboBox {
            width:parent.width/5
            height:parent.height*0.7
            anchors.rightMargin: parent.width/15
            model: rowItem.comboBoxList
            currentIndex: rowItem.itemStatus
            onCurrentIndexChanged:{
                rowItem.rowItemTriggered(currentIndex)
            }
        }
    }

    Component{
        id:textAreaComponent

        Rectangle{
            width:parent.width/4
            height:parent.height*0.7
            anchors.rightMargin: parent.width/10

            //color:'yellow'
            TextField{
                id:textField
                anchors.right:parent.right
                anchors.verticalCenter:parent.verticalCenter
                anchors.rightMargin: parent.width/30

                width:parent.width*1.2
                height:parent.height*0.7
                font.pixelSize:height*0.8
            }
            //确认输入的蓝色按钮
            Rectangle{
                anchors.left:textField.right
                anchors.leftMargin:2
                anchors.verticalCenter:parent.verticalCenter

                radius:height/5
                width:height
                height:textField.height*1.3
                color:ColorStyle.blue
                Image{
                    
                    anchors.fill:parent
                    source: "../assets/tick_icon.png"
                }
                MouseArea{
                    id:ma
                    anchors.fill:parent
                    onClicked:{
                        //触发rowItemTriggeredStr
                        //console.log("rowItemTriggeredStr")
                        rowItem.rowItemTriggeredStr(textField.text)
                    }
                }
            }
        }

    }
    Component {
        id: defaultComponent
        Text {
            anchors.rightMargin: parent.width/10
            text: "default"
        }
    }
}