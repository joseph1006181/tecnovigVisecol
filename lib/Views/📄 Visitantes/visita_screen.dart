import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/visitas_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Models/visita_model.dart';
import 'package:tecnovig/Utilities/FORMATTERS/fecha_a_letras_class.dart';

import 'package:tecnovig/Utilities/validar_imagen.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/base_page_card.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/user_info_header.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/Widgets/alert_dialog_detalles_visita_mobile.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/Widgets/visitante_detalles_card_desktop.dart';
import 'package:tecnovig/Utilities/Widgets/imagen_circle_avatar.dart';
import 'package:tecnovig/Utilities/Widgets/responsive_layout.dart';

//!                        INDICE BUSQUEDA

//*   264   -->  METODOS LOGICOS DE ESTA CLASE
//*   284   -->  UTILIDADES  DE ESTA CLASE

class VisitaScreen extends StatefulWidget {
  final String? idCorrespondencia;
  final UsuarioModel? user;

  const VisitaScreen({super.key, this.idCorrespondencia = "20", this.user});

  @override
  State<VisitaScreen> createState() => _VistantesState();
}

class _VistantesState extends State<VisitaScreen> {
  
  DateTime? selectedDate = DateTime.now();

  String? fechaFiltro = "";

  TextEditingController busquedaController = TextEditingController();

  List<VisitaModel> listVisitantes = [];

  List<VisitaModel> visitantesListBusqueda = [];

  VisitaModel? visitaSelectedModel;

  bool loading = false;

  dynamic resultado;

  @override
  void initState() {
    consultaVisitas();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: visitaScreenMOBILE(context),

      tabletBody: visitaScreenDESKTOP(),

      desktopBody: visitaScreenDESKTOP(),
    );
  }

  //? -------------------------------------------visitaScreenMOBILE-----INICIO--------------------------------------------

  //* WIDGETS MOBILE

  Scaffold visitaScreenMOBILE(BuildContext context) {
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
                    filtrarPorFecha();
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

              if (snapshot.hasData &&
                  snapshot.data is List<VisitaModel> &&
                  snapshot.connectionState.name == "done") {
                listVisitantes = snapshot.data as List<VisitaModel>;

                visitantesListBusqueda = [];

                visitantesListBusqueda.addAll(listVisitantes);

                if (fechaFiltro!.isNotEmpty) {
                  visitantesListBusqueda.removeWhere((v) {
                    return v.fecha != fechaFiltro;
                  });
                }
                visitantesListBusqueda.removeWhere((v) {
                  String mname = "${v.nombre1} ${v.nombre2}";
                  return !mname.toLowerCase().contains(
                    busquedaController.text.trim(),
                  );
                });

                return visitantesListBusqueda.isNotEmpty
                    ? Expanded(
                      child: ListView.builder(
                        itemCount: visitantesListBusqueda.length,
                        itemBuilder: (context, index) {
                          return visitanteCardMobile(
                            visitantesListBusqueda[index],
                            index,
                            context,
                          );
                        },
                      ),
                    )
                    : Expanded(child: Center(child: Text("No hay resultados")));
              }

              if (!snapshot.hasData &&
                  snapshot.connectionState.name == "done" &&
                  listVisitantes.isEmpty) {
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

  Future<dynamic> consultaVisitantes() {
    //  return editingController.text.isEmpty

    return listVisitantes.isEmpty
        ? VisitasController().consultaVisita(widget.idCorrespondencia!)
        : Future(() {
          return listVisitantes;
        });
  }

  Widget visitanteCardMobile(
    VisitaModel visita,
    int index,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fechaSuperiorvisitantesCard(visita, index),
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
                    alertDialogDetallesVisitantes(context, visita);
                  },
                  icon: Icon(Icons.info_outline_rounded),
                ),
                title: Text("${visita.nombre1}  ${visita.nombre2} "),
                subtitle: Text(
                  visita.id.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                leading: imagenCircleAvatar(imagenNetworkUrl: visita.foto),
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
                          "${visita.fecha} ${visita.hora}",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),

                        //fecha y hora salida
                        Row(
                          children: [
                            Text(
                              "${visita.salidaFecha!} ${visita.salidaHora!}",
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

  //? -------------------------------------------visitaScreenMOBILE-----FIN--------------------------------------------

  //? -------------------------------------------visitaScreenDESKTOP-----INICIO--------------------------------------------

  //* WIDGETS DESKTOP

  Scaffold visitaScreenDESKTOP() {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          visitanteDetallesCardDesktop(
            visitaSelectedModel: visitaSelectedModel,
          ),

          Expanded(
            flex: 7,
            child: basePageCard(
              margin: EdgeInsets.fromLTRB(10, 9, 8, 0),
              userHeader: userInfoHeader(user: widget.user),
              pageName: "V I S I T A N T E S",
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
                                  "Nombre",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Teléfono",
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
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "Estado",
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

                        //      Lista de usuarios
                      ],
                    ),
                    loading
                        ? Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                        : !loading && listVisitantes.isNotEmpty
                        ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4,
                            ),
                            child:
                                visitantesListBusqueda.isEmpty
                                    ? Center(
                                      child: Text(
                                        "no hay resultados de busqueda",
                                      ),
                                    )
                                    : ListView.builder(
                                      itemCount: visitantesListBusqueda.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            fechaSuperiorvisitantesCard(
                                              visitantesListBusqueda[index],
                                              index,
                                            ),
                                            visitanteCardDesktop(
                                              visitantesListBusqueda[index],
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
                                consultaVisitas();
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

  Widget visitanteCardDesktop(VisitaModel visita) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10, top: 5),
      child: ListTile(
        hoverColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          visitaSelectedModel = visita;

          setState(() {});
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
          child: Row(
            children: [
              imagenCircleAvatar(imagenNetworkUrl: visita.foto),
              SizedBox(width: 10),
              //     Nombre
              Expanded(
                flex: 2,
                child: Text(
                  "${visita.nombre1}  ${visita.nombre2} ",
                  style: TextStyle(color: Colors.black87),
                ),
              ),

              Expanded(
                flex: 1,
                child: Text(
                  visita.telefono.isNotEmpty
                      ? visita.telefono
                      : "- - - - - - - - - -",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              //      Estado
              Expanded(
                flex: 1,
                child:Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    visita.observaciones,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              //     Acciones
              SizedBox(
                width: 130,
                child: visita.estado != 1
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "bloqueado",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                        : Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Activo",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //? -------------------------------------------visitaScreenDESKTOP-----FIN--------------------------------------------

  //* WIDGETS COMPARTIDOS DE ESTA CLASE

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

  Widget barraBusqueda() {
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
          hintText: "Buscar...",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget fechaSuperiorvisitantesCard(VisitaModel visita, index) {
    if (index == 0) {
      // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
          FechaAletras.fechaCompleta(DateTime.parse(visita.fecha)),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (visita.fecha != visitantesListBusqueda[index - 1].fecha) {
      // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
          FechaAletras.fechaCompleta(DateTime.parse(visita.fecha)),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    } else {}

    return SizedBox.shrink();
  }

  //* METHODS compartidos

  void consultaVisitas() async {
    loading = true;
    setState(() {});
    resultado = await VisitasController().consultaVisita(widget.idCorrespondencia!);

    if (resultado is List<VisitaModel>) {
      // ✅ Caso exitoso: tenemos una lista de visitantes
      listVisitantes = resultado;
      listVisitantes.sort((a, b) {
        return DateTime.parse(b.fecha).compareTo(DateTime.parse(a.fecha));
      });

      visitantesListBusqueda = listVisitantes;
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

  void eliminarFiltroFecha() {
    fechaFiltro = "";

    selectedDate = DateTime.now();

    buscando("");
  }

  void buscando(String text) async {
    visitantesListBusqueda = [];

    visitantesListBusqueda.addAll(listVisitantes);

    if (fechaFiltro!.isNotEmpty) {
      visitantesListBusqueda.removeWhere((v) {
        return v.fecha != fechaFiltro;
      });
    }
    visitantesListBusqueda.removeWhere((v) {
      String mname = "${v.nombre1} ${v.nombre2}";
      return !mname.toLowerCase().contains(busquedaController.text.trim());
    });
    setState(() {});
  }
}
