import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';

import 'package:tecnovig/Views/desktop/valida_user_desktop.dart';
import 'package:tecnovig/Views/home_cliente_screen.dart';
import 'package:tecnovig/Views/login_screen.dart';
import 'package:tecnovig/main.dart';

class LoginController {
  //* LISTA DE METODOS      [6]

  //* Future<dynamic>         validarExistencia(int cedula, BuildContext context)
  //* Future<List<String?>>   verificarSesion()
  //* Future<dynamic>?        activarCuenta( context,String newPassword, int cedula, String nombre, String correo,)
  //* void                    iniciarSesion(BuildContext context, String cedula, String password)
  //* Future<void>            _guardarSesion(dynamic infoUserMap)
  //* Future<void>            cerrarSesion(BuildContext context)
  //* Future<dynamic>         validarCorreo(context,cedula,correo,codigoRecuperacion)
  //* Future<Usuario?>         recuperarPassword(context,int cedula,String newpassword, )

  Future<dynamic>? activarCuenta(
    BuildContext context,
    int cedula,
    String nombre,
    String correo,
  ) async {
    //*  con este metodo activaremos la cuenta por primera vez a los usuarios registrados que no posean password

    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/auth/api_activar_user.php",
    );

    try {
      var response = await http.post(
        url,
        body: jsonEncode({
          "cedula": cedula,
          "correo": correo,
          "nombre": nombre,
        }),
      );

      if (response.statusCode == 200) {
        return "200";
      } else {
        // si no nos devolvio datos , devolvemos una respuesta de lista vacia

        return "400";
      }
    } catch (e) {
      //❌ si ocurre un error en la ejecucion del codigo
      //print(e);

      return "400";
    }
  }

  Future<UsuarioModel?> recuperarPassword(
    BuildContext context,
    int cedula,
    String newpassword,
  ) async {
    //* este metodo lo usaremos para restablecer la contraseña haciendo un update a la base de datos

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/auth/api_recuperar_password.php",
      );

      var response = await http.post(
        url,
        body: jsonEncode({"cedula": cedula, "newPassword": newpassword}),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["update"].toString() == "ok") {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            CustomPageRoute(page: LoginScreen()),
          );
          mostrarMensaje(
            context,
            "Contraseña restablecida con exito ",
            color: Colors.green,
          );
        } else {}
      }

      if (response.statusCode == 500) {
        if (context.mounted) {
          mostrarMensaje(context, "Error ", color: Colors.red);
        }
      }

      if (response.statusCode == 400) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "No hay conexion a la base ",
            color: Colors.red,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        mostrarMensaje(context, "Error de conexión");
      }
    }

    return null;
  }

  Future<dynamic> recuperarPasswordNewMethod(
    BuildContext context,
    int cedula,
    String newpassword,
  ) async {
    //* este metodo lo usaremos para restablecer la contraseña haciendo un update a la base de datos

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/auth/api_recuperar_password.php",
      );

      var response = await http.post(
        url,
        body: jsonEncode({"cedula": cedula, "newPassword": newpassword}),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["update"].toString() == "ok") {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "Contraseña restablecida con exito ",
            color: Colors.green,
          );
        }

        return "200";
      }

      if (response.statusCode == 500) {
        if (context.mounted) {
          mostrarMensaje(context, "Error ", color: Colors.red);
        }
        return "500";
      }

      if (response.statusCode == 400) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "No hay conexion a la base ",
            color: Colors.red,
          );
        }

        return "400";
      }
    } catch (e) {
      if (context.mounted) {
        mostrarMensaje(context, "Error de conexión");
      }

      return "400";
    }

    return null;
  }

 
  Future<String?> validarCorreoNewMethod(
    BuildContext context,
    int cedula,
    String? correo,
    String? codigoRecuperacion,
  ) async {
    //* Método para validar si un correo está asociado a una cédula en la base de datos.
    //* Si es válido, se enviará un código de recuperación.

    final url = Uri.parse(
      "https://clientes.tecnovig.com/api/auth/validar_correo.php",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "cedula": cedula,
          "correo": correo,
          "codigo": codigoRecuperacion,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        //* Si la respuesta contiene "null", significa que el correo no está relacionado con la cédula
        if (data["Result"] == "null") {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "El correo ingresado no coincide con este usuario",
              color: Colors.orange,
            );
          }
          return null;
        }

        return "ok"; //* Correo válido
      }

      //* Manejo de errores según el código de respuesta
      final errorMessages = {
        500: "Ocurrió un error en la consulta",
        400: "Ocurrió un error inesperado",
      };

      if (errorMessages.containsKey(response.statusCode) && context.mounted) {
        mostrarMensaje(
          context,
          errorMessages[response.statusCode]!,
          color: Colors.red,
        );
        return response.statusCode.toString();
      }
    } catch (e) {
      if (context.mounted) {
        mostrarMensaje(
          context,
          "Ocurrió un error inesperado",
          color: Colors.red,
        );
      }
      return "400";
    }

    return null; //* Caso no esperado
  }

  Future<dynamic> validarCorreoDesktop(
    BuildContext context,
    int cedula,
    String? correo,
    String? codigoRecuperacion,
  ) async {
    //* este metodo es usado por la vista "OlvidarContraseña" para validar si un correo esta relacionado con el numero de cedula en la base de datos y si es asi se enviara un codigo de recuperacion al correo ingresado

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/auth/validar_correo.php",
      );

      var response = await http.post(
        url,
        // headers: {  "Content-Type": "application/json",  // Asegura que se envía como JSON },
        body: jsonEncode({
          "cedula": cedula,
          "correo": correo,
          "codigo": codigoRecuperacion,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //* si la respuest result nos trae null es por que no hay ningun dato asociado a esa cedula
        if (data["Result"] != "null") {
          return "ok";
        } else {
          //* si la condicion es false  , es por que  el correo no esta relacionado a esta cedula
          if (context.mounted) {
            mostrarMensaje(
              context,
              "El correo ingresado  no coincide con este usuario",
              color: Colors.orange,
            );
          }

          return null;
        }
      }

      //* si la respuesta es 500 quiere decir que en la consulta hubo un error
      if (response.statusCode == 500) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "Ocurrio un error en la consulta",
            color: Colors.red,
          );
        }

        return "500";
      }

      //* si la respuesta es 400 quiere decir que en la conexion u otro evento hubo un error
      if (response.statusCode == 400) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "Ocurrio un error inesperado",
            color: Colors.red,
          );
        }

        return "400";
      }
    } catch (e) {
      if (context.mounted) {
        //log(e.toString(), error: e);
        mostrarMensaje(
          context,
          "Ocurrio un error inesperado",
          color: Colors.red,
        );
      }

      return "400";
    }
  }

 

  Future<dynamic> validarExistenciaNewMethod(
    int cedula,
    BuildContext context,
  ) async {
    //* con este metodo validaremos la existencia del usuario en la base de datos y si el usuario existe pero no tiene una contraseña asigana se le enviara a una view ActivarCuenta para que se cree una contraseña nuevo , si el usuario ya tiene una creada , se pasara a la View Loggin para que iniice sesion

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/auth/api_validarExistencia.php",
      );

      var response = await http.post(
        url,
        // headers: {  "Content-Type": "application/json",  // Asegura que se envía como JSON },
        body: jsonEncode({"cedula": cedula}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        //* si la respuest result nos trae null es por que no hay ningun dato asociado a esa cedula
        if (data["Result"] != "null") {
          if (UsuarioModel.fromJson(data["Result"]).password.isEmpty) {
            return {
              "activarCuenta": "activarCuenta",
              "user": UsuarioModel.fromJson(data["Result"]),
            };
          } else {
            return {
              "loggin": "loggin",
              "user": UsuarioModel.fromJson(data["Result"]),
            };
          }
        } else {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "El usuario con el numero de cedula ingresado no  existe",
              color: Colors.grey[800],
            );
          }

          return null;
        }
      }

      if (response.statusCode == 500) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "Ocurrio un error status : 500",
            color: Colors.red,
          );
        }
        return "500";
      }

      if (response.statusCode == 400) {
        if (context.mounted) {
          mostrarMensaje(
            context,
            "Ocurrio un error status : 400",
            color: Colors.red,
          );
        }
        return "400";
      }
    } catch (e) {
      if (context.mounted) {
        mostrarMensaje(
          context,
          "Ocurrio un error status : 400",
          color: Colors.red,
        );
      }
      return "400";
    }
  }

  Future<dynamic> validarExistenciaDesktop(
    int cedula,
    BuildContext context,
  ) async {
    //* con este metodo validaremos la existencia del usuario en la base de datos y si el usuario existe pero no tiene una contraseña asigana se le enviara a una view ActivarCuenta para que se cree una contraseña nuevo , si el usuario ya tiene una creada , se pasara a la View Loggin para que iniice sesion

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/auth/api_validarExistencia.php",
      );

      var response = await http.post(
        url,
        // headers: {  "Content-Type": "application/json",  // Asegura que se envía como JSON },
        body: jsonEncode({"cedula": cedula}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        //* si la respuest result nos trae null es por que no hay ningun dato asociado a esa cedula
        if (data["Result"] != "null") {
          if (UsuarioModel.fromJson(data["Result"]).password.isEmpty) {
            // Navigator.push(
            //   context,
            //   CustomPageRoute(
            //     page: ActivarCuenta(
            //       cedula: data["Result"]["cedula"],
            //       correo: data["Result"]["correo"],
            //       nombre: data["Result"]["nombre"],
            //     ),
            //   ),
            // );

            //   return "activarCuenta";

            return {
              "activarCuenta": "activarCuenta",
              "user": UsuarioModel.fromJson(data["Result"]),
            };
          } else {
            // if (context.mounted) {
            //   Navigator.push(
            //     context,
            //     CustomPageRoute(page: Loggin(cedula: data["Result"]["cedula"])),
            //   );
            // }

            return {
              "loggin": "loggin",
              "user": UsuarioModel.fromJson(data["Result"]),
            };
          }
        } else {
          mostrarMensaje(
            context,
            "El usuario con el numero de cedula ingresado no  existe",
            color: Colors.orange,
          );

          return null;
        }
      }

      if (response.statusCode == 500) {
        mostrarMensaje(
          context,
          "Ocurrio un error status : 500",
          color: Colors.red,
        );
        return null;
      }

      if (response.statusCode == 400) {
        mostrarMensaje(
          context,
          "Ocurrio un error status : 400",
          color: Colors.red,
        );
        return null;
      }
    } catch (e) {
      mostrarMensaje(
        context,
        "Ocurrio un error status : 400",
        color: Colors.red,
      );
      return null;
    }
  }

  Future<List<String?>> verificarSesion() async {
    //* con este metodo validaremos el inicio de sesion si el usuario tiene o no la cuenta guardada en el navegador para asi pasar derectamente al homeViewClientes
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //return prefs.getString('nombre') ?? "noIniciado";

    return prefs.getStringList("listInfoUser") ?? [];
  }

  iniciarSesion(BuildContext context, String cedula, String password) async {
    //* con este metodo iniciaremos la sesion

    if (cedula.isEmpty || password.isEmpty) {
      mostrarMensaje(context, " no puede dejar los campos vacios");
    } else {
      try {
        var url = Uri.parse(
          "https://clientes.tecnovig.com/api/auth/api_login.php",
        );

        var response = await http.post(
          url,
          body: jsonEncode({"cedula": cedula, "Password": password}),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          await _guardarSesion(data[0]);

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              CustomPageRoute(
                page: HomeCliente(),
             
              ),
            );
            // //print("respuesta exitosa del seervidor ");
            //log("iniciado");
          }
        }

        if (response.statusCode == 500) {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "Credenciales incorrectas",
              color: Colors.red,
            );
          }
        }

        if (response.statusCode == 400) {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "No hay conexion a la base ",
              color: Colors.red,
            );
          }
        }
      } catch (e) {
        //log("Error", error: e);

        if (context.mounted) {
          mostrarMensaje(context, "Error de conexión$e");
        }
      }
    }
  }

  Future<dynamic> iniciarSesionDesktop(
    BuildContext context,
    String cedula,
    String password,
  ) async {
    //* con este metodo iniciaremos la sesion

    if (cedula.isEmpty || password.isEmpty) {
      mostrarMensaje(context, " no puede dejar los campos vacios");
    } else {
      try {
        var url = Uri.parse(
          "https://clientes.tecnovig.com/api/auth/api_login.php",
        );

        var response = await http.post(
          url,
          body: jsonEncode({"cedula": cedula, "Password": password}),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          await _guardarSesion(data[0]);

          if (context.mounted) {
            Navigator.push(
              context,
              CustomPageRoute(
                page: HomeCliente(),
              ),
            );
            // //print("respuesta exitosa del seervidor ");
            //log("iniciado");
          }
        }

        if (response.statusCode == 500) {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "Credenciales incorrectas",
              color: Colors.red,
            );
          }
        }

        if (response.statusCode == 400) {
          if (context.mounted) {
            mostrarMensaje(
              context,
              "No hay conexion a la base ",
              color: Colors.red,
            );
          }
        }
      } catch (e) {
        //log("Error", error: e);

        if (context.mounted) {
          mostrarMensaje(context, "Error de conexión$e");
        }
      }
    }
  }

  Future<void> _guardarSesion(dynamic infoUserMap) async {
    //* este metodo guardara la sesion del usuario , y este metodo solo se usara en esta clase , por eso esta protegido
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //         {
    // >      id: 1,
    // >      fecha_creacion: 2024-07-24T11:16:57.000Z,
    // >      espacio: 'TORRE 12 APTO 404',
    // >      nombre: 'Marco antonio fernandez zapata',
    // >      cedula: '100712445',
    // >      telefono: '3023433961',
    // >      correo: 'marcoferzap@gmail.com',
    // >      cliente: 6,
    // >      estado: '1',
    // >      usuario: 0,
    // >      area: 1,
    // >      tipo: 1,
    // >      salida_peatonal: 1,
    // >      vehiculo_habilitado: 1,
    // >      password: ''
    // >    }
    // await _guardarSesion(data[0]["nombre"].toString());

    List<String> listInfoUser = [
      infoUserMap["id"].toString(),
      infoUserMap["espacio"],
      infoUserMap["nombre"],
      infoUserMap["cedula"],
      infoUserMap["correo"],
    ];

    await prefs.setStringList("listInfoUser", listInfoUser);
  }

  Future<void> cerrarSesion(BuildContext context) async {
    //* este metodo es para cerrar la sesion y borrar los datos de las cookies
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString("token", token);
    // await prefs.setString("usuario", jsonEncode(usuario));

    await prefs.clear();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        CustomPageRoute(page: MyApp()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
