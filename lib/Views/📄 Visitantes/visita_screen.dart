import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/visitas_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Models/visita_model.dart';

import 'package:tecnovig/Utilities/FORMATTERS/obtener_fecha_a_letras.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/base_page_card.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/Widgets/user_info_header.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/Widgets/drawer_visitas_screen_desktop.dart';
import 'package:tecnovig/Widgets/responsive_layout.dart';

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
    // TODO: implement initState

    consultaVisitas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: visitaScreenMOBILE(context),

      // tabletBody: visitaScreenTABLET(context),
      tabletBody: visitaScreenMOBILE(context),

      //  desktopBody: visitaScreenDESKTOP(),
      desktopBody: visitaScreenDESKTOP(),
    );
  }

  //? -------------------------------------------visitaScreenMOBILE-----INICIO--------------------------------------------

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

  Column visitanteCardMobile(
   VisitaModel  visita,
    int index,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mostrarioDeFecha(visita, index),
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
                 //   detailAlertDialog(context, ListVisita[index]);
                  },
                  icon: Icon(Icons.info_outline_rounded),
                ),
                title: Text(
                  "${visita.nombre1}  ${visita.nombre2} ",
                ),
                subtitle: Text(
                  visita.id.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                leading: imagenVisitante(visita.foto),
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

  Scaffold visitaScreenDESKTOP() {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          visitanteDetallesCardDesktop(),

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
                            onPressed: () {},
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
                                  "Estado",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  "Acciones",
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
                            child: ListView.builder(
                              itemCount: visitantesListBusqueda.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mostrarioDeFecha(
                                      visitantesListBusqueda[index],
                                      index,
                                    ),
                                    visitanteCardDesktop(visitantesListBusqueda[index]),
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

  Card visitanteCardDesktop(VisitaModel visita) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10, top: 5),
      child: ListTile(
        hoverColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          visitaSelectedModel =visita;

          setState(() {});
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
          child: Row(
            children: [
              imagenVisitante(visita.foto),
              SizedBox(width: 10),
              //     Nombre
              Expanded(
                flex: 2,
                child: Text(
                  "${visita.nombre1}  ${visita.nombre2} ",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              //          Email
              // Expanded(
              //   flex: 2,
              //   child: Text(
              //     user.,
              //     style: TextStyle(color: Colors.blue),
              //   ),
              // ),
              //        Teléfono
              Expanded(
                flex: 1,
                child: Text(
                  listVisitantes[index].telefono.isNotEmpty
                      ? listVisitantes[index].telefono
                      : "- - - - - - - - - -",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              //      Estado
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("bloqueado", style: TextStyle(color: Colors.red)),
                ),
              ),
              //     Acciones
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.block, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded visitanteDetallesCardDesktop() {
    return Expanded(
      flex: 2,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
        child: SizedBox(
          height: double.maxFinite,
          child:
              visitaSelectedModel != null
                  ? Column(
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

                      Text("Registro N° ${visitaSelectedModel!.id}"),

                      imagenVisitante(
                        visitaSelectedModel == null
                            ? ""
                            : visitaSelectedModel!.foto,
                      ),

                      ListTile(
                        title: Text("Contacto"),
                        //leading: Icon(Icons.phone),
                        subtitle: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              visitaSelectedModel!.telefono,
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
                                visitaSelectedModel!.observaciones,
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
                              visitaSelectedModel!.fecha +
                                  visitaSelectedModel!.hora,

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
                              visitaSelectedModel!.salidaFecha! +
                                  visitaSelectedModel!.salidaHora!,

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

  //? -------------------------------------------visitaScreenDESKTOP-----FIN--------------------------------------------

  void buscando(String text) async {
    busquedaController.text;
 
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

  //* UTILIDADES DE ESTA CLASE

  Future<void> _selectDate(BuildContext context) async {
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
      });
    }
  }

  CircleAvatar imagenVisitante(String? imagen) {
    final String? url =
        (imagen != null && imagen.isNotEmpty)
            ? "https://software.tecnovig.com/$imagen"
            : null;

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[300],
      child:
          url != null
              ? ClipOval(
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[700],
                    );
                  },
                ),
              )
              : Icon(Icons.person, size: 30, color: Colors.grey[700]),
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
                      fechaFiltro = "";

                      setState(() {});
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

  void detailAlertDialog(BuildContext context, VisitaModel? userVisita) {
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
            "Registro visitante No. ${userVisita.id} ",
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
                  userVisita.vigilante.toString().isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text("Seguridad", style: TextStyle(fontSize: 13)),
                subtitle: Text(userVisita.vigilante.toString()),
                leading: Icon(Icons.shield),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.fecha.toString().isNotEmpty
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_outlined,
                ),
                title: Text(
                  "Fecha y hora de llegada",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text("${userVisita.fecha} ${userVisita.hora}"),
                leading: Icon(Icons.arrow_circle_down_rounded),
              ),

              ListTile(
                trailing: Icon(
                  userVisita.salidaFecha.toString().isNotEmpty
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
                subtitle: Text(userVisita.observaciones),
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

  Widget mostrarioDeFecha(VisitaModel visita, index) {
    
    if (index == 0) {
      // si el index es 0 , colocaremos la fecha encima de la cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
          obtenerFechaEnLetras(DateTime.parse(visita.fecha)),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (visita.fecha != visita.fecha) {
      // comparamos las fechas para no duplicar esas fechas encima de cada cardInfoVisitantes

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
        child: Text(
          obtenerFechaEnLetras(DateTime.parse(visita.fecha)),
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
      );
    } else {}

    return SizedBox.shrink();
  }

  void consultaVisitas() async {
    loading = true;
    setState(() {});
    resultado = await VisitasController().consultaVisita("20");

    if (resultado is List<VisitaModel>) {
      // ✅ Caso exitoso: tenemos una lista de visitantes
      listVisitantes = resultado;
      visitantesListBusqueda = listVisitantes;
      //print('Se encontraron ${visitantesList.length} visitas.');
    } else if (resultado == "STATUS 400") {
      // ❌ Error de conexión o solicitud mal formada
      //print('Error 400: Solicitud incorrecta.');
    } else if (resultado == "STATUS 500") {
      // ❌ Error del servidor
      //print('Error 500: Error interno del servidor.');
    } else if (resultado == null) {
      resultado = " No se encontraron visitas ";
      // 🟡 No se encontraron datos
      //print('No se encontraron visitas.');
    } else {
      // 🟥 Cualquier otro caso inesperado
      //print('Respuesta inesperada: $resultado');
    }

    // 🔄 Refrescar la UI si estás en un widget con estado

    loading = false;
    setState(() {});
  }
}
