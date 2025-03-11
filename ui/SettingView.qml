import QtQuick
import QtQuick.Controls

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
                choosedComponent: 'switch'
            }
            ViewRowItem{
                choosedComponent: 'comboBox'
            }
            ViewRowItem{
                choosedComponent: 'default'
            }
            ViewRowItem{
                choosedComponent: 'switch'
            }
            ViewRowItem{
                id:testRowItem
                choosedComponent: 'comboBox'
                comboBoxList: ['蓝牙', 'Wi-Fi', 'GPS']
                defaultItemStatus: 0
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
