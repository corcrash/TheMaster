import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Window {
    id: connectionWindow
    width: splitContainer.implicitWidth + 2 * margin
    height: splitContainer.implicitHeight + 2 * margin
    property int margin: 2

    ListModel {
        id: connectionModel
    }

    //Connection delegate for the list view
    Component {
        id: connectionDelegate


        Item {

            MouseArea {
                anchors.fill: parent
                onClicked: connectionList.currentIndex = index
            }


            width: 400; height: 60

            Column {
                Text { text: '<b>Name:</b> ' + name }
                Text { text: '<b>Address:</b> ' + address }
                Text { text: '<b>Port:</b> ' + port }
            }

        }
    }

    //Main split view
    SplitView {
        id: splitContainer
        anchors.fill: parent
        anchors.margins: margin
        orientation: Qt.Horizontal
        Layout.fillHeight: true;
        Layout.fillWidth: true;

        //Left part of the split view, contains the connection list
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 200
            Layout.minimumHeight: 200
            anchors.margins: 10

            //The list view for connection
            ListView {
                id: connectionList
                width: 100
                height: parent.height

                model: connectionModel
                //The code that updatest the text fields on the other side
                onCurrentItemChanged: {
                    textName.text = connectionModel.get(currentIndex).name
                    textIP.text = connectionModel.get(currentIndex).address
                    textPort.text = connectionModel.get(currentIndex).port

                }

                delegate: connectionDelegate
                highlight: Rectangle { color: "lightsteelblue"; radius: 2 }
                focus: false

                Component.onCompleted: {
                    var dataRead = client.readConnections();

                    if(dataRead == '')
                        return;

                    var dataArray = dataRead.split(",");

                    console.log(dataArray.length)
                    for(var i=0; i<dataArray.length; i+=3){
                        connectionModel.append({ 'name': dataArray[i], 'address': dataArray[i+1], 'port': dataArray[i+2] });
                    }
                }


            }
        }

        //The right part of the split view, contains the edit boxes
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: dataEntranceColumn.implicitWidth
            Layout.minimumHeight: 200

            //Column layout for easier organisation
            ColumnLayout {
                id: dataEntranceColumn
                width: parent.width
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                layoutDirection: Qt.RightToLeft
                anchors.margins: margin

                //Grid layout that holds the labels and text fields
                GridLayout {
                    columns: 2
                    rows: 3
                    anchors.fill: parent

                    flow: GridLayout.TopToBottom

                    Label {
                        text: "Server name:"
                    }

                    Label {
                        text: "Server address:"
                    }

                    Label {
                        text: "Server port:"
                    }

                    TextField {
                        id: textName
                    }

                    TextField {
                        id: textIP
                        inputMask: "000.000.000.000"
                    }

                    TextField {
                        id: textPort
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                }

                RowLayout {
                    Label {
                        id: infoLabel
                        text: ""
                    }
                }

                //Row layout that holds the buttons
                RowLayout {
                    Button {
                        text: "Add"
                        onClicked: {
                            connectionModel.append({'name': 'Gallifrey', 'address': '127.0.0.1', 'port': '3210'})

                            var dataToWrite = [];

                            for(var i=0; i<connectionModel.count; i++){
                                dataToWrite.push(connectionModel.get(i).name);
                                dataToWrite.push(connectionModel.get(i).address);
                                dataToWrite.push(connectionModel.get(i).port);
                            }

                            client.writeConnections(dataToWrite);
                        }
                    }

                    Button {
                        text: "Remove"
                        onClicked: {
                            connectionModel.remove(connectionList.currentIndex);

                            var dataToWrite = [];

                            for(var i=0; i<connectionModel.count; i++){
                                dataToWrite.push(connectionModel.get(i).name);
                                dataToWrite.push(connectionModel.get(i).address);
                                dataToWrite.push(connectionModel.get(i).port);
                            }

                            client.writeConnections(dataToWrite);
                        }
                    }
                }

                RowLayout {

                    Button {
                        text: "Save"
                        onClicked: {
                            connectionModel.setProperty(connectionList.currentIndex, 'name', textName.text);
                            connectionModel.setProperty(connectionList.currentIndex, 'address', textIP.text);
                            connectionModel.setProperty(connectionList.currentIndex, 'port', textPort.text);

                            var dataToWrite = [];

                            for(var i=0; i<connectionModel.count; i++){
                                dataToWrite.push(connectionModel.get(i).name);
                                dataToWrite.push(connectionModel.get(i).address);
                                dataToWrite.push(connectionModel.get(i).port);
                            }

                            client.writeConnections(dataToWrite);
                        }
                    }

                    Button {
                        text: "Connect"
                        onClicked: {
                            console.log(textIP.text)
                            if(textIP.text == '...'){
                                infoLabel.text = 'The address must be set first!'
                                infoLabel.color = 'red'
                                return;
                            }
                            else if(textPort.text == '')
                            {
                                infoLabel.text = 'The port must be set first!'
                                infoLabel.color = 'red'
                            }
                            else if (textName.text == ''){
                                infoLabel.text = 'Please give this connection a name!'
                                infoLabel.color = 'red'
                            }
                            else{}

                            client.connectToAddress(textIP.text, textPort.text);
                            connectionWindow.close()
                            console.log("Connected!");
                        }
                    }
                }
            }
        }
    }

}



