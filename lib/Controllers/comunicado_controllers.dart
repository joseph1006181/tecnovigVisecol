import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/comunicado_model.dart';
import 'package:tecnovig/Models/espacio_model.dart';


class ComunicadoControllers {
  //* LISTA DE METODOS      [1]

  //* Future<dynamic> consultaCorrespondencia(String idResidenteCorrespondencia,)

  Future<dynamic> consultaComunicados(
  ) async {
    //* con este metodo consultaremos la correspondencia de cada cliente

    var url = Uri.parse(
      "https://clientes.tecnovig.com/api/comunicados/consulta_comunicados.php",
    );

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        //print("status 200"); //         ✅// datos tipo json

        var data = jsonDecode(response.body);
        if (data.length > 0) {
          // validamos que la consulta traiga datos
          List<Comunicado> listComunicados =
              []; // si hay datos los convertimos a lista tipo visistas

          for (var i = 0; i < data["data"].length; i++) {
            listComunicados.add(Comunicado.fromJson(data["data"][i]));
          }


          return listComunicados;
       
       
        } else {
          // si no nos devolvio datos , devolvemos una respuesta de lista vacia

            return response.body;
        }
      }

      if (response.statusCode != 200) {
        //❌ STATUS 500 : si ocurre un error en la consulta , devolvemos un null
        //print("STATUS 500, Error en la consulta");

        return response.body;
      }

     
    } catch (e) {


      //❌ si ocurre un error en la ejecucion del codigo

      return { 
            "status" : "error",
            "message": "Error inesperado$e",
            "data" :""} ;
    }
  }
}
  