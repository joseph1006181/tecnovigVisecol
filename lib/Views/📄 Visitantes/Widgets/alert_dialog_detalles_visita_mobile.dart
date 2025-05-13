 import 'package:flutter/material.dart';
import 'package:tecnovig/Models/visita_model.dart';
import 'package:tecnovig/Utilities/Widgets/imagen_circle_avatar.dart';

void alertDialogDetallesVisitantes(BuildContext context,   VisitaModel? visita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Registro visitante No. ${visita!.id} ",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  imagenCircleAvatar(imagenNetworkUrl: visita.foto),
                  SizedBox(height: 5),
                  Text(
                    "${visita.nombre1} ${visita.nombre2}",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              ListTile(
                subtitle: Text(visita.motivo.toString()),
                title: Text(
                  "Motivo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                subtitle: Text(visita.telefono),
                title: Text(
                  "Contacto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                trailing: Icon(
                  visita.vigilante.toString().isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text("Seguridad", style: TextStyle(fontSize: 13)),
                subtitle: Text(visita.vigilante.toString()),
                leading: Icon(Icons.shield),
              ),

              ListTile(
                trailing: Icon(
                  visita.fecha.toString().isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text(
                  "Fecha y hora de llegada",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text("${visita.fecha} ${visita.hora}"),
                leading: Icon(Icons.arrow_circle_down_rounded),
              ),

              ListTile(
                trailing: Icon(
                  visita.salidaFecha.toString().isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text(
                  "Fecha y hora de salida",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text("${visita.salidaFecha!} ${visita.salidaHora!}"),
                leading: Icon(Icons.arrow_circle_left_outlined),
              ),

              ListTile(
                trailing: Icon(
                  visita.observaciones.isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text("Observaciones", style: TextStyle(fontSize: 13)),
                subtitle: Text(visita.observaciones),
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