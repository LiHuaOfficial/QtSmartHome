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
    property int defaultItemStatus: 0 

    //上层统一处理,Combox的选择,switch的开关
    signal rowItemTriggered(int result)

    Text{
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: parent.width/30

        text:rowItem.componentDiscription

        fontSizeMode: Text.Fit
        font.pixelSize: 24
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
            checked: rowItem.defaultItemStatus
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
            currentIndex: rowItem.defaultItemStatus
            onCurrentIndexChanged:{
                rowItem.rowItemTriggered(currentIndex)
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