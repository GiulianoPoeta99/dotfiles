import { App, Astal, Gtk, Gdk } from "astal/gtk3"

function yes() {
  print("yes")
  App.quit()
}

function no() {
  print("no")
  App.quit()
}

function onKeyPress(_: Astal.Window, event: Gdk.Event) {
  if (event.get_keyval()[1] === Gdk.KEY_Escape) {
    no()
  }
}

export default function Dialog(action: String) {
  const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor
  const { IGNORE } = Astal.Exclusivity
  const { EXCLUSIVE } = Astal.Keymode
  const { CENTER } = Gtk.Align

  return <window
    onKeyPressEvent={onKeyPress}
    exclusivity={IGNORE}
    keymode={EXCLUSIVE}
    anchor={TOP | BOTTOM | LEFT | RIGHT}
  >
    <box halign={CENTER} valign={CENTER} vertical>
       <label className="title" label="Are you sure you want to do" />
       <label className="action" label={`${action}?`} />
       <box homogeneous>
         <button onClicked={yes}>
           Yes
         </button>
         <button onClicked={no}>
           No
         </button>
       </box>
    </box>
  </window>
}
