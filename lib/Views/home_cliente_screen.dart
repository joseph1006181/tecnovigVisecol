import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertDialog.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/drawer_home_screen.desktop.dart';
import 'package:tecnovig/Utilities/drawer_home_screen_mobile.dart';
import 'package:tecnovig/Utilities/responsive_layout.dart';
import 'package:tecnovig/Views/correspondencia_screen.dart';
import 'package:tecnovig/Views/notificaciones_screen.dart';
import 'package:tecnovig/Views/profile_screen.dart';
import 'package:tecnovig/Views/reserva_espacios.dart';
import 'package:tecnovig/Views/visita_screen.dart' show VisitaScreen;
import 'package:tecnovig/Views/espacio_screen.dart';

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

  final PageController _pageController = PageController(initialPage: 2);

  //?----------------------------------- VARS SHARED VIEW--------------------------------------------------------------------------

  UsuarioModel? user;

  List<String?> inicioSesionPreferences = [];

  late Timer timer;

  @override
  void initState() {
    consultaPreferes();
    _pageController.addListener(listener);

    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    pageViewControllerDESKTOP.dispose();
    super.dispose();
  }

  void listener() {
    //este metodo maneja  el currentaPage de las noticias informativas del ViewMOBILE
    _currentPage = _pageController.page!.toInt();
    setState(() {});
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Regresar a la primera página
      }
      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: homeScreenMOBILE(context),

      tabletBody: homeScreenTABLET(context),

      desktopBody: homeScreenDESKTOP(),
    );
  }

  //?----------------------------------- MOBILE VIEW INICIO  -----------------------------------------------------------

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
            padding: const EdgeInsets.all(4.0),
            child: Tooltip(
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
          ),
        ],

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),

          etiquetas(title: "Noticias"),

          SizedBox(height: 6),

          cardNoticias(),

          SizedBox(height: 4),

          Stack(
            children: [
              etiquetas(title: "Utilidades"),
              botonesDeCambioNoticias(),
            ],
          ),
          SizedBox(height: 6),

          Expanded(
            flex: 3,

            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                accionesCardMOBILE(
                  page: VisitaScreen(
                    idCorrespondencia:
                        user != null ? user!.toJson()["id"].toString() : "",
                  ),
                  title: "Visitantes",
                  pathImageAsset: "visitantes.png",
                ),

                accionesCardMOBILE(
                  page: CorrespondenciaScreen(
                    idCorrespondencia:
                        user != null ? user!.toJson()["id"].toString() : "",
                  ),
                  title: "Correspondencia",
                  pathImageAsset: "correspondencia.png",
                ),

                accionesCardMOBILE(
                  page: ReservaEspacios(idUser: user?.id),
                  title: "Reserva espacios",
                  pathImageAsset: "reservaEspacios.png",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded cardNoticias() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < _pages.length; i++)
            GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 2,
                margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    i == 0
                        ? "comunicado.png"
                        : i == 1
                        ? "comunicado2.jpeg"
                        : "cm2.png",

                    fit: BoxFit.fill,
                  ),
                ),

                //anuncioEscrito(),
              ),
            ),
        ],
      ),
    );
  }

  Expanded accionesCardMOBILE({
    required String title,
    required String pathImageAsset,
    required Widget page,
  }) {
    return Expanded(
      flex: 2,

      child: GestureDetector(
        onTap:
            user != null
                ? () async {
                  Navigator.push(context, CustomPageRoute(page: page));
                }
                : null,
        child: Card(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 15),
          child: SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      color: Colors.grey.withOpacity(0.2),
                      margin: EdgeInsets.all(12),
                      elevation: 0,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          pathImageAsset,
                          color: user != null ? null : Colors.transparent,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child:
                            user != null
                                ? Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                                : Card(
                                  elevation: 0,
                                  color: Colors.grey[300],
                                  child: SizedBox(
                                    width: 80,
                                    height: 17,
                                    child: Text(""),
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child:
                      user != null
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 30,
                            ),
                          )
                          : Card(
                            margin: EdgeInsets.all(8),
                            elevation: 0,
                            color: Colors.grey[300],
                            child: SizedBox(
                              width: 45,
                              height: 17,
                              child: Text(""),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //?----------------------------------- MOBILE VIEW FIN ---------------------------------------------------------------

  //?----------------------------------- TABLET VIEW INICIO  -----------------------------------------------------------

  Scaffold homeScreenTABLET(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Padding(
      //     padding: const EdgeInsets.all(4.0),
      //     child: Padding(
      //       padding: const EdgeInsets.all(2.0),
      //       child: Image.asset("LogoTecnoVig2.png", height: 45),
      //     ),
      //   ),

      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(4.0),
      //       child: Tooltip(
      //         message: user != null ? user!.nombre : "",
      //         child: CircleAvatar(
      //           //  radius: 13,
      //           backgroundColor: Colors.grey[400],
      //           child:
      //               user != null
      //                   ? Center(
      //                     child: Text(
      //                       user!.nombre.substring(0, 2),
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                         color: Colors.grey[600],
      //                       ),
      //                     ),
      //                   )
      //                   : SizedBox.shrink(),
      //         ),
      //       ),
      //     ),
      //   ],

      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
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

                      SizedBox(height: 20,),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.home, size: 40),
                      ),
                      SizedBox(height: 20,),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person, size:  40),
                      ),
                      SizedBox(height: 20,),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.home, size: 40),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      IconButton(onPressed: () {
                        
                      }, icon: Icon(Icons.logout_rounded , color: Colors.red[300],)),
                      SizedBox(height: 20,)
                    ],
                  ),

                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Column(
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
                etiquetas(title: "Noticias"),

                SizedBox(height: 6),

                cardNoticias(),

                SizedBox(height: 4),

                Stack(
                  children: [
                    etiquetas(title: "Utilidades"),
                    botonesDeCambioNoticias(),
                  ],
                ),
                SizedBox(height: 6),

                Expanded(
                  flex: 3,

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      accionesCardMOBILE(
                        page: VisitaScreen(
                          idCorrespondencia:
                              user != null
                                  ? user!.toJson()["id"].toString()
                                  : "",
                        ),
                        title: "Visitantes",
                        pathImageAsset: "visitantes.png",
                      ),

                      accionesCardMOBILE(
                        page: CorrespondenciaScreen(
                          idCorrespondencia:
                              user != null
                                  ? user!.toJson()["id"].toString()
                                  : "",
                        ),
                        title: "Correspondencia",
                        pathImageAsset: "correspondencia.png",
                      ),

                      accionesCardMOBILE(
                        page: ReservaEspacios(idUser: user?.id),
                        title: "Reserva espacios",
                        pathImageAsset: "reservaEspacios.png",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
   
  //?----------------------------------- TABLET VIEW FIN  -----------------------------------------------------------

  //?----------------------------------- DESKTOP VIEW INICIO  -----------------------------------------------------------

  Scaffold homeScreenDESKTOP() {
    //*HOME

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          drawerHomeScreenDESKTOP(),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: PageView(
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

  Card pageViewInicioDESKTOP() {
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
          circleAvatar(pageName: "INICIO"),
          Divider(color: Colors.black54, thickness: 0.2),
          //etiqueta de Noticias
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 08),
              child: etiquetas(title: "Noticias"),
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < _pages.length; i++)
                  GestureDetector(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          i == 0
                              ? "comunicado.png"
                              : i == 1
                              ? "comunicado2.jpeg"
                              : "cm2.png",

                          fit: BoxFit.fill,
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
            child: botonesDeCambioNoticias(),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 8),
              child: etiquetas(title: "Utilidades"),
            ),
          ),

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                accionesCardImageDESKTOP(
                  imagePath: "visitantesDesktop.png",
                  label: "Visitantes",
                  onTap: () => print("Click en visitantes"),
                  isEnabled: user != null,
                  isHovering: isHoveringVisitantes,
                  onHoverChanged:
                      (value) => setState(() => isHoveringVisitantes = value),
                ),

                accionesCardImageDESKTOP(
                  imagePath: "correspondenciaDesktop.jpg",
                  label: "Correspondencia",
                  onTap: () => print("Click en Correspon"),
                  isEnabled: user != null,
                  isHovering: isHoveringCorrespondencia,
                  onHoverChanged:
                      (value) =>
                          setState(() => isHoveringCorrespondencia = value),
                ),

                accionesCardImageDESKTOP(
                  imagePath: "espacioDesktop.png",
                  label: "Reserva espacios",
                  onTap: () => print("Click en espacios"),
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

  Card pageViewPerfilDESKTOP() {
    //*HOME/PERFIL

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
          circleAvatar(pageName: "PERFIL"),
          Divider(color: Colors.black54, thickness: 0.2),

          Expanded(
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
                              child: Icon(
                                Icons.person_outline_outlined,
                                size: 35,
                              ),
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
                                validator: validatorTelefono,
                                suffixIcon:
                                    !guardando
                                        ? Icon(Icons.mode_edit_outline_outlined)
                                        : CircularProgressIndicator(
                                          padding: EdgeInsets.fromLTRB(
                                            8,
                                            4,
                                            12,
                                            4,
                                          ),
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
                                validator: validatorEmail,
                                suffixIcon:
                                    !guardando
                                        ? Icon(Icons.mode_edit_outline_outlined)
                                        : CircularProgressIndicator(
                                          padding: EdgeInsets.fromLTRB(
                                            8,
                                            4,
                                            12,
                                            4,
                                          ),
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

                              user != null &&
                                      user!.correo != correoController.text
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
        ],
      ),
    );
  }

  Card pageViewNotificacionesDESKTOP() {
    //*HOME/NOTIFICACIONES

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
          circleAvatar(pageName: "NOTIFICACIONES"),
          Divider(color: Colors.black54, thickness: 0.2),

          Expanded(
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
                                    leading: Icon(
                                      Ionicons.logo_whatsapp,
                                      size: 40,
                                    ),
                                    title: Text(
                                      "Whatsapp",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
          ),
        ],
      ),
    );
  }

  // * WIDGETS

  Widget accionesCardImageDESKTOP({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
    required bool isHovering,
    required Function(bool) onHoverChanged,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          child: GestureDetector(
            onTap: isEnabled ? onTap : null,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => onHoverChanged(true),
              onExit: (_) => onHoverChanged(false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen con zoom o shimmer si está deshabilitado
                    isEnabled
                        ? AnimatedScale(
                          scale: isHovering ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        )
                        : Container(color: Colors.grey[300])
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(duration: 800.ms),

                    // Sombra lateral
                    isEnabled
                        ? Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),

                    // Texto con fondo blur
                    isEnabled
                        ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  color: Colors.black.withOpacity(0.3),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget drawerHomeScreenDESKTOP() {
    return Drawer(
      surfaceTintColor: Colors.grey[300],
      backgroundColor: Colors.grey[300],
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 41.0),

                child: Card(
                  color: Colors.grey[300],
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset("LogoTecnoVig2.png", width: 200),
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
                  // acción para about
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
          Padding(
            padding: tilePadding,
            child: ListTile(
              onTap: () {},
              leading: Icon(Icons.logout),
              title: Text(
                'S A L I R',
                style: TextStyle(color: Colors.red[300], fontSize: 14),
              ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hoverColor: Colors.grey[200],
          onTap: onTap,
          leading: Icon(icon),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: Text(text, style: textStyle),
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldDESKTOP({
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

  Padding circleAvatar({required String pageName}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              pageName,
              style: TextStyle(
                letterSpacing: 2.5,
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user != null ? user!.nombre : "",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    user != null ? user!.espacio : "",
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
              SizedBox(width: 8),

              CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // * METHODS

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

  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo no puede estar vacío';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null; // Correo válido
  }

  String? validatorTelefono(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de teléfono no puede estar vacío';
    }

    if (value.contains(' ')) {
      return 'El número de teléfono no debe contener espacios';
    }
    String trimmedValue = value.trim();

    if (trimmedValue.length < 10) {
      return 'El número de teléfono debe tener al menos 10 dígitos';
    }
    if (trimmedValue.length > 10) {
      return 'El número de teléfono no debe tener mas de 10 dígitos';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
      return 'Solo se permiten números';
    }

    return null; // Teléfono válido
  }

  //?----------------------------------- DESKTOP VIEW FIN  -----------------------------------------------------------

  //?----------------------------------- METHOD SHARES  -----------------------------------------------------------

  Row botonesDeCambioNoticias() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _pages.length; i++)
          // Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),
          // Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),
          //   Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(
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

  Padding etiquetas({String? title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: Text(
        title!,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
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
}
