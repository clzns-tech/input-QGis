import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import QgsQuick 0.1 as QgsQuick
import lc 1.0
import "./.." // import InputStyle singleton

Item {
  id: fieldDelegate
  signal removeClicked(var index)

  property real rowHeight: InputStyle.rowHeightHeader
  property real iconSize: rowHeight
  property color color: InputStyle.fontColor
  property var widgetList: []

  RowLayout {
    id: row
    height: fieldDelegate.rowHeight
    width: fieldDelegate.width
    spacing: InputStyle.panelSpacing
    property real itemSize: (parent.width - fieldDelegate.rowHeight)/2

    TextField {
      id: textField
      height: row.height
      topPadding: 10 * QgsQuick.Utils.dp
      bottomPadding: 10 * QgsQuick.Utils.dp
      font.pixelSize: InputStyle.fontPixelSizeNormal
      color: fieldDelegate.color
      placeholderText: qsTr("Field name")
      text: AttributeName
      Layout.fillHeight: true
      Layout.preferredWidth: row.itemSize

      onEditingFinished: AttributeName = text

      background: Rectangle {
        anchors.fill: parent
        border.color: textField.activeFocus ? InputStyle.fontColor : InputStyle.panelBackgroundLight
        border.width: textField.activeFocus ? 2 : 1
        color: InputStyle.clrPanelMain
        radius: InputStyle.cornerRadius
      }
    }

    ComboBox {
      id: comboBox
      height: row.height
      Layout.fillHeight: true
      Layout.preferredWidth: row.itemSize
      model: widgetList
      textRole: "display"
      valueRole: "widget"

      Component.onCompleted: {
        comboBox.currentIndex = comboBox.indexOfValue(WidgetType);
      }

      MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true

        onClicked: mouse.accepted = false
        onPressed: { forceActiveFocus(); mouse.accepted = false; }
        onReleased: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;
      }

      delegate: ItemDelegate {
        width: comboBox.width
        height: comboBox.height * 0.8
        text: model.display.replace('&', "&&") // issue ampersand character showing up as underscore
        font.weight: comboBox.currentIndex === index ? Font.DemiBold : Font.Normal
        font.pixelSize: InputStyle.fontPixelSizeNormal
        highlighted: comboBox.highlightedIndex === index
        leftPadding: textField.leftPadding
        onClicked: {
          WidgetType = model.widget
          comboBox.currentIndex = index
        }
      }

      contentItem: Text {
        height: comboBox.height * 0.8
        text: comboBox.displayText
        font.pixelSize: InputStyle.fontPixelSizeNormal
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        leftPadding: textField.leftPadding
        color: InputStyle.fontColor
      }

      background: Item {
        implicitHeight: comboBox.height * 0.8

        Rectangle {
          anchors.fill: parent
          id: backgroundRect
          border.color: comboBox.pressed ? InputStyle.fontColor : InputStyle.panelBackgroundLight
          border.width: comboBox.visualFocus ? 2 : 1
          color: "white"
          radius: InputStyle.cornerRadius
        }
      }


    }

    Item {
      id: imageBtn
      height: fieldDelegate.iconSize
      width: height
      Layout.fillHeight: true

      MouseArea {
        anchors.fill: parent
        onClicked: {
          fieldDelegate.removeClicked(index)
        }
      }

      Image {
        id: image
        anchors.centerIn: imageBtn
        source: InputStyle.noIcon
        height: imageBtn.height/2
        width: height
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
      }

      ColorOverlay {
        anchors.fill: image
        source: image
        color: fieldDelegate.color
      }
    }
  }
}
