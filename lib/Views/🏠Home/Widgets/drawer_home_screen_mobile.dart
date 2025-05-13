 //*METOOS WIDGETS
  import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/Widgets/CustomPageRoute.dart';

import 'package:tecnovig/Utilities/alertDialog.dart';
import 'package:tecnovig/Views/%F0%9F%94%94Notificaciones/notificaciones_screen.dart';
import 'package:tecnovig/Views/%F0%9F%91%A4Perfil/profile_screen.dart';

Stack drawerHomeScreenMOBILE(BuildContext context  , UsuarioModel? user) {
    return Stack(
      children: [
        Drawer(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("LogoTecnoVig2.png"),
                      SizedBox(height: 10),
                      SizedBox(height: 10),

                      Text(
                        user != null ? user.nombre : "",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
               
                      Row(
                        children: [
                          Icon(
                            Icons.apartment_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4),
                          Text(
                            user != null ? user.espacio : "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
             ),
                      SizedBox(height: 5),

              user != null
                  ? ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(page: ProfileScreen(user: user)),
                      );
                    },
                    leading: Icon(Icons.person, size: 27),
                    title: Text("Perfil", style: TextStyle(fontSize: 15)),
                  )
                  : ListTile(
                    title: Card(
                      margin: EdgeInsets.only(right: 10),
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(""),
                      ),
                    ),
                  ),

              user != null
                  ? ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(page: NotificacionesScreen(user: user)),
                      );
                    },
                    leading: Icon(Icons.notifications, size: 27),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black54,
                    ),

                    title: Text(
                      "Notificaciones",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                  : ListTile(
                    title: Card(
                      margin: EdgeInsets.only(right: 30),
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(""),
                      ),
                    ),
                  ),

              user != null
                  ? ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black54,
                    ),

                    leading: Icon(Icons.question_answer_sharp, size: 27),
                    title: Text("Pqrs", style: TextStyle(fontSize: 15)),
                    subtitle: Text(
                      "peticiones, quejas, reclamos, sugerencias ",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  )
                  : ListTile(
                    title: Card(
                      margin: EdgeInsets.only(right: 30),
                      color: Colors.white,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(""),
                      ),
                    ),
                  ),
            ],
          ),
        ),

        Positioned(
          left: 30,
          bottom: 15,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.logout, color: Colors.black54),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      alertDIalogInfoCustom(
                        context, //contexto
                        "Cerrar sesion", //title
                        "¿Estás seguro de que deseas cerrar sesión?", //descripcion
                        () {
                          Navigator.of(context).pop();

                          LoginController().cerrarSesion(context); // Function
                        },
                      );
                    },
                    child: Text("cerrar sesion"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }