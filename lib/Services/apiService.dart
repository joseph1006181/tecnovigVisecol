import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/Usuario.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:5001/uranosssss/us-central1/widgets/buscar?cedula=100712445";

  FutureOr<Usuario> fetchUsuario(String id) async {
 

    var url = Uri.parse("http://127.0.0.1:5001/uranosssss/us-central1/widgets/buscar?cedula=$id");

    var response = await http.get(url);

    if (response.statusCode == 200) {
     
      var jsonResponse = jsonDecode(response.body);
     print(jsonResponse);
     
     return Usuario.fromJson(jsonResponse[0]);
   
    } else {
     
     return Usuario.fromJson({});
    
   
   
    }



  }
}
