import { App } from "astal/gtk3"
import style from "./style.scss"
import StatusBar from "./widget/StatusBar"
import AppLauncher from "./widget/AppLauncher"
import NotificationPopups from "./widget/NotificationPopups"


App.start({
    css: style,
    instanceName: "status_bar",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(StatusBar)
})

App.start({
    instanceName: "launcher",
    css: style,
    main: AppLauncher,
})

App.start({
    instanceName: "notifications",
    css: style,
    main: () => App.get_monitors().map(NotificationPopups),
})

