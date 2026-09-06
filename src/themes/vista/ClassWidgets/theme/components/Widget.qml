import QtQuick
import QtQuick.Shapes as Shapes
import Qt5Compat.GraphicalEffects as Effects
import RinUI
import ClassWidgets.Theme 1.0 as BaseTheme


BaseTheme.BaseWidget {
    id: root

    // The Figma Vista surface is fixed at a 24px radius. Keep the background
    // transparent at the API level so BaseWidget does not add another fill.
    cornerRadius: 24
    backgroundColor: "transparent"
    readonly property bool isTransparent: Qt.color(backgroundColor).a === 0
    borderColor: "transparent"

    backgroundArea: Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            gradient: Gradient {
                // Figma: 180deg, 50% alpha surface gradient.
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0
                    color: Theme.isDark()
                        ? Qt.alpha("#87a3a9", 0.50)
                        : Qt.alpha("#b4dbe4", 0.50)
                }
                GradientStop {
                    position: 1
                    color: Theme.isDark()
                        ? Qt.alpha("#1e1d22", 0.50)
                        : Qt.alpha("#fbfaff", 0.50)
                }
            }
            opacity: Configs.data.preferences.opacity
            visible: isTransparent
        }

        Rectangle {
            id: bgOverlay
            anchors.fill: parent
            radius: root.cornerRadius
            color: root.backgroundColor
            opacity: Configs.data.preferences.opacity
            visible: !isTransparent
        }

        // The reference has a subtle 6% black falloff at both horizontal edges.
        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            opacity: Configs.data.preferences.opacity
            layer.enabled: true
            layer.effect: Effects.LinearGradient {
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.003; color: Qt.alpha("#000000", 0.06) }
                    GradientStop { position: 0.380; color: Qt.alpha("#000000", 0.0) }
                    GradientStop { position: 0.662; color: Qt.alpha("#000000", 0.0) }
                    GradientStop { position: 0.997; color: Qt.alpha("#000000", 0.06) }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            opacity:Theme.isDark()
                ? Configs.data.preferences.opacity * 0.7
                : Configs.data.preferences.opacity * 1.2
            gradient: Shapes.RadialGradient {
                centerX: width / 2
                centerY: 0
                focalX: centerX
                focalY: centerY
                focalRadius: Math.max(width, height) * 0.60
                GradientStop { position: 0.00; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.395 : 0.517) }
                GradientStop { position: 0.260; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.309 : 0.405) }
                GradientStop { position: 0.293; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.130 : 0.170) }
                GradientStop { position: 0.442; color: Qt.alpha("#ffffff", 0.0) }
                GradientStop { position: 0.83; color: Qt.alpha("#ffffff", 0.0) }
                GradientStop { position: 0.933; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.185 : 0.244) }
                GradientStop { position: 1.00; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.359 : 0.473) }
            }
            z: 99
        }

        // Outer and inner glass edges are separate gradients in the reference.
        // Masking the gradient sources leaves only their one-pixel strokes.
        Item {
            anchors.fill: parent
            opacity: Configs.data.preferences.opacity

            Rectangle {
                id: outerBorderSource
                anchors.fill: parent
                radius: root.cornerRadius
                layer.enabled: true
                layer.effect: Effects.LinearGradient {
                    start: Qt.point(0, 0)
                    end: Qt.point(0, height)
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: Qt.alpha("#8d8d8d", 0.65) }
                        GradientStop { position: 1.00; color: Qt.alpha("#272727", 0.45) }
                    }
                }
            }

            layer.enabled: true
            layer.effect: Effects.OpacityMask {
                maskSource: Rectangle {
                    width: outerBorderSource.width
                    height: outerBorderSource.height
                    radius: outerBorderSource.radius
                    color: "transparent"
                    border.width: 1
                }
            }
            z: 99
        }

        Item {
            anchors.fill: parent
            anchors.margins: 1
            opacity: Configs.data.preferences.opacity

            Rectangle {
                id: innerBorderSource
                anchors.fill: parent
                radius: Math.max(root.cornerRadius - 1, 0)
                layer.enabled: true
                layer.effect: Effects.LinearGradient {
                    start: Qt.point(0, 0)
                    end: Qt.point(width, height)
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.55 : 0.80) }
                        GradientStop { position: 0.50; color: Qt.alpha("#ffffff", 0.0) }
                        GradientStop { position: 0.60; color: Qt.alpha("#ffffff", 0.0) }
                        GradientStop { position: 1.00; color: Qt.alpha("#ffffff", Theme.isDark() ? 0.35 : 0.60) }
                    }
                }
            }

            layer.enabled: true
            layer.effect: Effects.OpacityMask {
                maskSource: Rectangle {
                    width: innerBorderSource.width
                    height: innerBorderSource.height
                    radius: innerBorderSource.radius
                    color: "transparent"
                    border.width: 1
                }
            }
            z: 99
        }
    }
}
