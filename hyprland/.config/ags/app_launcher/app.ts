import { App } from "astal/gtk3"
import style from "./style.scss"
import Applauncher from "./widget/AppLauncher"

App.start({
    instanceName: "launcher",
    css: style,
    main: Applauncher,
})
