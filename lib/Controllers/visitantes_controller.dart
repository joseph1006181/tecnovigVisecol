 
  import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Models/Usuario.dart';
import 'package:tecnovig/Models/Visitantes_registro.dart';
import 'package:tecnovig/Utilities/variables.dart';

class VisitantesController {
  



// metodo para consultar a todos los visitantes del cliente id?

Future<dynamic> consultaVisita(String idResidenteVisitado )async{

// usabamos esa variabale para convertir una fecha toIso8601String  a la fecha para  buscar en la base de datos
//         |
//         v
//String fechaConsult = fechaConsulta.toLocal().toString().substring(0,10);
      

  
  
  
       
   var url = Uri.parse(
"https://clientes.tecnovig.com/consultas/api_visitantes.php?idResidenteVisitado=$idResidenteVisitado"

 // "https://widgets-z3fldjynra-uc.a.run.app/buscarVisita?idResidenteVisitado=$idResidenteVisitado" 

 //"http://localhost/dashboard/bd_ensayo/api_visitantes.php?idResidenteVisitado=$idResidenteVisitado"
   // Visita_URL,
  //    Visita_URL_PRODUCCION
       );

try {

      var response = await http.get(url,);

      if (response.statusCode == 200) {
         
          print("status 200");//         ✅// datos tipo json 
       
      var data = jsonDecode(response.body);
       
       
 
     if (data.length > 0) { // validamos que la consulta traiga datos
    
   
     List<Visita> listVisitas = []; // si hay datos los convertimos a lista tipo visistas    


     for (var i = 0; i < data.length ; i++) {
       
     listVisitas.add(Visita.fromJson(data[i]));

     }


      return listVisitas;
        

     } else {  // si no nos devolvio datos , devolvemos una respuesta de lista vacia
   
         return  null;

     }
  }  
      
     
     if (response.statusCode == 500) {   //❌ STATUS 500 : si ocurre un error en la consulta , devolvemos un null 
          print("STATUS 500, Error en la consulta"); 
          return "STATUS 500";
      }
   
    if (response.statusCode == 400) {    //❌ STATUS 400 : si ocurre un error en la conexion 
         print("status 400");         

          return "STATUS 400";
      }
   
    } catch (e) {  //❌ si ocurre un error en la ejecucion del codigo 
        print(e);

        return "STATUS 500";
      
    }

  }





}