import QtQuick 6.6
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

Row { 
    id: statsRow
    spacing: 8
    
    property real cpuUsage: 0
    property real ramUsage: 0
    property real diskUsage: 0

    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            cpuScript.run();
            ramScript.run();
            diskScript.run();
        }
    }

    Process {
        id: cpuScript
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"]
        stdout: SplitParser { onRead: data => cpuUsage = parseFloat(data) / 100 }
        function run() { running = true }
    }

    Process {
        id: ramScript
        command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2}'"]
        stdout: SplitParser { onRead: data => ramUsage = parseFloat(data) }
        function run() { running = true }
    }

    Process {
        id: diskScript
        command: ["sh", "-c", "df / --output=pcent | tail -1 | tr -dc '0-9'"]
        stdout: SplitParser { onRead: data => diskUsage = parseFloat(data) / 100 }
        function run() { running = true }
    }

    // Os círculos agora aparecem lado a lado
    StatCircle { icon: ""; value: cpuUsage; circleColor: accent }
    StatCircle { icon: ""; value: ramUsage; circleColor: accent }
    StatCircle { icon: "󱛟"; value: diskUsage; circleColor: accent }
}
