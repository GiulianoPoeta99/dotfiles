#!/usr/bin/ags run
import style from "./style.scss"
import { App } from "astal/gtk3"
import Dialog from "./widget/Dialog"

App.start({
    instanceName: "tmp" + Date.now(),
    css: style,
    main: (action = "XYZ") => Dialog(action)
})
