import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tecnovig/Controllers/correspondencia_controller.dart';
import 'package:tecnovig/Models/correspondencia_model.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/FORMATTERS/fecha_a_letras_class.dart';
import 'package:tecnovig/Utilities/Widgets/imagen_circle_avatar.dart';
import 'package:tecnovig/Utilities/Widgets/responsive_layout.dart';
import 'package:tecnovig/Views/%E2%9C%89%EF%B8%8F%20Correspondencia/Widgets/correspondencia_detalles_card.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/base_page_card.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/drawer_home_screen.desktop.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/user_info_header.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/Widgets/visitante_detalles_card_desktop.dart';
import 'package:url_launcher/url_launcher.dart';

class CorrespondenciaScreen extends StatefulWidget {
  final String? idCorrespondencia;
  final UsuarioModel? user;

  const CorrespondenciaScreen({super.key, this.idCorrespondencia, this.user ,});

  @override
  State<CorrespondenciaScreen> createState() => CorrespondenciaScreenState();
}

class CorrespondenciaScreenState extends State<CorrespondenciaScreen> {
  
  DateTime? selectedDate = DateTime.now();

  String? fechaFiltro = "";

  TextEditingController busquedaController = TextEditingController();

  List<CorrespondenciaModel> correspondenciaList = [];

  List<CorrespondenciaModel> correspondenciaListBusqueda = [];

  bool loading = false;

  CorrespondenciaModel? correspondenciaSelectedModel;

  dynamic resultado;

  bool isHoveringVisitantes = false;
  
