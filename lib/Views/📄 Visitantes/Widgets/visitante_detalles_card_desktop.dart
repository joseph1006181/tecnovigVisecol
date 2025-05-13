import 'package:flutter/material.dart';
import 'package:tecnovig/Models/visita_model.dart';
import 'package:tecnovig/Utilities/Widgets/imagen_circle_avatar.dart';

Widget visitanteDetallesCardDesktop({VisitaModel? visitaSelectedModel}) {
    return Expanded(
      flex: 2,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
        child: SizedBox(
          height: double.maxFinite,
          child:
              visitaSelectedModel != null
                  ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "D E T A L L E S",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                            
                        Text("Registro N° ${visitaSelectedModel.id}"),
                            
                        imagenCircleAvatar(
                          imagenNetworkUrl:
                              visitaSelectedModel.foto,
                          radiusSize: 50,
                        ),
                        SizedBox(height: 3,),
                        Text("${visitaSelectedModel.nombre1} ${visitaSelectedModel.nombre2}"),
                        SizedBox(height: 3,),
                            
                        ListTile(
                          title: Text("Contacto"),
                          //leading: Icon(Icons.phone),
                          subtitle: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                visitaSelectedModel.telefono,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                            
                        ListTile(
                          //leading: Icon(Icons.circle),
                          title: Text("Motivo"),
                          subtitle: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          //leading: Icon(Icons.content_paste_search_rounded),
                          title: SizedBox(child: Text("Observaciones")),
                          subtitle: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SizedBox(
                                height: 60,
                                child: Text(
                                  maxLines: 2,
                                  visitaSelectedModel.observaciones,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                            
                        ListTile(
                          title: Text("Fecha y hora de llagada"),
                            
                          //leading: Icon(Icons.keyboard_double_arrow_down_sharp),
                          subtitle: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                visitaSelectedModel.fecha +
                                    visitaSelectedModel.hora,
                            
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                            
                        ListTile(
                          title: Text("Fecha y hora de salida"),
                            
                          //leading: Icon(Icons.keyboard_double_arrow_up_sharp),
                          subtitle: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                visitaSelectedModel.salidaFecha! +
                                    visitaSelectedModel.salidaHora!,
                            
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                            
                        SizedBox(height: 15),
                      ],
                    ),
                  )
                  : Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "D E T A L L E S",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
        
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.ads_click_rounded, color: Colors.grey),
                              Text(
                                "selecciona un visitante",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }