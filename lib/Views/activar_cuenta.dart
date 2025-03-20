import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/generar_contrasenas.dart';
import 'package:tecnovig/Utilities/mitheme.dart';
import 'package:tecnovig/Views/login.dart';

class ActivarCuenta extends StatefulWidget {
  final String? cedula;
  final String? nombre;
  final String? correo;

  const ActivarCuenta({
    super.key,
    required this.cedula,
    this.nombre,
    this.correo,
  });

  @override
  State<ActivarCuenta> createState() => _ActivarCuentaState();
}

class _ActivarCuentaState extends State<ActivarCuenta> {

  bool loading = false;
  bool activacion = false;


  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),
      body: Column(
        children: [
          Padding(
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
                  "Activacion de cuenta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("    "),
              ],
            ),
          ),

          activacion
              ? ListTile(
                title: Text(
                  "Activacion exitosa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  "Tu  cuenta ya está lista . \n Se han enviado tus credenciales de acceso al correo ${ocultarCorreo(widget.correo!)}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
              : ListTile(
                title: Text(
                  "¡Activa tu cuenta ahora! ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  "Tu cuenta está casi lista. Solo falta un paso para comenzar a disfrutar de nuestros servicios. Presiona el botón a continuación para activar tu cuenta y acceder a todas las funcionalidades.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

          activacion
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  elevatedButtom("Inicia sesion", () {
                    Navigator.pushReplacement(
                      context,
                      CustomPageRoute(page: Loggin(cedula: widget.cedula!)),
                    );
                  }),

                  ListTile(
                    title: Text(
                      "   📩 ¿No recibiste el correo?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });

                          dynamic resul = await LoginController().activarCuenta(
                            context,
                        
                            int.parse(widget.cedula!),
                            widget.nombre!,
                            widget.correo!,
                          );

                          if (resul == "200") {
                            setState(() {
                              loading = false;
                            });
                            mostrarMensaje(
                              context,
                              "Mensaje reenviado con exito",
                              color: Colors.green,
                            );
                          } else {
                            setState(() {
                              loading = false;
                            });

                            mostrarMensaje(
                              context,
                              "Ocurrio un error en la consulta",
                              color: Colors.red,
                            );
                          }
                        },
                        child: Text(
                          " Revisa tu bandeja de spam o haz clic aquí para reenviar el mensaje.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : elevatedButtom("Activar", () async {
                setState(() {
                  loading = true;
                });

                dynamic resul = await LoginController().activarCuenta(
                  context,
           
                  int.parse(widget.cedula!),
                  widget.nombre!,
                  widget.correo!,
                );

                if (resul == "200") {
                  setState(() {
                    activacion = true;
                    loading = false;
                  });
                } else {
                  setState(() {
                    loading = false;
                  });

                  mostrarMensaje(
                    context,
                    "Ocurrio un error en la consulta",
                    color: Colors.red,
                  );
                }
              }),
        ],
      ),
    );
  }

  Padding elevatedButtom(String? text, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color?>(
              myTheme.primaryColor,
            ),
            shape: WidgetStatePropertyAll<OutlinedBorder?>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Borde redondeado
                //  side: BorderSide(color: Colors.red, width: 2), // Color y grosor del borde
              ),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                loading
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : Text(text!, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  String ocultarCorreo(String correo) {
    List<String> partes = correo.split('@');
    if (partes.length != 2) return correo; // Validación básica

    String usuario = partes[0];
    String dominio = partes[1];

    // Dejar visibles las primeras dos letras y ocultar el resto con '*'
    String usuarioOculto =
        usuario.length > 2
            ? usuario.substring(0, 2) + '*' * (usuario.length - 2)
            : usuario;

    return '$usuarioOculto@$dominio';
  }
}
