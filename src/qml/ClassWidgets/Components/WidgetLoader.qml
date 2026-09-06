import QtQuick

Loader {
    id: loader
    property string widgetSource: model.qmlPath
    property bool reloading: false
    source: widgetSource
    asynchronous: true
    // width: item ? item.implicitWidth : 0
    // height: item ? item.height : 0
    onStatusChanged: {
        if (status === Loader.Ready) {
            reloading = false
            if (item && model.backendObj) {
                item.backend = model.backendObj
            }
            if (item && model.settings) {
                item.settings = model.settings
            }
            if (item && item.hasOwnProperty('instanceId')) {
                item.instanceId = model.instanceId
            }
            if (item && item.hasOwnProperty('widget_id')) {
                item.widget_id = model.widget_id
            }
            if (item && item.hasOwnProperty('editMode')) {
                item.editMode = widgetsContainer.editMode
            }
            anim.start()
        } else if (status === Loader.Error) {
            console.error("Unable to load widget:", model.typeId, widgetSource)
            // A themed component can fail while the Loader source itself is
            // a widget/plugin URL, so the source path cannot identify this
            // as a theme failure.
            AppCentral.reportThemeLoadFailure(widgetSource)
        }
    }

    Connections {
        target: WidgetsModel
        function onModelChanged() {
            if (loader.item && model.settings) {
                loader.item.settings = model.settings
            }
            if (loader.item && loader.item.hasOwnProperty('instanceId')) {
                loader.item.instanceId = model.instanceId
            }
            if (loader.item && loader.item.hasOwnProperty('widget_id')) {
                loader.item.widget_id = model.widget_id
            }
        }
    }

    Connections {
        target: widgetsContainer
        function onEditModeChanged() {
            if (loader.item && loader.item.hasOwnProperty('editMode')) {
                loader.item.editMode = widgetsContainer.editMode
            }
        }
    }

    // Connections {
    //     target: CWThemeManager
    //     function onThemeChanged() {
    //         if (reloading) {
    //             console.log("WidgetLoader: Already reloading, skip:", model.name)
    //             return
    //         }
    //         console.log("WidgetLoader: Theme changed signal received, will reload:", model.name)
    //     }
    // }

    Connections {
        target: CWThemeManager
        // 感谢gemini的超强research，要不然我一辈子都solve不了
        function onThemeReadyToReload() {
            // reload()
            if (reloading) return

            reloading = true
            var oldSource = widgetSource.toString()
            source = ""

            Qt.callLater(function() {
                // 关键：添加时间戳参数强制引擎重新扫描 importPathList
                // 即使是本地文件，QML 也会因为 URL 变化而重新加载解析上下文
                var cacheBuster = (oldSource.indexOf("?") >= 0 ? "&" : "?") + "t=" + Date.now()
                source = oldSource + cacheBuster
            })
        }
    }
}
