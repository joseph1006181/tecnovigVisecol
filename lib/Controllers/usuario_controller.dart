import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/Widgets/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';

class UsuarioController {


              //* LISTA DE METODOS      [2]



//*  Future<Usuario?> consultaUsuario(String idUser) 
//*  Future<dynamic>? autorizarNotificaciones(int autorizacion,int id, String notificacion,) 




  Future<dynamic>? actualizarTelefono(BuildContext context,
    int cedula,
    String value,
    String valueCorreo,

  ) async {
//* con este metodo autorizaremos las notificaciones via whatsapp y correo electronico
  
    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/users/api_actualizarTelefono.php",
    );

    try {
      var response = await http.post(
        url,
        body: jsonEncode({
          "cedula": cedula,
          "telefono": value,
          "correo": valueCorreo,

        }),
        );

      if (response.statusCode == 200) {
     var data = jsonDecode(response.body);
   print(data);
         mostrarMensaje(context, "Actualizacion exitosa  ✅", color: Colors.green);
        return "200";


      } else {
        // si no nos devolvio datos , devolvemos una respuesta de lista vacia

        mostrarMensaje(context, "Ocurrio  un error al actualizar", color: Colors.red);
        return "400";
      }
    } catch (e) {
      //❌ si ocurre un error en la ejecucion del codigo
      print(e);
        mostrarMensaje(context, "Ocurrio  un error al actualizar", color: Colors.red);

      return "400";
    }
  }







  Future<UsuarioModel?> consultaUsuario(String idUser) async {

  //* con este metodo consultamos los datos del usuario y lo usamos en la View HomeClienteVisitantes

    try {
      var url = Uri.parse(
        "https://clientes.tecnovig.com/api/users/api_consulta_user.php",
      );

      var response = await http.post(url, body: jsonEncode({"cedula": idUser}));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        return UsuarioModel.fromJson(data[0]);
      }

      if (response.statusCode == 500) {
        //mostrarMensaje(context, "Credenciales incorrectas" , color: Colors.red);
      }

      if (response.statusCode == 400) {
        //mostrarMensaje(context, "No hay conexion a la base " , color: Colors.red);
      }
    } catch (e) {
      //  mostrarMensaje(context, "Error de conexión");
    }

    return null;
  }

  Future<dynamic>? autorizarNotificaciones(
    int autorizacion,
    int id,
    String notificacion,
  ) async {
//* con este metodo autorizaremos las notificaciones via whatsapp y correo electronico
  
    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/users/api_actualizarNotificaciones.php?autorizacion=$autorizacion&id=$id&notificacion=$notificacion",
    );

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
       // var data = jsonDecode(response.body);


        return "200";
      } else {
        // si no nos devolvio datos , devolvemos una respuesta de lista vacia

        return "400";
      }
    } catch (e) {
      //❌ si ocurre un error en la ejecucion del codigo
      print(e);

      return "400";
    }
  }



  
}
