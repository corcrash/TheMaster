import QtQuick 2.0

Rectangle {
    //Main view rectangle
    Rectangle {
        anchors.fill: parent;
        id: mainStage
    }

    //A hidden item that manages the data change of the main view
    Item {
        property string ui_data

        ui_data: client.ui_data

        onUi_dataChanged:{
            mainStage.data = {}
            Qt.createQmlObject(client.ui_data, mainStage)
        }

        Component.onCompleted:
        {
            console.log("UML: " + client.ui_data);
            //var component = Qt.createQmlObject("import QtQuick 2.0; import QtQuick.Controls 1.1;  Button { text: 'This is just a test'; onClicked: console.log('Test!'); }", mainStage);
            var component = Qt.createQmlObject(client.ui_data, mainStage);
        }
    }
}
