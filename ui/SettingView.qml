import QtQuick
import QtQuick.Controls

BaseView {
    id: settingView
    // Text{
    //     font.pixelSize: 16
    //     anchors.centerIn: parent
    //     text: "settingview"
    // }

        Column{
            id:column
            anchors.fill: settingView
            anchors.topMargin:10
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
                choosedComponent: 'default'
            }
            ViewRowItem{
                choosedComponent: 'default'
            }
            ViewRowItem{
                choosedComponent: 'default'
            }
        }
    
    
}
