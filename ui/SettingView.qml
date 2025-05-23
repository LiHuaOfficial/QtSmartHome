import QtQuick
import QtQuick.Controls

import "../common"
BaseView {
    id: settingView
    // Text{
    //     font.pixelSize: 16
    //     anchors.centerIn: parent
    //     text: "settingview"
    // }

    Flickable {
        id: flickable
        anchors.fill: parent

        contentHeight: column.childrenRect.height
        anchors.topMargin:10
        Column{
            id:column
            //anchors.fill: parent
            width:settingView.width
            height:settingView.height
            
            spacing: 10
            ViewRowItem{
                id:fullScreenItem
                choosedComponent: 'switch'
                componentDiscription: qsTr("Fullscreen")
            }
            Connections{
                target:fullScreenItem
                function onRowItemTriggered(result: int){
                    if(result==1){
                        Common.isFullScreen=true                       
                    }else{
                        Common.isFullScreen=false
                    }
                }
            }
            ViewRowItem{
                id:languageItem
                choosedComponent: 'comboBox'
                componentDiscription: qsTr("Language")
                comboBoxList: ['中文', 'English']
                itemStatus: 1
            }
            Connections{
                target:languageItem
                function onRowItemTriggered(result: int){
                    console.log("language switched:",languageItem.comboBoxList[result])
                }
            }
            ViewRowItem{
                id:textAreaItem
                choosedComponent: 'textArea'
                componentDiscription: qsTr("MAX devices")
            }
            Connections{
                target:textAreaItem
                function onRowItemTriggeredStr(res:string){
                    console.log("textarea comfirmed:",res)
                }
            }
            ViewRowItem{
                choosedComponent: 'switch'
                componentDiscription: qsTr("Allow input")
            }
            ViewRowItem{
                id:testRowItem
                choosedComponent: 'comboBox'
                comboBoxList: ['蓝牙', 'Wi-Fi', 'GPS']
                itemStatus: 0
                // onRowItemTriggered: {
                //     console.log("comboBox triggered")
                // }
            }
            Connections{
                target:testRowItem
                function onRowItemTriggered(result: int){
                    console.log("comboBox triggered",result)
                }
            }
            ViewRowItem{
                choosedComponent: 'default'
            }
        }
    }
    
}
