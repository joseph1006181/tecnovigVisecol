import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tecnovig/Controllers/correspondencia_controller.dart';
import 'package:tecnovig/Models/Correspondencia.dart';
import 'package:tecnovig/Utilities/obtener_fecha_a_letras.dart';
import 'package:url_launcher/url_launcher.dart';


class Correspondencia extends StatefulWidget {
  const Correspondencia({super.key});

  @override
  State<Correspondencia> createState() => _CorrespondenciaState();
}

class _CorrespondenciaState extends State<Correspondencia> {
  
  DateTime? selectedDate = DateTime.now();
  
  String? fechaFiltro = "";
  
  TextEditingController editingController = TextEditingController();

  List<CorrespondenciaModel> correspondenciaList = [];

  List<CorrespondenciaModel> correspondenciaListBusqueda = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  icon: Icon(Icons.arrow_back_ios_rounded),
                ),
                Text(
                  "Correspondencia",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ],
            ),
          ),

          barraBusqueda(),
         

          FutureBuilder<dynamic>(
          
            future: consultaCorrespondencia(),

            
            builder: (context, snapshot) {
           
              if (snapshot.connectionState.name == "waiting") {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData && snapshot.data is List<CorrespondenciaModel> && snapshot.connectionState.name == "done") {
               
                correspondenciaList = snapshot.data as List<CorrespondenciaModel>;

                correspondenciaListBusqueda = [];

                correspondenciaListBusqueda.addAll(correspondenciaList);

               if (fechaFiltro!.isNotEmpty) {
         
          correspondenciaListBusqueda.removeWhere((c){
  
            return c.fecha!.toLocal().toString().substring(0,10) != fechaFiltro;
         
          });
}

               correspondenciaListBusqueda.removeWhere((c) {
                  String mname = c.descripcion;
                  return !mname.toLowerCase().contains(
                    editingController.text.trim(),
                  );
                });


               return 
                correspondenciaListBusqueda.isNotEmpty ?
                listaVisita(correspondenciaListBusqueda):
                Expanded( child: Center(child: Text("No hay resultados")),);
              
              }

              if (!snapshot.hasData && snapshot.connectionState.name == "done" && correspondenciaList.isEmpty) {
                return Expanded(
                  child: Center(child: Text("No hay resultados")),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                      ),

                      onPressed: () {
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Error al hacer la peticion "+snapshot.data),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
       
        ],
      ),
    );
  }

 Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      helpText: "Selecciona fecha a filtrar",
       locale: Locale('es', 'ES'),
      context: context,
      initialDate:selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {


      selectedDate = picked;
      setState(() {

     fechaFiltro = picked.toLocal().toString().substring(0,10);
        
      });

    }
  }

  Future<dynamic> consultaCorrespondencia() {
    print("object");
    return correspondenciaList.isEmpty
        ? CorrespondenciaController().consultaCorrespondencia("20",)
        : Future(() {
          return correspondenciaList;
        });
  }

   Expanded listaVisita(List<CorrespondenciaModel> listCorrespondencia) {
     return Expanded(
       child: ListView.builder(
         itemCount: listCorrespondencia.length,
         itemBuilder: (context, index) {
           return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              mostrarioDeFecha(listCorrespondencia, index),
               Card(
                 margin:
                     index == 0
                         ? EdgeInsets.fromLTRB(12, 7, 12, 8)
                         : EdgeInsets.fromLTRB(12, 14, 12, 8),
                 color: Colors.white,
                 child: Column(
                   children: [
                    
                     ListTile(
                       trailing: IconButton(
                         onPressed: () {
                             detallesAlerta(
                               context,
                               listCorrespondencia[index],
                               "descripcion",
                               () {},
                             );
                         },
                         icon: Icon(Icons.info_outline_rounded),
                       ),
                       title: Text(
                         "Correspondencia No. ${listCorrespondencia[index].id}",
                       ),
                       subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             listCorrespondencia[index].descripcion.toString(),
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(fontSize: 12, color: Colors.black54),
                           ),
               
                           SizedBox(height: 5,),
                           Row(children: [
               
                          Padding(
                            padding: const EdgeInsets.only(right:  8.0),
                            child: Row(children: [
                            
                              Icon(Icons.image),
                            
                             listCorrespondencia[index].foto!.isNotEmpty ? Icon(Icons.check_box,size: 16,) :Icon(Icons.check_box_outline_blank_rounded) 
                                              
                                              
                            ],),
                          ),
               
               
               
                            Padding(
                                                      padding: const EdgeInsets.only(right:  8.0),
               
                              child: Row(children: [
                              
                              Icon(Icons.shield_rounded),
                              
                                                     listCorrespondencia[index].vigilante.toString().isNotEmpty ? Icon(Icons.check_box,size: 16,) :Icon(Icons.check_box_outline_blank_rounded) 
                                                
                                                
                                                    ],),
                            ),
               
                          
                            Padding(
                           padding: const EdgeInsets.only(right:  8.0),
               
                              child: Row(children: [
                              
                              Icon(Icons.email),
                              
                                                     listCorrespondencia[index].mensajeCorreo.toString().isNotEmpty ? Icon(Icons.check_box,size: 16,) :Icon(Icons.check_box_outline_blank_rounded) 
                                                
                                                
                                                    ],),
                            ) ,
               
               
                          
                            Padding(
                              padding: const EdgeInsets.only( right:  8.0),
                              child: Row(children: [
                              
                              Icon(Icons.message ),
                              
                                                     listCorrespondencia[index].mensajeWhatsapp.toString().isNotEmpty ? Icon(Icons.check_box,size: 16,) :Icon(Icons.check_box_outline_blank_rounded) 
                                                
                                                
                                                    ],),
                            ),
               
                            Padding(
                              padding: const EdgeInsets.only(right:  8.0),
                              child: Row(children: [
                              
                              Icon(Icons.search ),
                              
                                                     listCorrespondencia[index].observacionesCorrespondenciaResidente.toString().isNotEmpty ? Icon(Icons.check_box,size: 16,) :Icon(Icons.check_box_outline_blank_rounded) 
                                                
                                                
                                                    ],),
                            )
               
               
               
               
               
               
                           ],)
                         ],
                       ),
                     ),
                     Divider(
                       color: Colors.black38,
                       height: 0.0,
                       endIndent: 10,
                       indent: 10,
                     ),
               
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 children: [
                                   Icon(Icons.circle, color: Colors.red, size: 7),
                                   Text(
                                     "Fecha recibida",
                                     style: TextStyle(
                                       fontSize: 12,
                                       color: Colors.black54,
                                     ),
                                   ),
                                 ],
                               ),
               
                               Row(
                                 children: [
                                   Icon(Icons.circle, color: Colors.green, size: 7),
                                   Text(
                                     "Fecha entrega",
                                     style: TextStyle(
                                       fontSize: 12,
                                       color: Colors.black54,
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
               
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                             //  fecha y hora entrada
                               Text(
                                 "${listCorrespondencia[index].fecha.toString().substring(0,19)}",
                                 style: TextStyle(
                                   fontSize: 12,
                                   color: Colors.black54,
                                 ),
                               ),
               
                            //   fecha y hora salida
                               Row(
                                 children: [
                                   Text(
                                     "${listCorrespondencia[index].fechaCorrespondenciaResidente!}",
                                     style: TextStyle(
                                       fontSize: 12,
                                       color: Colors.black54,
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           );
         },
       ),
     );
   }




Widget mostrarioDeFecha(List<CorrespondenciaModel> lista , index) {



if ( index == 0 ) { // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes
 
  return Padding(
       padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
       child: Text(
        obtenerFechaEnLetras(DateTime.parse(lista[index].fecha!.toLocal().toString().substring(0,10))),
          style: TextStyle(color: Colors.black45 , fontWeight: FontWeight.bold),
        ),
     );
}


if (lista[index].fecha != lista[index-1].fecha ) { // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes   
  
  return  Padding( padding: const EdgeInsets.fromLTRB(8, 4, 0, 0), child: Text(
    
    obtenerFechaEnLetras(DateTime.parse(lista[index].fecha!.toLocal().toString().substring(0,10))),
    style: TextStyle(color: Colors.black45 , fontWeight: FontWeight.bold),
    
    
    )); 

}else {


}
   
     

return  SizedBox.shrink();


  }




  CircleAvatar imagenVisitante(String? imagen) {
    return CircleAvatar(
      radius: 25, // Ajusta el tamaño del avatar
      backgroundColor: Colors.grey[300], // Color de fondo si no hay imagen
      child: ClipOval(
        child: Image.network("https://software.tecnovig.com/$imagen", // Ruta de la imagen en assets
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 40, color: Colors.grey[700]);
          },
        ),
      ),
    );
  }

  void _onTextChanged(String text) async {
    editingController.text;

    setState(() {});
  }

  Card barraBusqueda() {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      color: Colors.white,
      child: TextField(
        controller: editingController,
        onChanged: _onTextChanged,
        decoration: InputDecoration(
          suffixIcon: 
          
            fechaFiltro!.isNotEmpty ? 
          IconButton(
            splashRadius: 15,
            onPressed: () {
              fechaFiltro = "";

              setState(() {
                
              });
            },
            icon:
         
             Icon(Icons.filter_alt_off_rounded ,color: Colors.red, ) 
             ) :    SizedBox.shrink(),
          hintText: "Buscar descripcion",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }

   void detallesAlerta(
     BuildContext context,
     CorrespondenciaModel? correspondencia,
     String? descripcion,
     Function()? aceptar,
   ) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
          scrollable: true,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20),
           ),
           title: Text(
             "Correspondencia No. ${correspondencia!.id}",
             textAlign: TextAlign.center,
             style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),
           ),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               
ListTile(
 
  subtitle: Text(correspondencia.descripcion.toString(),  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),),
   
   title: Text(
     "Descripcion",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),




               Column(
                 children: [
                   ListTile(
                    leading: Icon(Icons.image),
                    trailing: 
                    correspondencia.foto!.isNotEmpty ?
                    Icon(Icons.check_box) :Icon(Icons.check_box_outline_blank) ,
                    
                     
                     title: Text(
                       "Registro fotografico",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                     ),
                   ),
imagen(correspondencia.foto),
 

                //    ElevatedButton(
                    
                //     style: ButtonStyle(
                //        shape: WidgetStatePropertyAll<OutlinedBorder?>(
                //         RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(
                //             5,
                //           ), // Borde redondeado
                //           //  side: BorderSide(color: Colors.red, width: 2), // Color y grosor del borde
                //         ),
                //        ),
                //       backgroundColor: WidgetStateProperty.all(Colors.grey[300])),
                //     onPressed:  correspondencia.foto!.isNotEmpty ? () {
                   
                //  }  : null 
                //  , child: Text("ver registro foto grafico",)),
                
                
                
                 ],
               ),

 ListTile(
  leading: Icon(Icons.shield),
  
  trailing:
  correspondencia.vigilante.toString().isNotEmpty ?
   Icon(Icons.check_box) :Icon(Icons.check_box_outline_blank) ,
 
  subtitle: Text(correspondencia.vigilante.toString()),
   
   title: Text(
     "Codigo Seguridad",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),


 ListTile(
  leading: Icon(Icons.message),

  trailing:
   correspondencia.mensajeWhatsapp.toString().isNotEmpty?
   Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank) ,
 
  subtitle: Text(correspondencia.mensajeWhatsapp.toString()),
   
   title: Text(
     "Notificacion mensage",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),
 ListTile(
  leading: Icon(Icons.email),
  trailing:  correspondencia.mensajeCorreo != 0?
   Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank) ,
  subtitle: Text(correspondencia.mensajeCorreo.toString()),
   
   title: Text(


     "Notificacion correo electronico",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),


  ListTile(
  leading: Icon(Icons.search),
  trailing:
  correspondencia.observacionesCorrespondenciaResidente!.isNotEmpty ?
   Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank) ,
 
  subtitle: Text(correspondencia.observacionesCorrespondenciaResidente.toString()),
   
   title: Text(
     "Observaciones de entrega",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),

Column(
                 children: [
                   ListTile(
                    leading: Icon(Icons.drive_file_rename_outline),
                    trailing: 
                    
                    correspondencia.firmaCorrespondencia!.toString().isNotEmpty ?
                    Icon(Icons.check_box) :Icon(Icons.check_box_outline_blank) ,
                    
                     
                     title: Text(
                       "Firma de entrega",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                     ),
                   ),
                  imagen(correspondencia.firmaCorrespondencia),

                 ],
               ),
  ListTile(
  leading: Icon(Icons.date_range),
  trailing:
  correspondencia.fecha.toString().isNotEmpty ?
   Icon(Icons.check_box): Icon(Icons.check_box_outline_blank) ,
 
  subtitle: Text(correspondencia.fecha.toString() ,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
   
   title: Text(
     "Fecha  de recepcion",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),

 
  ListTile(
  leading: Icon(Icons.calendar_today),
  trailing:
   correspondencia.fechaCorrespondenciaResidente.toString().isNotEmpty ?
   Icon(Icons.check_box): Icon(Icons.check_box_outline_blank) ,
 
  subtitle: Text(correspondencia.fechaCorrespondenciaResidente.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
   
   title: Text(
     "Fecha  de entrega",
     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
   ),
 ),

             ],
           ),
           actionsAlignment: MainAxisAlignment.center,
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: const Text(
                 "Aceptar",
                 style: TextStyle(color: Colors.blue),
               ),
             ),
           ],
         );
       },
     );
   }

   dynamic imagen(String? image){


   return GestureDetector(
    onTap: () async {
      
_launchInBrowser(Uri.parse("https://software.tecnovig.com/$image"));


    },
     child: ClipRRect(
           borderRadius: BorderRadius.circular(8),
     
       child: Image.network(
       
        fit: BoxFit.cover,
        "https://software.tecnovig.com/$image", height: 150,width: 200,
        
        
        errorBuilder: (context, error, stackTrace) {
        
       
       
       return Container(
        color: Colors.white,
        width: double.maxFinite,height: 100,child: Icon(Icons.image_not_supported_rounded, color: Colors.black,),);
       
       
         },
         ),
     ),
   );

   }


     Future<void> _launchInBrowser(Uri url) async {
   if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
    
  }
}
