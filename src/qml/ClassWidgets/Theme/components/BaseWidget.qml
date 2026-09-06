import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects as Effects
import ClassWidgets.Theme 1.0
import ClassWidgets.Easing


Item {
    id: widgetBase

    // Widget-facing API and structural slots. Theme visual treatments belong in
    // Widget.qml or a theme override, not in this base component.
    readonly property bool miniMode: Configs.data.preferences.mini_mode
    readonly property bool hide: Configs.data.interactions.hide.state
    property bool editMode: false
    property bool lightingEffect: Configs.data.preferences.lighting_effect || true
    property var backend: null
    property var settings: null
    property string instanceId: ""
    property string widget_id: ""

    property color backgroundColor: "#808080"
    property color borderColor: "transparent"
    property real borderWidth: 1
    property real cornerRadius: Configs.data.preferences.widget_corner_radius
    property real padding: miniMode ? 16 : 24
    property bool contentShadowEnabled: false

    property alias text: subtitleLabel.text
    property alias subtitle: subtitleArea.children
    property alias actions: actionButtons.children
    property alias backgroundArea: backgroundAreaItem.children
    default property alias content: contentArea.data

    implicitWidth: Math.max(headerRow.implicitWidth, contentArea.childrenRect.width) + 48
    height: miniMode ? 56 : 100

    function updateSettings(changes) {
        if (!changes || !instanceId)
            return

        var updatedSettings = Object.assign({}, settings || {}, changes)
        settings = updatedSettings
        WidgetsModel.updateSettings(instanceId, updatedSettings)
    }

    Item {
        id: backgroundAreaItem
        anchors.fill: parent
        z: -1
        Rectangle {
            anchors.fill: parent
            radius: widgetBase.cornerRadius
            color: widgetBase.backgroundColor
            opacity: Configs.data.preferences.opacity
            visible: backgroundArea.length <= 1
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.topMargin: miniMode ? 12 : 16
        anchors.bottomMargin: miniMode ? 10 : 18
        anchors.leftMargin: padding
        anchors.rightMargin: padding
        spacing: 8
        z: 1

        RowLayout {
            id: headerRow
            Layout.fillWidth: true
            visible: (subtitle.length > 1 || actions.length > 1 || widgetBase.text.length > 0) && !miniMode

            RowLayout {
                id: subtitleArea
                Layout.fillHeight: true

                Subtitle {
                    id: subtitleLabel
                }
            }

            Item {
                Layout.fillWidth: actionButtons.children.length > 0
            }

            RowLayout {
                id: actionButtons
                Layout.fillHeight: true
            }
        }

        Item {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            layer.enabled: widgetBase.contentShadowEnabled
            layer.effect: Effects.DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 3
                radius: 1.6
                samples: 5
                color: Qt.alpha("#000000", 0.25)
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 400
            easing.type: Easing.Bezier
            easing.bezierCurve: BezierCurve.liquidBack
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 400
            easing.type: Easing.Bezier
            easing.bezierCurve: BezierCurve.liquidBack
        }
    }

    Behavior on backgroundColor {
        ColorAnimation {
            duration: 350
            easing.type: Easing.OutQuint
        }
    }

    Behavior on borderColor {
        ColorAnimation {
            duration: 250
            easing.type: Easing.OutQuint
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}
