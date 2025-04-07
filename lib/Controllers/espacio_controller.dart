import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/espacio_model.dart';


class EspacioController {
  //* LISTA DE METODOS      [1]

  //* Future<dynamic> consultaCorrespondencia(String idResidenteCorrespondencia,)

  Future<dynamic> consultaEspacios(
  ) async {
    //* con este metodo consultaremos la correspondencia de cada cliente

    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/espacios/consulta_espacios.php",
    );

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        //print("status 200"); //         ✅// datos tipo json

        var data = jsonDecode(response.body);
          
        if (data.length > 0) {
          // validamos que la consulta traiga datos

          List<EspacioModel> listEspacios =
              []; // si hay datos los convertimos a lista tipo visistas

          for (var i = 0; i < data.length; i++) {
            listEspacios.add(EspacioModel.fromJson(data[i]));
          }

          return listEspacios;
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
}
  