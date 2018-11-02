//
// This file is part of Sugar Dark, a theme for the Simple Display Desktop Manager.
//
// Copyright 2018 Marian Arlt
//
// Sugar Dark is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Sugar Dark is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Sugar Dark. If not, see <https://www.gnu.org/licenses/>.
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

Column {
    id: inputContainer
    Layout.fillWidth: true

    property Control exposeLogin: loginButton

    Item {
        id: usernameField
        height: root.font.pointSize * 3.25
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: username
            text: config.ForceLastUser == "true" ? userModel.lastUser : ""
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            placeholderText: config.TranslateUsernamePlaceholder || textConstants.userName
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            Keys.onReturnPressed: loginButton.clicked()
            KeyNavigation.down: password
        }

        Button {
            id: usernameIcon
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: username.height * 0.6
            icon.height: username.height * 0.4
            icon.width: username.height * 0.4
            enabled: false
            icon.color: root.palette.text
            icon.source: Qt.resolvedUrl("../Assets/User.svgz")
        }

        states: [
            State {
                name: "focused"
                when: username.activeFocus
                PropertyChanges {
                    target: username.background
                    border.color: config.AccentColor
                }
                PropertyChanges {
                    target: username
                    color: config.AccentColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]
    }

    Item {
        id: passwordField
        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePasswordPlaceholder || textConstants.password
            horizontalAlignment: TextInput.AlignHCenter
            passwordCharacter: "•"
            passwordMaskDelay: config.ForceHideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            background: Rectangle {
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            Keys.onReturnPressed: loginButton.clicked()
            KeyNavigation.down: revealSecret
        }

        states: [
            State {
                name: "focused"
                when: password.activeFocus
                PropertyChanges {
                    target: password.background
                    border.color: config.AccentColor
                }
                PropertyChanges {
                    target: password
                    color: config.AccentColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]
    }

    Item {
        id: secretCheckBox
        height: root.font.pointSize * 7
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: revealSecret
            width: parent.width
            hoverEnabled: true

            indicator: Rectangle {
                id: indicator
                anchors.left: parent.left
                implicitHeight: root.font.pointSize
                implicitWidth: root.font.pointSize
                color: "transparent"
                border.color: root.palette.text
                border.width: parent.visualFocus ? 2 : 1
                Rectangle {
                    id: dot
                    anchors.centerIn: parent
                    implicitHeight: parent.width - 6
                    implicitWidth: parent.width - 6
                    color: root.palette.text
                    opacity: revealSecret.checked ? 1 : 0
                }
            }

            contentItem: Text {
                id: indicatorLabel
                text: config.TranslateShowPassword || "Show Password"
                anchors.verticalCenter: indicator.verticalCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: indicator.right
                anchors.leftMargin: indicator.width / 2
                font.pointSize: root.font.pointSize * 0.75
                color: root.palette.text
            }

            Keys.onReturnPressed: toggle()
            KeyNavigation.down: loginButton
        }

        states: [
            State {
                name: "pressed"
                when: revealSecret.down
                PropertyChanges {
                    target: revealSecret.contentItem
                    color: Qt.darker(config.AccentColor, 1.2)
                }
                PropertyChanges {
                    target: dot
                    color: Qt.darker(config.AccentColor, 1.2)
                }
                PropertyChanges {
                    target: indicator
                    border.color: Qt.darker(config.AccentColor, 1.2)
                }
            },
            State {
                name: "hovered"
                when: revealSecret.hovered
                PropertyChanges {
                    target: indicatorLabel
                    color: Qt.lighter(config.AccentColor, 1.3)
                }
                PropertyChanges {
                    target: indicator
                    border.color: Qt.lighter(config.AccentColor, 1.3)
                }
                PropertyChanges {
                    target: dot
                    color: Qt.lighter(config.AccentColor, 1.3)
                }
            },
            State {
                name: "focused"
                when: revealSecret.visualFocus
                PropertyChanges {
                    target: indicatorLabel
                    color: config.AccentColor
                }
                PropertyChanges {
                    target: indicator
                    border.color: config.AccentColor
                }
                PropertyChanges {
                    target: dot
                    color: config.AccentColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, opacity"
                    duration: 150
                }
            }
        ]

    }

    Item {
        height: root.font.pointSize * 2.3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: errorMessage
            width: parent.width
            text: config.TranslateLoginFailed || textConstants.loginFailed + "!"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: root.font.pointSize * 0.8
            font.italic: true
            color: root.palette.text
            opacity: 0
            OpacityAnimator on opacity {
                id: fadeIn
                from: 0;
                to: 1;
                duration: 200
                running: false
            }
            OpacityAnimator on opacity {
                id: fadeOut
                from: 1;
                to: 0;
                duration: 400
                running: false
            }
        }
    }

    Item {
        id: login
        height: root.font.pointSize * 3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: config.TranslateLogin || textConstants.login
            height: root.font.pointSize * 3
            implicitWidth: parent.width
            enabled: username.text !== "" && password.text !== "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                text: parent.text
                color: "#444444"
                font.pointSize: root.font.pointSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                id: buttonBackground
                color: root.palette.text
                radius: config.RoundCorners || 0
            }

            states: [
                State {
                    name: "disabled"
                    when: !loginButton.enabled
                    PropertyChanges {
                        target: buttonBackground
                        color: "#888888"
                    }
                },
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges {
                        target: buttonBackground
                        color: "#444444"
                    }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(config.AccentColor, 1.2) || Qt.lighter("orange", 1.2)
                    }
                },
                State {
                    name: "focused"
                    when: loginButton.visualFocus
                    PropertyChanges {
                        target: buttonBackground
                        color: config.AccentColor
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "disabled"; to: ""
                    PropertyAnimation {
                        properties: "color"
                        duration: 500
                    }
                },
                Transition {
                    PropertyAnimation {
                        properties: "color"
                        duration: 100
                    }
                }
            ]

            Keys.onReturnPressed: clicked()
            onClicked: username.text !== "" && password.text !== "" ? sddm.login(username.text, password.text, sessionSelector.selectedSession) : sddm.loginFailed()
        }
    }

    SessionButton {
        id: sessionSelector
        textConstantSession: textConstants.session
    }

    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: { 
            fadeIn.start()
            resetError.running ? resetError.stop() & resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: fadeOut.start()
        running: false
    }

}
