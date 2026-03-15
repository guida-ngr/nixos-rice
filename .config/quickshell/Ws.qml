import QtQuick 6.6
import Quickshell
import Quickshell.Io

Row {
  spacing: 8
  
  Process {
    command: ["sh", Qt.resolvedUrl("./scripts/ws.sh").toString().replace("file://", "")]
    running: true
    stdout: SplitParser {
      onRead: data => {
        try {
          workspaceRepeater.model = JSON.parse(data);
        } catch (e) {}
      }
    }
  }

  Repeater {
    id: workspaceRepeater
    delegate: Rectangle {
      width: 16
      height: 16
      radius: 16
      color: {
        if (modelData.urgent) return alert;
        if (modelData.focused) return accent;
        return fg;
      }
      Behavior on color { ColorAnimation { duration: 200 } }
    }
  }
}
