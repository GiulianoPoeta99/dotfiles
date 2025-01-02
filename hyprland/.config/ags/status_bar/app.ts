import { App } from "astal/gtk3"
import style from "./style.scss"
import StatusBar from "./widget/StatusBar"
import AppLauncher from "./widget/AppLauncher"


App.start({
    css: style,
    instanceName: "main",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(StatusBar)
})
