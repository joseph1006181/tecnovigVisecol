import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertDialog.dart';
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
  State<HomeCliente> createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {
  UsuarioModel? user;

  List<String?> inicioSesionPreferences = [];

  late Timer timer;

  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  final List<Color> _pages = [Colors.red, Colors.green, Colors.blue];

  @override
  void initState() {
    consultaPreferes();
    _pageController.addListener(listener);

    _startTimer();
    super.initState();
  }

  void listener() {
    _currentPage = _pageController.page!.toInt();
    setState(() {});
  }

 


  @override
  void dispose() {


    _pageController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: drawer(context),
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

          // Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: Padding(
          //     padding: const EdgeInsets.all(2.0),
          //     child: Image.asset("LogoTecnoVigLogin.png",),
          //   ),
          // ),
        ],
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Color(0xff375CA6),  Colors.red],
        //     //  colors: [Color(0xff375CA6), Colors.purple, Colors.red],

        //       begin: Alignment.centerLeft,
        //       end: Alignment.centerRight,
        //     ),
        //   ),
        // ),
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
                accionesCard(
                  page: VisitaScreen(
                    idCorrespondencia:
                        user != null ? user!.toJson()["id"].toString() : "",
                  ),
                  title: "Visitantes",
                  pathImageAsset: "visitantes.png",
                ),

                accionesCard(
                  page: CorrespondenciaScreen(
                    idCorrespondencia:
                        user != null ? user!.toJson()["id"].toString() : "",
                  ),
                  title: "Correspondencia",
                  pathImageAsset: "correspondencia.png",
                ),

                accionesCard(
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


//*METOOS WIDGETS
  Stack drawer(BuildContext context) {
    return Stack(
      children: [
        Drawer(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              DrawerHeader(
                margin: EdgeInsets.only(bottom: 8.0),
                //     decoration: BoxDecoration(color: Color(0xff375CA6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("LogoTecnoVig2.png"),
                    SizedBox(height: 10),
                    Text(
                      user != null ? user!.nombre : "",
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
                          user != null ? user!.espacio : "",
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

                    fit: BoxFit.cover,
                  ),
                ),

                //anuncioEscrito(),
              ),
            ),
        ],
      ),
    );
  }

  Expanded accionesCard({
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

  Padding etiquetas({String? title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: Text(
        title!,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

// gridview no en uso
  GridView gridVi() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, //  columnas
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1, // Proporción 1:1 (cuadrado)
      ),
      itemCount: 3, // 2 filas * 2 columnas = 4 elementos
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //Navigator.push(context, CustomPageRoute(page: Vistantes()));

            switch (index) {
              case 0:
                Navigator.push(context, CustomPageRoute(page: VisitaScreen()));
                break;

              case 1:
                break;

              case 2:
                Navigator.push(context, CustomPageRoute(page: EspacioScreen()));

                break;

              default:
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Center(
              child:
                  user == null
                      ? SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.all(25),
                          color: Colors.grey[300],
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            index == 0
                                ? Center(child: Image.asset("visitantes.png"))
                                : index == 1
                                ? Center(
                                  child: Image.asset(
                                    height:
                                        0.18 *
                                        MediaQuery.of(context).size.height,
                                    "correspondencia.png",
                                  ),
                                )
                                : index == 2
                                ? Center(
                                  child: Image.asset(
                                    height:
                                        0.18 *
                                        MediaQuery.of(context).size.height,
                                    "reservaEspacios.png",
                                  ),
                                )
                                : Center(
                                  child: Image.asset(
                                    height:
                                        0.16 *
                                        MediaQuery.of(context).size.height,
                                    "pagoAdmin.png",
                                  ),
                                ),
                            //  index == 0 ?
                            //  "visitantes.png" :
                            // index ==  1 ?
                            //  "correspondencia.png" :
                            // index ==  2 ?

                            //  "reservaEspacios.png" :

                            //  "Adminstracion"
                            // ,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 0, color: Colors.black54),
                                SizedBox(height: 6),
                                Text(
                                  index == 0
                                      ? "Visitantes "
                                      : index == 1
                                      ? "Correspondencia"
                                      : index == 2
                                      ? "Reserva espacios"
                                      : "Adminstracion",

                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  ListTile anuncioEscrito() {
    return ListTile(
      onTap: () {
        // crearCahce();
        setState(() {});
      },
      title:
          user == null
              ? Card(
                margin: EdgeInsets.only(top: 8, right: 120),
                color: Colors.grey[300],
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(""),
                ),
              )
              : Text("! ATENCION ¡"),
      subtitle:
          user == null
              ? Column(
                children: [
                  for (int i = 0; i < 2; i++)
                    SizedBox(
                      width: double.maxFinite,
                      child: Card(
                        margin: EdgeInsets.only(top: 8),
                        color: Colors.grey[300],
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(""),
                        ),
                      ),
                    ),
                ],
              )
              : Text(
                "dcdcscsdcdssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscdcsssssssddddddddddddddddddddddddddddddddddddssssssssssssssssssssssssssssssssss",
                style: TextStyle(color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
    );
  }



//* METODOS LOGICOS

  void consultaPreferes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = await UsuarioController().consultaUsuario(
      prefs.getStringList("listInfoUser")![3],
    );

    setState(() {});
  }
}
