import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    Component.onCompleted: mainWindow.visible = true;

    ApplicationWindow {
        width: 860
        height: 640
        id: mainWindow
        NewConnectionDialog { id: connectionDialog }

        toolBar: ToolBar{
            RowLayout {
                width: parent.width
                ToolButton {
                    text: "Connect"
                    onClicked: connectionDialog.visible = true;
                }
            }
        }

        Rectangle {
            id: mainStage
            anchors.fill: parent;
        }

        Component.onCompleted:
        {
            console.log("Here");
            var component = Qt.createComponent("MainStage.qml");
            if (component.status == Component.Ready)
                component.createObject(mainStage);
        }

    }
}

//    ColumnLayout {
//        //anchors.fill: parent;
//        id: master

//        Component.onCompleted:
//        {
//            console.log("Here");
//            var component = Qt.createComponent("MainStage.qml");
//             if (component.status == Component.Ready)
//                 component.createObject(parent);
//        }
//    }

