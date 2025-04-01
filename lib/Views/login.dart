import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Views/homeClienteVisitante.dart';
import 'package:tecnovig/Models/Usuario.dart';
import 'package:tecnovig/Views/olvidarContrase%C3%B1a.dart';

class Loggin extends StatefulWidget {
  String? cedula;

  Loggin({super.key, required this.cedula});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  TextEditingController campoPassword = TextEditingController(text: "");

  LoginController loginController = LoginController();

  bool existencia = false;

  bool ocultarPassword = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
            child: Image.asset("logoTecnoVigLogin.png"),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  "Iniciar sesion",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              textField(
                controller: campoPassword,
                ejecucion: () {},
                label: "Digita tu contraseña",
                icono: Icons.lock,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color?>(
                        myTheme.primaryColor,
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
                      if (campoPassword.text.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });

                        await loginController.iniciarSesion(
                          context,
                          widget.cedula!,
                          campoPassword.text,
                        );

                        setState(() {
                          loading = false;
                        });
                      } else {
                        mostrarMensaje(
                          context,
                          "No puedes dejar campos vacios",
                          color: Colors.red,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:
                          loading
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Iniciar",
                                style: TextStyle(color: Colors.white),
                              ),
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      page: OlvidarContrasena(
                        cedula: int.parse(widget.cedula!),
                      ),
                    ),
                  );
                },
                child: Text(
                  "¿ Olvidaste la contraseña ?",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //*METODOS WIDGETS
  Padding appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        splashRadius: 30,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
      ),
    );
  }

  Padding textField({
    String? label,
    IconData? icono,
    Function? ejecucion,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: controller,

        cursorColor: Colors.black,
        style: TextStyle(color: Colors.grey[200]),
        obscureText: !ocultarPassword,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap:
                () => setState(() {
                  ocultarPassword = !ocultarPassword;
                }),
            child: Icon(
              ocultarPassword ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(icono, color: Colors.black54),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
