import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/comunicado_controllers.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Models/comunicado_model.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/VALIDATORS/validator.dart';
import 'package:tecnovig/Utilities/Widgets/launchInBrowser.dart';
import 'package:tecnovig/Utilities/alertDialog.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/acciones_card_desktop.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/acciones_card_mobile.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/base_page_card.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/drawer_home_screen.desktop.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/drawer_home_screen_mobile.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/user_info_header.dart';
import 'package:tecnovig/Views/%E2%9C%89%EF%B8%8F%20Correspondencia/correspondencia_screen.dart';
import 'package:tecnovig/Views/%F0%9F%94%94Notificaciones/notificaciones_screen.dart';
import 'package:tecnovig/Views/%F0%9F%91%A4Perfil/profile_screen.dart';
import 'package:tecnovig/Views/%F0%9F%8F%9E%EF%B8%8F%20Reserva_espacios/reserva_espacios.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/visita_screen.dart'
    show VisitaScreen;
import 'package:tecnovig/Utilities/Widgets/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/Widgets/responsive_layout.dart';
import 'dart:ui' as html;

//* esta vista sera la que se muestre al usuario despues de haber hecho el loggin , aqui se mostraran las opciones del menu
class HomeCliente extends StatefulWidget {
  const HomeCliente({super.key});

  @override
  State<HomeCliente> createState() => HomeClienteState();
}

class HomeClienteState extends State<HomeCliente> {
  // variabales para la vista DESTKTOP

  //?----------------------------------- DESKTOP VIEW---------------------------------------------------------------------------------

  final _formKeyViewPerfil =
      GlobalKey<FormState>(); // valida textField de la vista ValidarUserMobile

  TextEditingController telefonoController = TextEditingController();

  TextEditingController correoController = TextEditingController();

  PageController pageViewControllerDESKTOP = PageController(
    initialPage: 0,
    keepPage: true,
  );

  bool guardando = false;
  bool editando = false;
  bool isHoveringVisitantes = false;
  bool isHoveringCorrespondencia = false;
  bool isHoveringEspacios = false;

  int currentPageDESKTOP = 0;

  //?----------------------------------- MOBILE VIEW---------------------------------------------------------------------------------

  final List<Color> _pages = [Colors.red, Colors.green, Colors.blue];

  int _currentPage = 0;

  final PageController _pageControllerCarruselDeNoticias = PageController(
    initialPage: 2,
  );

  //?----------------------------------- VARS SHARED VIEW--------------------------------------------------------------------------

  UsuarioModel? user;

  List<String?> inicioSesionPreferences = [];
  List<Comunicado> listComunicados = [];

  late Timer timer;

