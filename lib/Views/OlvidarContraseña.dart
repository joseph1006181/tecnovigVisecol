import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';
import 'package:tecnovig/Views/RecuperarContrase%C3%B1a.dart';

class OlvidarContrasena extends StatefulWidget {
  final int cedula;
  const OlvidarContrasena({super.key, required this.cedula});

  @override
  State<OlvidarContrasena> createState() => _OlvidarContrasenaState();
}

class _OlvidarContrasenaState extends State<OlvidarContrasena> {
  bool loading = false;
  bool correoEnviado = false;
  String? codigoRecuperacion = "";
  final TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    codigoRecuperacion = generateCode();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),
      body: Column(
        children: [
          appBar(context),
          SizedBox(height: 20),
          Icon(Icons.priority_high_rounded, size: 44),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Por favor ingrese su direccion de correo electronico. le enviaremos un codigo para restablecer su contraseña",
              style: TextStyle(fontSize: 15, color: Colors.white54),
            ),
          ),

          textField(
            controller: _correoController,
            label: "Email",
            icono: Icons.email,
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
                  if (_correoController.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                    });

                    await LoginController()
                        .validarCorreo(
                          context,
                          widget.cedula,
                          _correoController.text,
                          codigoRecuperacion,
                        )
                        .whenComplete(() {
                          setState(() {
                            loading = false;
                          });
                        });

                    //Navigator.push(context, CustomPageRoute(page: RecuperarContrasena(correo: _correoController.text,)));
                  } else {
                    mostrarMensaje(
                      context,
                      "no puedes dejar el campo vacio",
                      color: Colors.orange,
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
                            "Enviar enlace de recuperacion",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding appBar(BuildContext context) {
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
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          ),
          Text(
            "Restablecer contraseña",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text("    "),
        ],
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
        enabled: !correoEnviado,
        controller: controller,

        cursorColor: Colors.black,
        style: TextStyle(color: Colors.grey[200]),
        decoration: InputDecoration(
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

  String generateCode({int length = 6}) {
    final random = Random();
    String code = '';

    for (int i = 0; i < length; i++) {
      code += random.nextInt(10).toString(); // Genera un número entre 0 y 9
    }

    return code;
  }
}
