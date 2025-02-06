use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;
use zbus::{dbus_interface, ConnectionBuilder};
use zbus::zvariant::Value;

/// Estructura que representa una notificación.
#[derive(Clone, Debug)]
struct Notification {
    summary: String,
    body: String,
    icon: String,
}

/// Función auxiliar que "imprime" el estado actual de las notificaciones
/// utilizando un formato similar al DSL del ejemplo original.
fn print_state(notifications: &Arc<Mutex<Vec<Notification>>>) {
    let notifs = notifications.lock().unwrap();
    let mut output = String::new();
    for notif in notifs.iter() {
        output.push_str(&format!(
            " (button :class 'notif' \
             (box :orientation 'horizontal' :space-evenly false \
                (image :image-width 80 :image-height 80 :path '{}') \
                (box :orientation 'vertical' \
                   (label :width 100 :wrap true :text '{}') \
                   (label :width 100 :wrap true :text '{}'))))",
            notif.icon, notif.summary, notif.body
        ));
    }
    println!("(box :orientation 'vertical' {})", output);
}

/// Servidor de notificaciones que expone la interfaz D-Bus.
struct NotificationServer {
    notifications: Arc<Mutex<Vec<Notification>>>,
}

#[dbus_interface(name = "org.freedesktop.Notifications")]
impl NotificationServer {
    /// Implementación del método Notify.
    async fn notify(
        &self,
        _app_name: String,
        _replaces_id: u32,
        app_icon: String,
        summary: String,
        body: String,
        _actions: Vec<String>,
        _hints: HashMap<String, Value<'_>>, // Especificamos el lifetime explícito
        _timeout: i32,
    ) -> u32 {
        // Creamos la notificación
        let notif = Notification {
            summary: summary.clone(),
            body: body.clone(),
            icon: app_icon.clone(),
        };

        // Insertamos la notificación al comienzo de la lista.
        {
            let mut notifs = self.notifications.lock().unwrap();
            notifs.insert(0, notif.clone());
        }
        print_state(&self.notifications);

        // Clonamos el Arc para pasarlo al hilo que se encargará de remover la notificación.
        let notifications_clone = self.notifications.clone();
        // Clonamos la notificación para poder identificarla luego.
        let notif_clone = notif.clone();
        thread::spawn(move || {
            thread::sleep(Duration::from_secs(10));
            let mut notifs = notifications_clone.lock().unwrap();
            if let Some(pos) = notifs.iter().position(|x| {
                x.summary == notif_clone.summary &&
                x.body == notif_clone.body &&
                x.icon == notif_clone.icon
            }) {
                notifs.remove(pos);
            }
            print_state(&notifications_clone);
        });
        0
    }

    /// Implementación del método GetServerInformation.
    async fn get_server_information(&self) -> (String, String, String, String) {
        (
            "Custom Notification Server".to_string(),
            "ExampleNS".to_string(),
            "1.0".to_string(),
            "1.2".to_string(),
        )
    }
}

/// Función principal que configura el servicio D-Bus.
#[tokio::main]
async fn main() -> zbus::Result<()> {
    // Creamos la estructura compartida para las notificaciones.
    let notifications = Arc::new(Mutex::new(Vec::<Notification>::new()));
    let server = NotificationServer {
        notifications: notifications.clone(),
    };

    // Conectamos al bus de sesión y publicamos el objeto en la ruta deseada.
    let _connection = ConnectionBuilder::session()?
        .name("org.freedesktop.Notifications")?
        .serve_at("/org/freedesktop/Notifications", server)?
        .build()
        .await?;

    // Mantenemos el servicio corriendo indefinidamente.
    loop {
        tokio::time::sleep(Duration::from_secs(60)).await;
    }
}
