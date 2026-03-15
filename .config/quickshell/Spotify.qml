import QtQuick 6.6
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

Item {
    id: spotifyRoot
    implicitWidth: mainRow.implicitWidth
    implicitHeight: 30 

    property bool isPlaying: false
    property string artist: ""
    property string title: ""
    property real length: 0
    property real position: 0
    property real progress: length > 0 ? (position / (length / 1000000)) : 0

    onProgressChanged: progressCanvas.requestPaint()

    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: dataScript.run()
    }
    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: posScript.run()
    }

    Process {
        id: dataScript
        command: ["sh", Qt.resolvedUrl("./scripts/spotify.sh").toString().replace("file://", "")]
        stdout: SplitParser {
            onRead: data => {
                const json = JSON.parse(data);
                artist = json.artist || "";
                title = json.title || "";
                length = json.length || 0;
            }
        }
        function run() { running = true }
    }

    Process {
        id: posScript
        command: ["playerctl", "-p", "spotify", "status"]
        stdout: SplitParser {
            onRead: data => {
                isPlaying = (data.trim() === "Playing");
                posDetailScript.run();
            }
        }
        function run() { running = true }
    }

    Process {
        id: posDetailScript
        command: ["playerctl", "-p", "spotify", "position"]
        stdout: SplitParser { onRead: data => position = parseFloat(data) }
        function run() { running = true }
    }

    Row {
        id: mainRow
        spacing: 8
        visible: title !== ""
        anchors.verticalCenter: parent.verticalCenter

        // --- BOTÃO PLAY/PAUSE + PROGRESSO ---
        Item {
            width: 22; height: 22
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.color: fg
                border.width: 1
                opacity: 0.2
            }

            Canvas {
                id: progressCanvas
                anchors.fill: parent
                antialiasing: true // Força o anti-aliasing do Qt

                // Definições do círculo
                readonly property real centerX: width / 2
                readonly property real centerY: height / 2
                readonly property real strokeWidth: 2.5 // Mesma grossura de antes

                // A função que desenha
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset(); // Limpa o desenho anterior

                    // Ativa o anti-aliasing do contexto 2D (Crucial!)
                    ctx.antialiasing = true; 
                    
                    if (length > 0) {
                        ctx.lineWidth = 2;
                        ctx.strokeStyle = accent; // Cor 'accent'
                        ctx.lineCap = "round"; // Pontas arredondadas

                        ctx.beginPath();
                        // path.arc(x, y, radius, startAngle, endAngle, counterclockwise)
                        // startAngle: -0.5 * Math.PI é o topo (12 horas)
                        // endAngle: progress * 2 * Math.PI varre o círculo baseado no progresso
                        var startAngle = -0.5 * Math.PI;
                        var endAngle = startAngle + (progress * 2 * Math.PI);
                        
                        ctx.arc(centerX, centerY, (width / 2) - (strokeWidth / 2), startAngle, endAngle, false);
                        ctx.stroke();
                    }
                }
            }

            // Ícone Play/Pause 
            Text {
                anchors.centerIn: parent
		anchors.verticalCenterOffset: 0.5
                anchors.horizontalCenterOffset: isPlaying ? 0 : 1 
                text: isPlaying ? "󰏤" : "󰐊"
                color: accent
                font.pixelSize: 14 
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    isPlaying = !isPlaying; 
                    playPauseCmd.run();
                }
            }
        }

        // --- INFO DA MÚSICA ---
        Text {
            text: title + " - " + artist
            color: accent
            font.family: "open sans"
            font.bold: true
            font.pixelSize: 13 
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Process {
        id: playPauseCmd
        command: ["playerctl", "-p", "spotify", "play-pause"]
        function run() { running = true }
    }
}
