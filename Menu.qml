import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root

  property bool opened: false
  property var shell: null
  property var manifest: null

  function open(payloadJson) {
    root.opened = true
    client.refresh()
  }

  function close() {
    root.opened = false
  }

  function ping() { return "ok" }

  Client { id: client }

  Process { id: guiProc; command: ["omagato-gui"] }

  PanelWindow {
    id: win
    visible: root.opened
    aboveWindows: true
    exclusiveZone: 0
    color: Qt.rgba(0, 0, 0, 0)
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    MouseArea {
      anchors.fill: parent
      onClicked: root.close()
    }

    Rectangle {
      anchors.centerIn: parent
      width: 300
      height: column.implicitHeight + 28
      radius: 14
      color: Color.popups.background
      border.color: Color.muted
      border.width: 1

      MouseArea { anchors.fill: parent }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 14
        spacing: 8

        Text {
          width: parent.width
          wrapMode: Text.WordWrap
          color: Color.muted
          text: client.summary
          font.family: Style.font.menuFamily
        }

        ActionRow {
          label: "Mute output"
          onTriggered: client.trigger("mute-output")
        }
        ActionRow {
          label: "Mute mic"
          onTriggered: client.trigger("mute-mic")
        }
        ActionRow {
          label: "Brightness"
          onTriggered: client.trigger("brightness")
        }
        ActionRow {
          label: "Next page"
          onTriggered: client.trigger("next-page")
        }
        ActionRow {
          label: "Open Omagato"
          onTriggered: guiProc.startDetached()
        }
        ActionRow {
          label: "Reconnect"
          onTriggered: client.reconnect()
        }
      }
    }
  }

  component ActionRow: Rectangle {
    id: row
    property string label: ""
    signal triggered()
    width: parent ? parent.width : 0
    height: 36
    radius: 8
    color: Color.background
    border.width: 1
    border.color: hover.containsMouse ? Color.accent : Color.muted

    Text {
      anchors.centerIn: parent
      text: row.label
      color: Color.foreground
      font.family: Style.font.menuFamily
    }

    MouseArea {
      id: hover
      anchors.fill: parent
      hoverEnabled: true
      onClicked: row.triggered()
    }
  }
}
