import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/variables.dart';
import 'package:tecnovig/Views/homeClienteVisitante.dart';
import 'package:tecnovig/Views/login.dart';

class LoginController {



 ensayoPeticion() async {
 
 

    try {
      
       var url = Uri.parse(
  "http://localhost/dashboard/bd_ensayo/api_login.php?cedula=100712445"
       );


      var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "application/json",// Asegura que se envía como JSON
      // },
       // body: jsonEncode(datos),
    );

      if (response.statusCode == 200) {
   
    // var data = jsonDecode(response.body);
       

       print(response.body);
      
     
  // print("respuesta exirtosa del seervidor "+data[3]["descripcion"]);
     
     
      }  
      
     
     if (response.statusCode == 500) {
      }
   
    if (response.statusCode == 400) {
      }
   
    } catch (e) {
    print(e);
    }






    }




















  Future<List<String?>> verificarSesion() async {
    
   SharedPreferences prefs = await SharedPreferences.getInstance();
  
    //return prefs.getString('nombre') ?? "noIniciado";


  return prefs.getStringList("listInfoUser") ?? [];
    

  }


 iniciarSesion(BuildContext context , String cedula, String password) async {
 
 if (cedula.isEmpty || password.isEmpty) {
 
   mostrarMensaje(context," no puede dejar los campos vacios");
  
    }else{

    try {
    
       var url = Uri.parse(
    //  "${LOGIN_URL}${cedula}"
 // "${LOGIN_URL_PRODUCCION}${cedula}"
  "https://clientes.tecnovig.com/consultas/api_login.php?cedula=${cedula}"
 ""
  //    "http://127.0.0.1:5001/uranosssss/us-central1/widgets/buscar?cedula=$cedula",
       );


      var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "application/json",// Asegura que se envía como JSON
      // },
       // body: jsonEncode(datos),
    );

      if (response.statusCode == 200) {
   
      var data = jsonDecode(response.body);
       

       

       await _guardarSesion(data[0]);
     
      Navigator.pushReplacement(context, CustomPageRoute(page: HomeCliente()));
   print("respuesta exitosa del seervidor ");
     
     
      }  
      
     
     if (response.statusCode == 500) {
      mostrarMensaje(context, "Credenciales incorrectas" , color: Colors.red);
      }
   
    if (response.statusCode == 400) {
      mostrarMensaje(context, "No hay conexion a la base " , color: Colors.red);
      }
   
    } catch (e) {
    print(e);
      mostrarMensaje(context, "Error de conexión"+e.toString());
    }






    }
 }




  Future<void> _guardarSesion(dynamic infoUserMap) async {
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


  List<String> listInfoUser =
   [
   infoUserMap["id"].toString(),
   infoUserMap["espacio"],
   infoUserMap["nombre"],
   infoUserMap["cedula"],
   infoUserMap["correo"],
  ];
   
    await prefs.setStringList("listInfoUser", listInfoUser);
  

  //  await prefs.setString("nombre", nombreUsuario);
  }

 
 
  Future<void> cerrarSesion(BuildContext context ,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // await prefs.setString("token", token);
    //await prefs.setString("usuario", jsonEncode(usuario));

    await prefs.clear();
     
     Navigator.pushReplacement(context, CustomPageRoute(
      page: Loggin()
      
      , ));
  }
  
}