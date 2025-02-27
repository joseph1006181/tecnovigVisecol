import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/visitantes_controller.dart';
import 'package:tecnovig/Models/Visitantes_registro.dart';
import 'package:tecnovig/Utilities/obtener_fecha_a_letras.dart';

//!                        INDICE BUSQUEDA

//*   264   -->  METODOS LOGICOS DE ESTA CLASE
//*   284   -->  UTILIDADES  DE ESTA CLASE




class Vistantes extends StatefulWidget {
  const Vistantes({super.key});

  @override
  State<Vistantes> createState() => _VistantesState();
}

class _VistantesState extends State<Vistantes> {
 
   DateTime? selectedDate   = DateTime.now();
   String? fechaFiltro = "";

  TextEditingController editingController = TextEditingController();

  List<Visita> visitantesList = [];

  List<Visita> visitantesListBusqueda = [];



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
                  "Visitantes",
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
          
            future: consultaVisitantes(),
            
            builder: (context, snapshot) {
           
              if (snapshot.connectionState.name == "waiting") { 
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData && snapshot.data is List<Visita> && snapshot.connectionState.name == "done") {
                
                visitantesList = snapshot.data as List<Visita>;
                
                visitantesListBusqueda = [];

                visitantesListBusqueda.addAll(visitantesList);
 
 
             if (fechaFiltro!.isNotEmpty) {
         
          visitantesListBusqueda.removeWhere((v){
  
  
            return v.fecha != fechaFiltro;
          });
}
                visitantesListBusqueda.removeWhere((v) {
                  String mname = "${v.nombre1} ${v.nombre2}";
                  return !mname.toLowerCase().contains(
                    editingController.text.trim(),
                  );
                });


                return 
                visitantesListBusqueda.isNotEmpty ?
                listaVisita(visitantesListBusqueda):
                Expanded( child: Center(child: Text("No hay resultados")),);
                
              }

              if (!snapshot.hasData && snapshot.connectionState.name == "done" && visitantesList.isEmpty) {
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



  

 


  
//* METODOS LOGICOS DE ESTA CLASE
 
 

  Expanded listaVisita(List<Visita> ListVisita) {
    return Expanded(
      child: ListView.builder(
        itemCount: ListVisita.length,
        itemBuilder: (context, index) {
          return cardVisitanteInfo(ListVisita, index, context);
        },
      ),
    );
  }

  void _onTextChanged(String text) async {
    editingController.text;

    setState(() {});
  }

 Future<dynamic> consultaVisitantes() {
  //  return editingController.text.isEmpty
    
    return visitantesList.isEmpty
        ? VisitantesController().consultaVisita("20")
        : Future(() {
          return visitantesList;
        });
  }





//* UTILIDADES DE ESTA CLASE
   

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

   Column cardVisitanteInfo(List<Visita> ListVisita, int index, BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
     
        mostrarioDeFecha(ListVisita,index),
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
                        detailAlertDialog(  context, ListVisita[index]
                        
                        );
                      },
                      icon: Icon(Icons.info_outline_rounded),
                    ),
                    title: Text(
                      "${ListVisita[index].nombre1}  ${ListVisita[index].nombre2} ",
                    ),
                    subtitle: Text(
                      ListVisita[index].id.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    leading:  imagenVisitante(ListVisita[index].foto),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.black38,
                    height: 0.8,
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
                                  "entrada",
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
                                  "salida",
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
                            //fecha y hora entrada
                            Text(
                              "${ListVisita[index].fecha} ${ListVisita[index].hora}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
            
                            //fecha y hora salida
                            Row(
                              children: [
                                Text(
                                  "${ListVisita[index].salidaFecha!} ${ListVisita[index].salidaHora!}",
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
  }

   CircleAvatar imagenVisitante(String? imagen) {
    

    return CircleAvatar(
      radius: 25, // Ajusta el tamaño del avatar
      backgroundColor: Colors.grey[300], // Color de fondo si no hay imagen
      child: ClipOval(
        child: Image.network(
         
              "https://software.tecnovig.com/$imagen", // Ruta de la imagen en assets
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
          hintText: "Buscar",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void detailAlertDialog( BuildContext context, Visita? userVisita) {
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        print(userVisita!.foto);
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Registro visitante No. ${userVisita!.id} ",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  imagenVisitante(userVisita.foto),
                  SizedBox(height: 5),
                  Text(
                    "${userVisita.nombre1} ${userVisita.nombre2}",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              ListTile(
                subtitle: Text(userVisita.motivo.toString()),
                title: Text(
                  "Motivo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                subtitle: Text(userVisita.telefono),
                title: Text(
                  "Contacto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.vigilante.toString() != null
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text("Seguridad", style: TextStyle(fontSize: 13)),
                subtitle: Text(userVisita.vigilante.toString()),
                leading: Icon(Icons.shield),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.fecha.toString() != null
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text(
                  "Fecha y hora de llegada",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text("${userVisita.fecha!} ${userVisita.hora!}"),
                leading: Icon(Icons.arrow_circle_down_rounded),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.salidaFecha.toString() != null
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text(
                  "Fecha y hora de salida",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  "${userVisita.salidaFecha!} ${userVisita.salidaHora!}",
                ),
                leading: Icon(Icons.arrow_circle_left_outlined),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.observaciones.isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text("Observaciones", style: TextStyle(fontSize: 13)),
                subtitle: Text("${userVisita.observaciones}"),
                leading: Icon(Icons.content_paste_search_sharp),
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













  Widget mostrarioDeFecha(List<Visita> lista , index) {



if ( index == 0 ) { // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes
 
  return Padding(
       padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
       child: Text(
        obtenerFechaEnLetras(DateTime.parse(lista[index].fecha)),
          style: TextStyle(color: Colors.black45 , fontWeight: FontWeight.bold),
        
        ),
     );
}


if (lista[index].fecha != lista[index-1].fecha ) { // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes   
  
  return  Padding( padding: const EdgeInsets.fromLTRB(8, 4, 0, 0), child: Text(
    obtenerFechaEnLetras(DateTime.parse(lista[index].fecha)),
          style: TextStyle(color: Colors.black45 , fontWeight: FontWeight.bold),
    
    )); 

}else {


}
   
     

return  SizedBox.shrink();


  }
}
