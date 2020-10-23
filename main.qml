import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import ls.sierra_kilo_alpha.image 1.0

Window {
    id: mainwin
    visible: true
    width: 800
    height: 800
    title: qsTr("Splash Creator")
    color: "#aaaaaa"

    ImageManager {
        id: imagemanager
        onOutWidthChanged: console.log("outWidth changed: ", outWidth)
        onOutHeightChanged: console.log("outHeight changed: ", outHeight)
    }

    Rectangle {
        id: imageContainer
        width: mainwin.width
        height: mainwin.height*0.75
        anchors.left: mainwin.left
        color: "transparent"
        Image {
            id: img
            sourceSize.width: imageContainer.width
            fillMode: Image.PreserveAspectCrop
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            onSourceChanged: {
                //console.log("Height: " + img.height)
                //console.log("Width: "  + img.width)
            }
        }
    }

    Rectangle {
        id: cmdsContainer
        color: "#999999"
        border.color: "#666666"
        border.width: 3
        width: mainwin.width
        height: mainwin.height*0.2
        //height: mainwin.height-imageContainer.height
        anchors.top: imageContainer.bottom

        Rectangle
        {
            id: openContainer
            color: "#999999"
            border.color: "#666666"
            border.width: 3
            width: parent.width*0.2
            height: parent.height
            anchors.left: parent.left

            Label {
                text: "Source:"
                font.family: "Helvetica"
                font.pointSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: "Open.."
                width: parent.width*0.8
                height: 25
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialog.visible = true
            }
        }

        Rectangle
        {
            id: outputContainer
            color: "#999999"
            border.color: "#666666"
            border.width: 3
            width: parent.width*0.8
            height: parent.height
            anchors.right: parent.right

            GridLayout {
                columns: 4
                rows : 5
                height: parent.height
                width: parent.width

/*************************************
 * outputLabel R0
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 0
                    Layout.columnSpan: 4
                    Layout.row: 0
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        id: outputLabel
                        text: "Output:"
                        font.family: "Helvetica"
                        font.pointSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                    }
                }
/*************************************
 * widthLabel R1
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.row: 1
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        id: widthLabel
                        text: "Width:"
                        font.family: "Helvetica"
                        font.pointSize: 8
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        //anchors.top: outputLabel.bottom
                        //anchors.topMargin: 5;
                        //anchors.left: parent.left
                        //anchors.leftMargin: 15;
                    }
                }
/*
 * widthText
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 1
                    Layout.columnSpan: 1
                    Layout.row: 1
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextField {
                        id: widthText
                        //anchors.top: widthLabel.top
                        //anchors.left: widthLabel.right
                        //anchors.leftMargin: 5;
                        placeholderText: imagemanager.outWidth
                        font.family: "Helvetica"
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        validator: IntValidator {bottom: 1; top: 5000}
                        onTextChanged: {
                            imagemanager.outWidth = this.text;
                        }
                    }
                }
/*
 * heightLabel
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 2
                    Layout.columnSpan: 1
                    Layout.row: 1
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        id: heightLabel
                        text: "Height:"
                        font.family: "Helvetica"
                        font.pointSize: 8
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        //anchors.top: outputLabel.bottom
                        //anchors.topMargin: 5;
                        //anchors.left: parent.left
                        //anchors.leftMargin: 15;
                    }
                }
/*
 * heightText
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 3
                    Layout.columnSpan: 1
                    Layout.row: 1
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    TextField {
                        id: heightText
                        //anchors.top: widthLabel.top
                        //anchors.left: widthLabel.right
                        //anchors.leftMargin: 5;
                        placeholderText: imagemanager.outHeight
                        font.family: "Helvetica"
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        validator: IntValidator {bottom: 1; top: 5000}
                        onTextChanged: {
                            imagemanager.outHeight = this.text;
                        }
                    }
                }
/*************************************
 * aspectRatioLabel R2
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.row: 2
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        id: aspectRatioLabel
                        text: "Aspect Ratio:"
                        font.family: "Helvetica"
                        font.pointSize: 8
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                    }
                }
/*
 * aspectRatioComboBox
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.row: 2
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ComboBox {
                        id: aspectRatioComboBox
                        font.family: "Helvetica"
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        currentIndex: 1
                        model: ListModel {
                            id: arItems
                            ListElement { text: "IgnoreAspectRatio" }
                            ListElement { text: "KeepAspectRatio" }
                            ListElement { text: "KeepAspectRatioByExpanding"; }
                        }
                        onCurrentIndexChanged: imagemanager.outAspectRatio = (arItems.get(currentIndex).text)
                    }
                }
/*************************************
 * folderLabel R3
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 0
                    Layout.columnSpan: 1
                    Layout.row: 3
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: false;

                    Label {
                        id: folderLabel
                        text: "Folder:"
                        font.family: "Helvetica"
                        font.pointSize: 8
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                    }
                }

/*
 * folderText
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 1
                    Layout.columnSpan: 2
                    Layout.row: 3
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: false;

                    TextField {
                        id: folderText
                        font.family: "Helvetica"
                        font.pointSize: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width*0.8
                        height: parent.height*0.8
                        //validator: IntValidator {bottom: 1; top: 5000}
                        //onTextChanged: {
                        //    imagemanager.outHeight = this.text;
                        //}
                    }
                }

/*
 * folderBtn
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 3
                    Layout.columnSpan: 1
                    Layout.row: 3
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: false;

                    Button {
                        id: folderBtn
                        text: "Select.."
                        width: parent.width*0.8
                        height: parent.height*0.8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        //onClicked: folderDialog.visible = true
                    }
                }
/*************************************
 * folderLabel R3
 */
                Rectangle {
                    color: "transparent"
                    Layout.column: 0
                    Layout.columnSpan: 4
                    Layout.row: 4
                    Layout.rowSpan: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Button {
                        id: convertBtn
                        text: "Convert.."
                        width: parent.width*0.8
                        height: parent.height*0.8
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: imagemanager.fileName = ""+ fileLabel.text
                    }
                }
            }
        }
    }

    Rectangle {
        id: fileNameContainer
        color: "#999999"
        border.color: "#666666"
        border.width: 3
        width: mainwin.width
        height: mainwin.height*0.04
        anchors.top: cmdsContainer.bottom

        Label {
            id: fileLabel
            text: ""
            width: fileNameContainer.width
            height: fileNameContainer.height
            font.family: "Helvetica"
            font.pointSize: 8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            //anchors.bottom: openContainer.bottom
            wrapMode: Text.Wrap
        }
    }

    Item {
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            folder: shortcuts.pictures
            nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
            onAccepted: {
                console.log("fileDialog.fileUrls: " + fileDialog.fileUrls)
                //imagemanager.fileName = ""+ fileDialog.fileUrls
                fileLabel.text = ""+ fileDialog.fileUrls
                img.source = ""+ fileDialog.fileUrls
                fileDialog.visible= false
            }
            onRejected: {
                console.log("Canceled")
            }
            Component.onCompleted: visible = false
        }
    }
}

