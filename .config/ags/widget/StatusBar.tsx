import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box className="workspaces_container">
      <box className="Workspaces">
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
      </box>
    </box>
}

export default function StatusBar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        marginTop={8}
        marginBottom={0}
      >
        <centerbox>
            <box hexpand halign={Gtk.Align.START} className="bar_right"></box>
            <box>
              <box className="workspaces">
                <Workspaces />
              </box>
            </box>
            <box hexpand halign={Gtk.Align.END} className="bar_left"></box>
        </centerbox>
    </window>
}