  @override
  void initState() {
    consultaCorrespondencias();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: correspondenciaScreenMOBILE(),

      tabletBody: correspondenciaScreenMOBILE(),

      desktopBody: correspondenciaScreenDESKTOP(),
    );
  }

  //? -------------------------------------------correspondenciaMOBILE-----INICIO--------------------------------------------

  // * WIDGETS MOBILE

  Scaffold correspondenciaScreenMOBILE() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar(context),

          barraBusqueda(),

          FutureBuilder<dynamic>(
            future: consultaCorrespondencia(),

            builder: (context, snapshot) {
              if (snapshot.connectionState.name == "waiting") {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData &&
                  snapshot.data is List<CorrespondenciaModel> &&
                  snapshot.connectionState.name == "done") {
                correspondenciaList =
                    snapshot.data as List<CorrespondenciaModel>;

                correspondenciaListBusqueda = [];

                correspondenciaListBusqueda.addAll(correspondenciaList);

                if (fechaFiltro!.isNotEmpty) {
                  correspondenciaListBusqueda.removeWhere((c) {
                    return c.fecha!.toLocal().toString().substring(0, 10) !=
                        fechaFiltro;
                  });
                }

                correspondenciaListBusqueda.removeWhere((c) {
                  String mname = c.descripcion;
                  return !mname.toLowerCase().contains(
                    busquedaController.text.trim(),
                  );
                });

                return correspondenciaListBusqueda.isNotEmpty
                    ? listaVisita(correspondenciaListBusqueda)
                    : Expanded(
                      child: Center(child: const Text("No hay resultados")),
                    );
              }

              if (!snapshot.hasData &&
                  snapshot.connectionState.name == "done" &&
                  correspondenciaList.isEmpty) {
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
                        child: Text(
                          "Error al hacer la peticion " + snapshot.data,
                        ),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          SizedBox(height: 5),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.image),

                                    listCorrespondencia[index].foto!.isNotEmpty
                                        ? Icon(Icons.check_box, size: 16)
                                        : Icon(
                                          Icons.check_box_outline_blank_rounded,
                                        ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),

                                child: Row(
                                  children: [
                                    Icon(Icons.shield_rounded),

                                    listCorrespondencia[index].vigilante
                                            .toString()
                                            .isNotEmpty
                                        ? Icon(Icons.check_box, size: 16)
                                        : Icon(
                                          Icons.check_box_outline_blank_rounded,
                                        ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),

                                child: Row(
                                  children: [
                                    Icon(Icons.email),

                                    listCorrespondencia[index].mensajeCorreo
                                            .toString()
                                            .isNotEmpty
                                        ? Icon(Icons.check_box, size: 16)
                                        : Icon(
                                          Icons.check_box_outline_blank_rounded,
                                        ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.message),

                                    listCorrespondencia[index].mensajeWhatsapp
                                            .toString()
                                            .isNotEmpty
                                        ? Icon(Icons.check_box, size: 16)
                                        : Icon(
                                          Icons.check_box_outline_blank_rounded,
                                        ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search),

                                    listCorrespondencia[index]
                                            .observacionesCorrespondenciaResidente
                                            .toString()
                                            .isNotEmpty
                                        ? Icon(Icons.check_box, size: 16)
                                        : Icon(
                                          Icons.check_box_outline_blank_rounded,
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 7,
                                  ),
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
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 7,
                                  ),
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
                                listCorrespondencia[index].fecha
                                    .toString()
                                    .substring(0, 19),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),

                              //   fecha y hora salida
                              Row(
                                children: [
                                  Text(
                                    listCorrespondencia[index]
                                        .fechaCorrespondenciaResidente!,
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

  Future<dynamic> consultaCorrespondencia() {
    // id correspondencia que tiene correspondencia      id = 20
    return correspondenciaList.isEmpty
        ? CorrespondenciaController().consultaCorrespondencia(
          widget.idCorrespondencia!,
        )
        : Future(() {
          return correspondenciaList;
        });
  }
 
  Padding appBar(BuildContext context) {
    return Padding(
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          IconButton(
            splashRadius: 30,
            onPressed: () {
              filtrarPorFecha();
            },
            icon: Icon(Icons.calendar_month_outlined),
          ),
        ],
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                subtitle: Text(
                  correspondencia.descripcion.toString(),
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                ),

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
                        correspondencia.foto!.isNotEmpty
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),

                    title: Text(
                      "Registro fotografico",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  imagen(correspondencia.foto),
                ],
              ),

              ListTile(
                leading: Icon(Icons.shield),

                trailing:
                    correspondencia.vigilante.toString().isNotEmpty
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),

                subtitle: Text(correspondencia.vigilante.toString()),

                title: Text(
                  "Codigo Seguridad",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),

              ListTile(
                leading: Icon(Icons.message),

                trailing:
                    correspondencia.mensajeWhatsapp.toString().isNotEmpty
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),

                subtitle: Text(correspondencia.mensajeWhatsapp.toString()),

                title: Text(
                  "Notificacion mensage",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                trailing:
                    correspondencia.mensajeCorreo != 0
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                subtitle: Text(correspondencia.mensajeCorreo.toString()),

                title: Text(
                  "Notificacion correo electronico",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),

              ListTile(
                leading: Icon(Icons.search),
                trailing:
                    correspondencia
                            .observacionesCorrespondenciaResidente!
                            .isNotEmpty
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),

                subtitle: Text(
                  correspondencia.observacionesCorrespondenciaResidente
                      .toString(),
                ),

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
                        correspondencia.firmaCorrespondencia!
                                .toString()
                                .isNotEmpty
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),

                    title: Text(
                      "Firma de entrega",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  imagen(correspondencia.firmaCorrespondencia),
                ],
              ),
              ListTile(
                trailing:
                    correspondencia.fecha.toString().isNotEmpty
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),

                subtitle: Text(
                  correspondencia.fecha.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),

                title: Text(
                  "Fecha  de recepcion",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),

              ListTile(
                leading: Icon(Icons.calendar_today),
                trailing:
                    correspondencia.fechaCorrespondenciaResidente
                            .toString()
                            .isNotEmpty
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),

                subtitle: Text(
                  correspondencia.fechaCorrespondenciaResidente.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),

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



  //? -------------------------------------------correspondenciaMOBILE-----FIN--------------------------------------------

  //? -------------------------------------------correspondenciaDESKTOP-----INICIO--------------------------------------------
  //* WIDGETS DESKTOP

  Scaffold correspondenciaScreenDESKTOP() {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          correspondenciaDetallesCardDesktop(
            correspondencia: correspondenciaSelectedModel,
            isHovering: isHoveringVisitantes,
            onHoverChanged:
                      (value) =>
                          setState(() => isHoveringVisitantes = value),
          ),

          Expanded(
            flex: 7,
            child: basePageCard(
              margin: EdgeInsets.fromLTRB(10, 9, 8, 0),
              userHeader: userInfoHeader(user: widget.user),
              pageName: "C O R R E S P O N D E N C I A",
              content: Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: barraBusqueda()),

                          IconButton(
                            onPressed: () async {
                              filtrarPorFecha();
                            },
                            icon: Icon(Icons.calendar_month, size: 35),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //      Encabezados
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10,
                          ),
                          child: Row(
                            children: const [
                              SizedBox(width: 50), //Espacio para el avatar
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Descripcion",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Observaciones",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Fecha recepcion",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "Fecha entrega",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                          endIndent: 18,
                          indent: 18,
                        ),
                      ],
                    ),
                    loading
                        ? Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                        : !loading && correspondenciaList.isNotEmpty
                        ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4,
                            ),
                            child:
                                correspondenciaListBusqueda.isEmpty
                                    ? Center(
                                      child: Text(
                                        "no hay resultados de busqueda",
                                      ),
                                    )
                                    : ListView.builder(
                                      itemCount:
                                          correspondenciaListBusqueda.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            fechaSuperiorvisitantesCard(
                                              correspondenciaListBusqueda[index],
                                              index,
                                            ),
                                            correspondenciaCardDesktop(
                                              correspondenciaListBusqueda[index],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                          ),
                        )
                        : Expanded(
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                consultaCorrespondencias();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  resultado ?? "",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fechaSuperiorvisitantesCard(
    CorrespondenciaModel correspondencia,
    index,
  ) {
    if (index == 0) {
      // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
           FechaAletras.fechaCompleta(correspondencia.fecha!),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (correspondencia.fecha != correspondenciaListBusqueda[index - 1].fecha) {
      // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
          FechaAletras.fechaCompleta(correspondencia.fecha!),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    } else {}

    return SizedBox.shrink();
  }

  Widget correspondenciaCardDesktop(CorrespondenciaModel correspondencia) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10, top: 5),
      child: ListTile(
        hoverColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          correspondenciaSelectedModel = correspondencia;
          setState(() {});
        },
          title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: Icon(Icons.inventory_2),
              ),
              SizedBox(width: 10),
              //     Nombre
              Expanded(
                flex: 2,
                child: Text(
                  correspondencia.descripcion,
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    correspondencia
                            .observacionesCorrespondenciaResidente!
                            .isNotEmpty
                        ? correspondencia.observacionesCorrespondenciaResidente!
                        : "- - - - - - - - - - -",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              //      Estado
              Expanded(
                flex: 1,
                child: Text(
                  correspondencia.fechaCorrespondenciaResidente!.isEmpty
                      ? "----yyyy-mm-dd---"
                      : correspondencia.fechaCorrespondenciaResidente!,
                ),
              ),
              //     Acciones
              SizedBox(
                width: 150,
                child: Text(
                  correspondencia.fecha!.toLocal().toString().isEmpty
                      ? "----yyyy-mm-dd---"
                      : correspondencia.fecha!.toLocal().toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  


  //? -------------------------------------------correspondenciaDESKTOP-----FIN--------------------------------------------

  //* WIDGETS

  Widget mostrarioDeFecha(List<CorrespondenciaModel> lista, index) {
    if (index == 0) {
      // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
           FechaAletras.fechaCompleta(
            DateTime.parse(
              lista[index].fecha!.toLocal().toString().substring(0, 10),
            ),
          ),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (lista[index].fecha != lista[index - 1].fecha) {
      // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
           FechaAletras.fechaCompleta(
            DateTime.parse(
              lista[index].fecha!.toLocal().toString().substring(0, 10),
            ),
          ),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    } else {}

    return SizedBox.shrink();
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
        controller: busquedaController,
        onChanged: buscando,
        decoration: InputDecoration(
          suffixIcon:
              fechaFiltro!.isNotEmpty
                  ? IconButton(
                    splashRadius: 15,
                    onPressed: () {
                      eliminarFiltroFecha();
                    },
                    icon: Icon(Icons.filter_alt_off_rounded, color: Colors.red),
                  )
                  : SizedBox.shrink(),
          hintText: "Buscar descripcion",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }

  dynamic imagen(String? image) {
    return GestureDetector(
      onTap: () async {
        _launchInBrowser(Uri.parse("https://software.tecnovig.com/$image"));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: Image.network(
          fit: BoxFit.cover,
          "https://software.tecnovig.com/$image",
          height: 150,
          width: 200,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.white,
              width: double.maxFinite,
              height: 100,
              child: Icon(
                Icons.image_not_supported_rounded,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
    );
  }

  //*METODOS

  void eliminarFiltroFecha() {
    fechaFiltro = "";

    selectedDate = DateTime.now();

    buscando("");
  }

  void consultaCorrespondencias() async {
    loading = true;
    setState(() {});
    resultado = await CorrespondenciaController().consultaCorrespondencia(widget.idCorrespondencia!);

    if (resultado is List<CorrespondenciaModel>) {
      // ✅ Caso exitoso: tenemos una lista de visitantes
      correspondenciaList = resultado;
      correspondenciaList.sort((a, b) {
        return b.fecha!.compareTo(a.fecha!);
      });

      correspondenciaListBusqueda = correspondenciaList;
    } else if (resultado == "STATUS 400") {
      // ❌ Error de conexión o solicitud mal formada
    } else if (resultado == "STATUS 500") {
      // ❌ Error del servidor
    } else if (resultado == null) {
      resultado = " No se encontraron visitas ";
      // 🟡 No se encontraron datos
    } else {
      // 🟥 Cualquier otro caso inesperado
    }

    loading = false;
    setState(() {});
  }

  Future<void> filtrarPorFecha() async {
    final DateTime? picked = await showDatePicker(
      helpText: "Selecciona fecha a filtrar",
      locale: Locale('es', 'ES'),
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      setState(() {
        fechaFiltro = picked.toLocal().toString().substring(0, 10);
        buscando("");
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      browserConfiguration: const BrowserConfiguration(showTitle: true),
      webViewConfiguration: const WebViewConfiguration(),
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void buscando(String text) async {
    correspondenciaListBusqueda = [];

    correspondenciaListBusqueda.addAll(correspondenciaList);

    if (fechaFiltro!.isNotEmpty) {
      correspondenciaListBusqueda.removeWhere((v) {
        return v.fecha!.toString().substring(0, 10) != fechaFiltro!;
      });
    }
    correspondenciaListBusqueda.removeWhere((v) {
      String mname = v.descripcion;
      return !mname.toLowerCase().contains(busquedaController.text.trim());
    });
    setState(() {});
  }
}
