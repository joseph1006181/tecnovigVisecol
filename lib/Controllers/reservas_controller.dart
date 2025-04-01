import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/Espacio.dart';
import 'package:tecnovig/Models/Reservas_espacios.dart';
import 'package:tecnovig/Models/correspondencia.dart';

class ReservasController {
  //* LISTA DE METODOS      [1]

  //* Future<dynamic> consultaReservas(String idConsulta,)

  Future<dynamic> consultaReservas({required int? idConsulta}) async {
    //* con este metodo consultaremos la correspondencia de cada cliente

    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/espacios/consulta_reservas.php?id=$idConsulta",
    );

    try {
      var response = await http.post(url);

      if (response.statusCode == 200) {
        //print("status 200"); //         ✅// datos tipo json

        var data = jsonDecode(response.body);

        if (data.length > 0) {
          // validamos que la consulta traiga datos

          List<Reserva> listReservas =
              []; // si hay datos los convertimos a lista tipo visistas

          for (var i = 0; i < data.length; i++) {
            listReservas.add(Reserva.fromJson(data[i]));
          }

          return listReservas;
        } else {
          // si no nos devolvio datos , devolvemos una respuesta de lista vacia

          return null;
        }
      }

      if (response.statusCode == 500) {
        //❌ STATUS 500 : si ocurre un error en la consulta , devolvemos un null
        //print("STATUS 500, Error en la consulta");

        return null;
      }

      if (response.statusCode == 400) {
        //❌ STATUS 400 : si ocurre un error en la conexion
        //print("status 400");
        return "STATUS 400";
      }
    } catch (e) {
      //❌ si ocurre un error en la ejecucion del codigo
      print(e);

      return "STATUS 500";
    }
  }

  Future<dynamic> crearReservaDeEspacio(
    Map<String, dynamic> datosReservas,
  ) async {
    // URL de tu API
    final String url =
        'https://clientes.tecnovig.com/api/espacios/crearReserva.php';

    // // // Datos a enviar en el body
    //  Map<String, dynamic> datosReserva = {
    //    "fecha": "2025/03/11",
    //    "espacio": 3,
    //    "residente": 1,
    //    "hora_inicio": "07:00",
    //    "hora_fin": "10:00",
    //    "observaciones": "Reserva para evento especial"
    //  };

    try {
      // Realizar la solicitud POST
      final respuesta = await http.post(
        Uri.parse(url),

        body: jsonEncode(datosReservas),
      );

      var data = jsonDecode(respuesta.body);

      // Verificar el estado de la respuesta
      if (respuesta.statusCode == 201) {
        print("✅ Reserva enviada con éxito: ${respuesta.body}");

        return data;
      } else {
        print("⚠️ Error en la reserva: ${respuesta.statusCode}");

        return data;
      }
    } catch (e) {
      print("❌ Error en la solicitud: $e");

      return jsonEncode({
        "status": "error",
        "mensaje": "Ocurrio un error inesperado  en la peticion ",
      });
    }
  }

  Future<dynamic> eliminarReserva(dynamic idReserva) async {
    // URL de tu API
    final String url =
        'https://clientes.tecnovig.com/api/espacios/eliminarReserva.php';

    // // // Datos a enviar en el body
    Map<String, dynamic> datosReserva = {"idReserva": idReserva};

    try {
      // Realizar la solicitud POST
      final respuesta = await http.post(
        Uri.parse(url),

        body: jsonEncode(datosReserva),
      );

      var data = jsonDecode(respuesta.body);

      // Verificar el estado de la respuesta
      if (respuesta.statusCode == 200) {
        print("✅ Reserva enviada con éxito: ${respuesta.body}");

        return data;
      } else {
        print("⚠️ Error en la reserva: ${respuesta.statusCode}");

        return data;
      }
    } catch (e) {
      print("❌ Error en la solicitud: $e");

      return jsonEncode({
        "status": "error",
        "mensaje": "Ocurrio un error inesperado  en la peticion ",
      });
    }
  }
}