  @override
  void initState() {
    consultaPreferes();
    consultaComunicados();
    _pageControllerCarruselDeNoticias.addListener(listener);

    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _pageControllerCarruselDeNoticias.dispose();
    pageViewControllerDESKTOP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: homeScreenMOBILE(context),

      tabletBody: homeScreenTABLET(context),

      desktopBody: homeScreenDESKTOP(),
    );
  }

  //?----------------------------------- MOBILE VIEW   -----------------------------------------------------------

  // * WIDGETS MOBILE

  Scaffold homeScreenMOBILE(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: drawerHomeScreenMOBILE(context, user),
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset("LogoTecnoVig2.png", height: 45),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 4, 0),
            child: Tooltip(
              message: user != null ? user!.nombre : "",
              child: CircleAvatar(
                backgroundColor: Colors.grey[400],
                child:
                    user != null
                        ? Center(
                          child: Text(
                            user!.nombre.substring(0, 2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ),
          ),
        ],

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),

          encabezadosText(title: "Noticias"),

          SizedBox(height: 6),

          carruselDeNoticias(),

          SizedBox(height: 4),

          Stack(
            children: [
              encabezadosText(title: "Utilidades"),
              indicadorCarruselNoticias(),
            ],
          ),

          SizedBox(height: 6),

          Expanded(
            flex: 3,

            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                accionesCardMOBILE2(
                  imagePath: "visitantesDesktop.png",
                  label: "Visitantes",
                  onTap: () => navigateToVisitantes(),
                  isEnabled: user != null,
                  onHoverChanged:
                      (value) => setState(() => isHoveringEspacios = value),
                ),
                accionesCardMOBILE2(
                  imagePath: "correspondenciaDesktop.jpg",
                  label: "Correspondencia",
                  onTap: () => navigateToCorrespondencia(),
                  isEnabled: user != null,
                  onHoverChanged:
                      (value) => setState(() => isHoveringEspacios = value),
                ),
                accionesCardMOBILE2(
                  imagePath: "espacioDesktop.png",
                  label: "Reserva espacios",
                  onTap: () => navigateToReservaEspacios(),
                  isEnabled: user != null,
                  onHoverChanged:
                      (value) => setState(() => isHoveringEspacios = value),
                ),

                // accionesCardMOBILE(
                //   context: context,
                //   user: user,
                //   pagePush: VisitaScreen(
                //     idCorrespondencia:
                //         user != null ? user!.toJson()["id"].toString() : "",
                //   ),
                //   title: "Visitantes",
                //   pathImageAsset: "visitantes.png",
                // ),

                // accionesCardMOBILE(
                //    context: context,
                //   user: user,
                //   pagePush: CorrespondenciaScreen(
                //     idCorrespondencia:
                //         user != null ? user!.toJson()["id"].toString() : "",
                //   ),
                //   title: "Correspondencia",
                //   pathImageAsset: "correspondencia.png",
                // ),

                // accionesCardMOBILE(
                //    context: context,
                //   user: user,
                //   pagePush: ReservaEspacios(idUser: user?.id),
                //   title: "Reserva espacios",
                //   pathImageAsset: "reservaEspacios.png",
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget carruselDeNoticias() {
    return Expanded(
      child: PageView(
        controller: _pageControllerCarruselDeNoticias,
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < listComunicados.length; i++)
            GestureDetector(
              onTap: () {
if (listComunicados[i].getLink.toString().isEmpty) {
  print("esta vacio");
} else {
      launchInBrowser(Uri.parse(listComunicados[i].getLink.toString()));
  
}




              },
              child: Card(
                elevation: 2,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://software.tecnovig.com/${listComunicados[i].getImagen}",
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.red,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  //?----------------------------------- TABLET VIEW   -----------------------------------------------------------

  // * WIDGETS TABLET

  Scaffold homeScreenTABLET(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          cambiarPageDESKTOP(
                            nameMethodChangePage: "animateToPage",
                            page: 0,
                          );
                        },
                        icon:
                            currentPageDESKTOP == 0
                                ? Icon(
                                  color: Colors.white,
                                  Icons.home,
                                  size: 45,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ), // sombra negra semi-transparente
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                        2,
                                        2,
                                      ), // desplazamiento de la sombra
                                    ),
                                  ],
                                )
                                : Icon(Icons.home, size: 40),
                      ),
                      SizedBox(height: 20),

                      IconButton(
                        onPressed: () {
                          cambiarPageDESKTOP(
                            nameMethodChangePage: "animateToPage",
                            page: 1,
                          );
                        },
                        icon:
                            currentPageDESKTOP == 1
                                ? Icon(
                                  color: Colors.white,
                                  Icons.person,
                                  size: 45,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ), // sombra negra semi-transparente
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                        2,
                                        2,
                                      ), // desplazamiento de la sombra
                                    ),
                                  ],
                                )
                                : Icon(Icons.person, size: 40),
                      ),
                      SizedBox(height: 20),

                      IconButton(
                        onPressed: () {
                          cambiarPageDESKTOP(
                            nameMethodChangePage: "animateToPage",
                            page: 2,
                          );
                        },
                        icon:
                            currentPageDESKTOP == 2
                                ? Icon(
                                  color: Colors.white,
                                  Icons.notifications,
                                  size: 45,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        0.3,
                                      ), // sombra negra semi-transparente
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                        2,
                                        2,
                                      ), // desplazamiento de la sombra
                                    ),
                                  ],
                                )
                                : Icon(Icons.notifications, size: 40),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          alertDIalogInfoCustom(
                            context, //contexto
                            "Cerrar sesion", //title
                            "¿Estás seguro de que deseas cerrar sesión?", //descripcion
                            () {
                              Navigator.of(context).pop();

                              LoginController().cerrarSesion(
                                context,
                              ); // Function
                            },
                          );
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          color: Colors.red[300],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageViewControllerDESKTOP,
              children: [
                pageViewhomeTABLET(),
                user != null
                    ? pageViewprofileTABLET()
                    : Center(child: CircularProgressIndicator()),
                pageViewNotificacionesTABLET(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pageViewhomeTABLET() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 30),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset("LogoTecnoVig2.png", height: 45),
              ),

              Tooltip(
                message: user != null ? user!.nombre : "",
                child: CircleAvatar(
                  //  radius: 13,
                  backgroundColor: Colors.grey[400],
                  child:
                      user != null
                          ? Center(
                            child: Text(
                              user!.nombre.substring(0, 2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
        encabezadosText(title: "Noticias"),

        SizedBox(height: 6),

        carruselDeNoticias(),

        SizedBox(height: 4),

        Stack(
          children: [
            encabezadosText(title: "Utilidades"),
            indicadorCarruselNoticias(),
          ],
        ),
        SizedBox(height: 6),

        Expanded(
          flex: 3,

          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              accionesCardMOBILE2(
                imagePath: "visitantesDesktop.png",
                label: "Visitantes",
                onTap: () => navigateToVisitantes(),
                isEnabled: user != null,
                onHoverChanged:
                    (value) => setState(() => isHoveringEspacios = value),
              ),
              accionesCardMOBILE2(
                imagePath: "correspondenciaDesktop.jpg",
                label: "Correspondencia",
                onTap: () => navigateToCorrespondencia(),
                isEnabled: user != null,
                onHoverChanged:
                    (value) => setState(() => isHoveringEspacios = value),
              ),
              accionesCardMOBILE2(
                imagePath: "espacioDesktop.png",
                label: "Reserva espacios",
                onTap: () => navigateToReservaEspacios(),
                isEnabled: user != null,
                onHoverChanged:
                    (value) => setState(() => isHoveringEspacios = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget pageViewprofileTABLET() {
    return Form(
      key: _formKeyViewPerfil,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),

              Icon(
                Icons.apartment_rounded,
                size: 100,
                color: Colors.black54,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.3,
                    ), // sombra negra semi-transparente
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(2, 2), // desplazamiento de la sombra
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  user!.espacio,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: textFormFieldDESKTOP(
                  suffixIcon: Icon(
                    Icons.edit_off_outlined,
                    color: Colors.black54,
                  ),

                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.badge_rounded, size: 35),
                  ),
                  obscureText: false,
                  inputFormatters: false,
                  readOnly: true,
                  title: "cedula usuario",
                  controller: TextEditingController(
                    text: user != null ? user!.cedula : "",
                  ),
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: textFormFieldDESKTOP(
                  suffixIcon: Icon(
                    Icons.edit_off_outlined,
                    color: Colors.black54,
                  ),

                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.person_outline_outlined, size: 35),
                  ),
                  obscureText: false,
                  inputFormatters: false,
                  readOnly: true,
                  title: "cedula usuario",
                  controller: TextEditingController(
                    text: user != null ? user!.nombre : "",
                  ),
                ),
              ),
              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  children: [
                    textFormFieldDESKTOP(
                      validator: Validators.validatorTelefono,
                      suffixIcon:
                          !guardando
                              ? Icon(Icons.mode_edit_outline_outlined)
                              : CircularProgressIndicator(
                                padding: EdgeInsets.fromLTRB(8, 4, 12, 4),
                                color: Colors.blue,
                              ),

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.phone, size: 35),
                      ),
                      obscureText: false,
                      inputFormatters: true,
                      readOnly: guardando ? true : false,
                      title: "telefon usuario",
                      controller: telefonoController,
                    ),

                    user != null && user!.telefono != telefonoController.text
                        ? Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                guardarCambios();
                              },
                              icon: Tooltip(
                                message: "Guardar cambios",
                                child: Icon(
                                  Icons.check_circle_sharp,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cancelarCambios();
                              },
                              icon: Tooltip(
                                message: "Cancelar cambios",
                                child: Icon(Icons.cancel, color: Colors.red),
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  children: [
                    textFormFieldDESKTOP(
                      validator: Validators.isEmail,
                      suffixIcon:
                          !guardando
                              ? Icon(Icons.mode_edit_outline_outlined)
                              : CircularProgressIndicator(
                                padding: EdgeInsets.fromLTRB(8, 4, 12, 4),
                                color: Colors.blue,
                              ),

                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.email, size: 35),
                      ),
                      obscureText: false,
                      inputFormatters: false,
                      readOnly: guardando ? true : false,
                      title: "correo usuario",
                      controller: correoController,
                    ),

                    user != null && user!.correo != correoController.text
                        ? Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                guardarCambios();
                              },
                              icon: Tooltip(
                                message: "Guardar cambios",
                                child: Icon(
                                  Icons.check_circle_sharp,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cancelarCambios();
                              },
                              icon: Tooltip(
                                message: "Cancelar cambios",
                                child: Icon(Icons.cancel, color: Colors.red),
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageViewNotificacionesTABLET() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30),

        Icon(
          Icons.notifications_active,
          size: 100,
          color: Colors.black54,
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.3,
              ), // sombra negra semi-transparente
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(2, 2), // desplazamiento de la sombra
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "NOTIFICACIONES",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
        SizedBox(height: 30),
        Card(
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(8, 0, 18, 0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                user != null
                    ? ListTile(
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
                    )
                    : Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // 🎯 Esquinas redondeadas
                      ),
                      width: double.maxFinite,
                      height: 60,
                    ),
          ),
        ),

        SizedBox(height: 30),

        Card(
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(8, 0, 18, 0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                user != null
                    ? ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          if (user!.contactoCorreo == 1) {
                            _showBottomSheetAutorizar(context, "correo");
                          } else {
                            _showBottomSheetCancelarNotificaciones(
                              context,
                              "correo",
                            );
                          }
                        },
                        icon: Icon(
                          user!.contactoCorreo == 1
                              ? Icons.check_box_outline_blank
                              : Icons.check_box,
                        ),
                      ),
                      leading: Icon(Icons.email, size: 40),
                      title: Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "notificaciones via Correo electronico",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // 🎯 Esquinas redondeadas
                      ),
                      width: double.maxFinite,
                      height: 60,
                    ),
          ),
        ),
      ],
    );
  }

  //?----------------------------------- TABLET VIEW   -----------------------------------------------------------

  //?----------------------------------- DESKTOP VIEW   -----------------------------------------------------------

  // * WIDGETS DESKTOP
  Scaffold homeScreenDESKTOP() {
    //*HOME

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          drawerHomeScreenDESKTOP(),
          //  SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: PageView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              controller: pageViewControllerDESKTOP,
              children: [
                pageViewInicioDESKTOP(),
                pageViewPerfilDESKTOP(),
                pageViewNotificacionesDESKTOP(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pageViewInicioDESKTOP() {
    //*HOME/INICIO
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11),
          topRight: Radius.circular(11),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      margin: EdgeInsets.fromLTRB(14, 9, 8, 0),
      child: Column(
        children: [
          //informacion de la persona loggeada
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "I N I C I O",
                    style: TextStyle(
                      letterSpacing: 2.5,
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                userInfoHeader(user: user),
              ],
            ),
          ),
          Divider(color: Colors.black54, thickness: 0.2),
          //etiqueta de Noticias
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 08),
              child: encabezadosText(title: "Noticias"),
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageControllerCarruselDeNoticias,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < listComunicados.length; i++)
                  GestureDetector(
                    onTap: () {

                      if (listComunicados[i].getLink.toString().isEmpty) {
  print("esta vacio");
} else {
      launchInBrowser(Uri.parse(listComunicados[i].getLink.toString()));
  
}
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "https://software.tecnovig.com/${listComunicados[i].getImagen}",
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.red,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),

                      //anuncioEscrito(),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: indicadorCarruselNoticias(),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
              child: encabezadosText(title: "Utilidades"),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                accionesCardImageDESKTOP(
                  imagePath: "visitantesDesktop.png",
                  label: "Visitantes",
                  onTap: () => navigateToVisitantes(),
                  isEnabled: user != null,
                  isHovering: isHoveringVisitantes,
                  onHoverChanged:
                      (value) => setState(() => isHoveringVisitantes = value),
                ),

                accionesCardImageDESKTOP(
                  imagePath: "correspondenciaDesktop.jpg",
                  label: "Correspondencia",
                  onTap: () => navigateToCorrespondencia(),
                  isEnabled: user != null,
                  isHovering: isHoveringCorrespondencia,
                  onHoverChanged:
                      (value) =>
                          setState(() => isHoveringCorrespondencia = value),
                ),

                accionesCardImageDESKTOP(
                  imagePath: "espacioDesktop.png",
                  label: "Reserva espacios",
                  onTap: () => navigateToReservaEspacios(),
                  isEnabled: user != null,
                  isHovering: isHoveringEspacios,
                  onHoverChanged:
                      (value) => setState(() => isHoveringEspacios = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pageViewPerfilDESKTOP() {
    //*HOME/PERFIL

    return basePageCard(
      userHeader: userInfoHeader(user: user),
      pageName: "P E R F I L",
      content: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icono de apartamento y nombre apartamento
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apartment_rounded,
                    size: 200,
                    color: Colors.black54,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.3,
                        ), // sombra negra semi-transparente
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 2), // desplazamiento de la sombra
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      user != null ? user!.espacio : "",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            // lista de atributos de usuario
            Expanded(
              child: Form(
                key: _formKeyViewPerfil,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: textFormFieldDESKTOP(
                        suffixIcon: Icon(
                          Icons.edit_off_outlined,
                          color: Colors.black54,
                        ),

                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.person_outline_outlined, size: 35),
                        ),
                        obscureText: false,
                        inputFormatters: false,
                        readOnly: true,
                        title: "cedula usuario",
                        controller: TextEditingController(
                          text: user != null ? user!.nombre : "",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: textFormFieldDESKTOP(
                        suffixIcon: Icon(
                          Icons.edit_off_outlined,
                          color: Colors.black54,
                        ),

                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.badge_rounded, size: 35),
                        ),
                        obscureText: false,
                        inputFormatters: false,
                        readOnly: true,
                        title: "cedula usuario",
                        controller: TextEditingController(
                          text: user != null ? user!.cedula : "",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: Wrap(
                        children: [
                          textFormFieldDESKTOP(
                            validator: Validators.validatorTelefono,
                            suffixIcon:
                                !guardando
                                    ? Icon(Icons.mode_edit_outline_outlined)
                                    : CircularProgressIndicator(
                                      padding: EdgeInsets.fromLTRB(8, 4, 12, 4),
                                      color: Colors.blue,
                                    ),

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.phone, size: 35),
                            ),
                            obscureText: false,
                            inputFormatters: true,
                            readOnly: guardando ? true : false,
                            title: "telefon usuario",
                            controller: telefonoController,
                          ),

                          user != null &&
                                  user!.telefono != telefonoController.text
                              ? Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      guardarCambios();
                                    },
                                    icon: Tooltip(
                                      message: "Guardar cambios",
                                      child: Icon(
                                        Icons.check_circle_sharp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cancelarCambios();
                                    },
                                    icon: Tooltip(
                                      message: "Cancelar cambios",
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: Wrap(
                        children: [
                          textFormFieldDESKTOP(
                            validator: Validators.isEmail,
                            suffixIcon:
                                !guardando
                                    ? Icon(Icons.mode_edit_outline_outlined)
                                    : CircularProgressIndicator(
                                      padding: EdgeInsets.fromLTRB(8, 4, 12, 4),
                                      color: Colors.blue,
                                    ),

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.email, size: 35),
                            ),
                            obscureText: false,
                            inputFormatters: false,
                            readOnly: guardando ? true : false,
                            title: "correo usuario",
                            controller: correoController,
                          ),

                          user != null && user!.correo != correoController.text
                              ? Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      guardarCambios();
                                    },
                                    icon: Tooltip(
                                      message: "Guardar cambios",
                                      child: Icon(
                                        Icons.check_circle_sharp,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cancelarCambios();
                                    },
                                    icon: Tooltip(
                                      message: "Cancelar cambios",
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageViewNotificacionesDESKTOP() {
    //*HOME/NOTIFICACIONES

    return basePageCard(
      pageName: "N O T I F I C A C I O N E S",
      userHeader: userInfoHeader(user: user),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icono de apartamento y nombre apartamento
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 200,
                  color: Colors.black54,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.3,
                      ), // sombra negra semi-transparente
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(2, 2), // desplazamiento de la sombra
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    "NOTIFICACIONES",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          // lista de atributos de usuario
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 70),

                Card(
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        user != null
                            ? ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  if (user!.contactoWhatsapp == 1) {
                                    _showBottomSheetAutorizar(
                                      context,
                                      "whatsApp",
                                    );
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
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            )
                            : Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  15,
                                ), // 🎯 Esquinas redondeadas
                              ),
                              width: double.maxFinite,
                              height: 60,
                            ),
                  ),
                ),
                SizedBox(height: 30),

                Card(
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        user != null
                            ? ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  if (user!.contactoCorreo == 1) {
                                    _showBottomSheetAutorizar(
                                      context,
                                      "correo",
                                    );
                                  } else {
                                    _showBottomSheetCancelarNotificaciones(
                                      context,
                                      "correo",
                                    );
                                  }
                                },
                                icon: Icon(
                                  user!.contactoCorreo == 1
                                      ? Icons.check_box_outline_blank
                                      : Icons.check_box,
                                ),
                              ),
                              leading: Icon(Icons.email, size: 40),
                              title: Text(
                                "Email",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "notificaciones via Correo electronico",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            )
                            : Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  15,
                                ), // 🎯 Esquinas redondeadas
                              ),
                              width: double.maxFinite,
                              height: 60,
                            ),
                  ),
                ),

                SizedBox(height: 30),
                SizedBox(height: 30),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerHomeScreenDESKTOP() {
    return Drawer(
      width: 250,
      surfaceTintColor: Colors.grey[300],
      backgroundColor: Colors.grey[300],
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  child: Image.asset("logoRedondo.png", width: 200)
                      .animate(
                        onPlay:
                            (controller) =>
                                controller
                                    .repeat(), // Hace que la rotación se repita
                      )
                      .rotate(
                        begin: 0,
                        end: 1,
                        duration: 5.seconds,
                        curve: Curves.linear,
                      ),
                ),
                buildDrawerTile(
                  indexx: 0,
                  icon: Icons.home,
                  text: 'I N I C I O',
                  onTap: () {
                    cambiarPageDESKTOP(
                      nameMethodChangePage: "animateToPage",
                      page: 0,
                    );
                  },
                  textStyle: drawerTextColor,
                  padding: tilePadding,
                ),
                buildDrawerTile(
                  indexx: 1,
                  icon: Icons.person,
                  text: 'P E R F I L',
                  onTap: () {
                    cambiarPageDESKTOP(
                      nameMethodChangePage: "animateToPage",
                      page: 1,
                    );
                  },
                  textStyle: drawerTextColor,
                  padding: tilePadding,
                ),
                buildDrawerTile(
                  indexx: 2,
                  icon: Icons.notifications_sharp,
                  text: 'NOTIFICACIONES',
                  onTap: () {
                    cambiarPageDESKTOP(
                      nameMethodChangePage: "animateToPage",
                      page: 2,
                    );
                  },
                  textStyle: TextStyle(
                    color: Colors.grey[600],
                    letterSpacing: 4,
                    fontSize: 14,
                  ),
                  padding: tilePadding,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
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
              icon: Icon(Icons.logout, color: Colors.red[300]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required TextStyle textStyle,
    required EdgeInsets padding,
    required int indexx,
  }) {
    return Padding(
      padding: padding,
      child: Card(
        color: indexx == currentPageDESKTOP ? Colors.white : Colors.transparent,
        elevation: 0,
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hoverColor: Colors.grey[200],
          onTap: onTap,

          title: Column(
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(text, style: textStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFormFieldDESKTOP({
    required bool inputFormatters,
    bool? readOnly = false,
    String? hintText,
    String? title,
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return TextFormField(
      onChanged: (value) {
        setState(() {});
      },

      enabled: user != null ? true : false,

      style: TextStyle(color: Colors.black),
      readOnly: readOnly!,
      validator: validator,
      obscureText: obscureText!,
      inputFormatters:
          inputFormatters
              ? [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))]
              : [],
      controller: controller,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 2,
          ), // Borde más grueso al enfocar
        ),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white), // Color del hint text
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon,
        // Ícono de usuario
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ), // Borde rojo
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ), // Borde más grueso al enfocar
        ),
      ),
    );
  }

  // * METODOS DESKTOP

  void cancelarCambios() {
    _formKeyViewPerfil.currentState!.reset();

    telefonoController.value = TextEditingValue(text: user!.telefono);
    correoController.value = TextEditingValue(text: user!.correo);

    editando = false;
    setState(() {});
  }

  void cambiarPageDESKTOP({
    required String nameMethodChangePage,
    required int page,
  }) {
    currentPageDESKTOP = page;

    if (nameMethodChangePage == "animateToPage") {
      pageViewControllerDESKTOP.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }

    if (nameMethodChangePage == "jumpToPage") {
      pageViewControllerDESKTOP.jumpToPage(page);
    }

    pageViewControllerDESKTOP = PageController(initialPage: currentPageDESKTOP);
    setState(() {});
  }

  void guardarCambios() async {
    if (_formKeyViewPerfil.currentState!.validate()) {
      setState(() {
        guardando = true;
      });

      dynamic resul = await UsuarioController().actualizarTelefono(
        context,
        int.parse(user!.cedula),

        telefonoController.text.trim(),

        correoController.text.trim(),
      );

      if (resul != null && resul != "200") {
        telefonoController.value = TextEditingValue(text: user!.telefono);
        correoController.value = TextEditingValue(text: user!.correo);
      } else {
        user!.telefono = telefonoController.text.trim();

        user!.correo = correoController.text.trim();
      }

      // print("resil"+resul);

      //    print(
      //           "user telefono " +
      //               user!.telefono +
      //               " telefono controller" +
      //               telefonoController.text,
      //         );
      //         print(
      //           "user correo " +
      //               user!.correo +
      //               " correo controller" +
      //               correoController.text,
      //         );

      setState(() {
        guardando = false;
      });
    }
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
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
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

                              if (context.mounted) {
                                Navigator.pop(context);
                                mostrarMensaje(
                                  context,
                                  "Notificaciones activas",
                                  color: Colors.green,
                                );
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pop(context);

                                mostrarMensaje(
                                  context,
                                  "Error inesperado",
                                  color: Colors.red,
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),

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
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.sizeOf(context).height * 0.85,
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
                              if (context.mounted) {
                                Navigator.pop(context);
                                mostrarMensaje(
                                  context,
                                  "Notificaciones desactivadas",
                                  color: Colors.black,
                                );
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pop(context);

                                mostrarMensaje(
                                  context,
                                  "Error inesperado",
                                  color: Colors.red,
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                loading
                                    ? CircularProgressIndicator()
                                    : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Cancelar notificaciones",
                                        style: TextStyle(color: Colors.white),
                                      ),
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

  //?----------------------------------- DESKTOP VIEW FIN  -----------------------------------------------------------

  // * WIDGETS COMPARTIDOS

  Widget indicadorCarruselNoticias() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < listComunicados.length; i++)
          // Icon(Icons.circle , color: _currentPage.toDouble() == _pageControllerCarruselDeNoticias.page ? Colors.red : null,   ),
          // Icon(Icons.circle , color: _currentPage.toDouble() == _pageControllerCarruselDeNoticias.page ? Colors.red : null,   ),
          //   Icon(Icons.circle , color: _currentPage.toDouble() == _pageControllerCarruselDeNoticias.page ? Colors.red : null,   ),
          GestureDetector(
            onTap: () {
              _pageControllerCarruselDeNoticias.animateToPage(
                i,
                duration: Duration(milliseconds: 300),
                curve: Curves.decelerate,
              );
              _currentPage = i;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Icon(
                Icons.circle,
                size: 12,
                color: _currentPage.toDouble() == i ? Colors.black87 : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget encabezadosText({String? title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: Text(
        title!,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  // * METODOS COMPARTIDOS

  void consultaComunicados() async {
    dynamic result = await ComunicadoControllers().consultaComunicados();

    if (result is List<Comunicado>) {
      listComunicados = result;
    } else {
      print('No es una lista de Comunicados');
    }

    setState(() {});
  }

  void consultaPreferes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = await UsuarioController().consultaUsuario(
      prefs.getStringList("listInfoUser")![3],
    );
    telefonoController = TextEditingController(text: user!.telefono);

    correoController = TextEditingController(text: user!.correo);
    setState(() {});
  }

  void navigateToVisitantes() {
    Navigator.push(
      context,
      CustomPageRoute(
        page: VisitaScreen(user: user, idCorrespondencia: user!.id.toString()),
      ),
    );
  }

  void navigateToCorrespondencia() {
    Navigator.push(
      context,
      CustomPageRoute(
        page: CorrespondenciaScreen(
          idCorrespondencia: user!.id.toString(),
          user: user,
        ),
      ),
    );
  }

  void navigateToReservaEspacios() {
    Navigator.push(
      context,
      CustomPageRoute(page: ReservaEspacios(idUser: user!.id, user: user)),
    );
  }

  void listener() {
    //este metodo maneja  el currentaPage de las noticias informativas del ViewMOBILE
    _currentPage = _pageControllerCarruselDeNoticias.page!.toInt();
    setState(() {});
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < listComunicados.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Regresar a la primera página
      }
      if (mounted && _pageControllerCarruselDeNoticias.hasClients) {
        _pageControllerCarruselDeNoticias.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
