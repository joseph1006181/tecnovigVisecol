import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/Usuario.dart';
import 'package:tecnovig/Utilities/variables.dart';
import 'package:tecnovig/Views/login.dart';

class Usuariocontroller {
  

  
  
  
  Future<Usuario?> consultaUsuario(String idUser)async{


    try {
       
       var url = Uri.parse(
   //  LOGIN_URL_PRODUCCION,
   // LOGIN_URL+idUser    
  // "https://clientes.tecnovig.com/consultas/api_login.php?cedula=${cedula}"
   "https://clientes.tecnovig.com/consultas/api_login.php?cedula=$idUser" 
       );


      var response = await http.get(url,);

      if (response.statusCode == 200) {
   
        var data = jsonDecode(response.body);
       
       

            // try {
            //    print(Usuario.fromJson(data[0]));
            // } catch (e) {
            //    print(e);
              
            // }

      
          return Usuario.fromJson(data[0]);
     
      
     

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














}