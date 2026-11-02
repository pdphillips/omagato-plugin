import QtQuick
import Quickshell.Io
import qs.Commons as Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "pdphillips.omagato"

  readonly property string labelText: client.online ? "Omagato" : "Omagato ·"

  function toggleMenu() {
    toggleProc.command = ["omarchy-shell", "shell", "toggle", "pdphillips.omagato", "{}"]
    if (toggleProc.running) toggleProc.running = false
    toggleProc.running = true
  }

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Client { id: client }

  Process { id: toggleProc }

  Row {
    id: row
    spacing: 6

    Rectangle {
      width: 8
      height: 8
      radius: 4
      anchors.verticalCenter: parent.verticalCenter
      color: client.online ? Commons.Color.accent : Commons.Color.muted
    }

    WidgetButton {
      bar: root.bar
      text: root.labelText
      tooltipText: client.summary
      onPressed: function(buttonCode) {
        if (buttonCode === Qt.LeftButton) root.toggleMenu()
        else if (buttonCode === Qt.RightButton) client.reconnect()
      }
    }
  }
}
