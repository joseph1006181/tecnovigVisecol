import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';
import 'package:tecnovig/Models/Usuario.dart';

class NotificacionesView extends StatefulWidget {

  Usuario? user;
  NotificacionesView({super.key, this.user});

  @override
  State<NotificacionesView> createState() => _NotificacionesViewState();
}

class _NotificacionesViewState extends State<NotificacionesView> {
  Usuario? user;
  @override
  void initState() {
    // TODO: implement initState

    user = widget.user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appbar(context),
       
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 0),
            child: Text(
              "Ajustes de notificaciones",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    if (user!.contactoWhatsapp == 1) {
                      _showBottomSheetAutorizar(context, "whatsApp");
                    } else {
                      _showBottomSheetCancelarNotificaciones(
                        context,
                        "whatsApp",
                      );
                    }
                  },
                  icon: Icon(
                    user!.contactoWhatsapp == 1
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                  ),
                ),
                leading: Icon(Ionicons.logo_whatsapp, size: 40),
                title: Text(
                  "Whatsapp",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "notificaciones via whatsapp",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),
          ),

          //EMAIL
          Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    if (user!.contactoCorreo == 1) {
                      _showBottomSheetAutorizar(context, "correo");
                    } else {
                      _showBottomSheetCancelarNotificaciones(context, "correo");
                    }
                  },
                  icon: Icon(
                    user!.contactoCorreo == 1
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                  ),
                ),
                leading: Icon(Icons.email_outlined, size: 40),
                title: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "notificaciones via whatsapp",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//*METODOS WIDGETS
  Padding appbar(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                splashRadius: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_rounded),
              ),
              Text(
                "Notificaciones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text("    "),
            ],
          ),
        );
  }

  void _showBottomSheetAutorizar(BuildContext context, String notificacion) {
    bool loading = false;

    actualizarState() {
      setState(() {});
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Autorizar notificaciones",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Image.asset("notifi.png", scale: 6),
                  ),

                  ListTile(
                    leading: Icon(Icons.people_alt, size: 30),
                    title: Text("Notificación de visitantes"),
                    subtitle: Text(
                      "Recibe alertas cuando alguien llegue a tu ubicación.",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Ionicons.cube, size: 30),
                    title: Text("Notificación de correspondencia"),
                    subtitle: Text(
                      "Mantente informado sobre la llegada de paquetes o documentos.",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Ionicons.megaphone, size: 30),
                    title: Text("Noticias y alertas importantes"),
                    subtitle: Text(
                      "Obtén avisos sobre eventos, emergencias y novedades.",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color?>(
                            Color(0xff375CA6),
                          ),
                          shape: WidgetStatePropertyAll<OutlinedBorder?>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ), // Borde redondeado
                              //  side: BorderSide(color: Colors.red, width: 2), // Color y grosor del borde
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });

                          dynamic response = await UsuarioController()
                              .autorizarNotificaciones(
                                2,
                                int.parse(user!.cedula),
                                notificacion,
                              );

                          if (response == "200") {
                            if (notificacion == "whatsApp") {
                              user!.contactoWhatsapp = 2;
                            }
                            if (notificacion == "correo") {
                              user!.contactoCorreo = 2;
                            }

                            actualizarState();

                            setState(() {
                              loading = false;
                            });
                            Navigator.pop(context);
                            mostrarMensaje(
                              context,
                              "Notificaciones activas",
                              color: Colors.green,
                            );
                          } else {
                            Navigator.pop(context);

                            mostrarMensaje(
                              context,
                              "Error inesperado",
                              color: Colors.red,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),

                          child:
                              loading
                                  ? CircularProgressIndicator()
                                  : Text(
                                    "Autorizar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBottomSheetCancelarNotificaciones(
    BuildContext context,
    String notificacion,
  ) {
    bool loading = false;
    actualizarState() {
      setState(() {});
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Cancelar notificaciones",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                      child: Image.asset("cancelar_notifi.png", scale: 6),
                    ),

                    ListTile(
                      leading: Icon(Icons.people_alt, size: 30),
                      title: Text("Desactivar notificación de visitantes"),
                      subtitle: Text(
                        "Dejarás de recibir alertas cuando alguien llegue a tu ubicación.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Ionicons.cube, size: 30),
                      title: Text("Desactivar notificación de correspondencia"),
                      subtitle: Text(
                        "No recibirás avisos sobre la llegada de paquetes o documentos.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Ionicons.megaphone, size: 30),
                      title: Text("Desactivar noticias y alertas importantes"),
                      subtitle: Text(
                        "No se te informará sobre eventos, emergencias o novedades.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color?>(
                              Colors.red,
                            ),
                            shape: WidgetStatePropertyAll<OutlinedBorder?>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ), // Borde redondeado
                                //  side: BorderSide(color: Colors.red, width: 2), // Color y grosor del borde
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });

                            dynamic response = await UsuarioController()
                                .autorizarNotificaciones(
                                  1,
                                  int.parse(user!.cedula),
                                  notificacion,
                                );

                            if (response == "200") {
                              if (notificacion == "whatsApp") {
                                user!.contactoWhatsapp = 1;
                              }
                              if (notificacion == "correo") {
                                user!.contactoCorreo = 1;
                              }

                              actualizarState();

                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                              mostrarMensaje(
                                context,
                                "Notificaciones desactivadas",
                                color: Colors.black,
                              );
                            } else {
                              Navigator.pop(context);

                              mostrarMensaje(
                                context,
                                "Error inesperado",
                                color: Colors.red,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                loading
                                    ? CircularProgressIndicator()
                                    : Text(
                                      "Cancelar notificaciones",
                                      style: TextStyle(color: Colors.white),
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
