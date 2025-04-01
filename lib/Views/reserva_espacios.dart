import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tecnovig/Controllers/espacio_controller.dart';
import 'package:tecnovig/Controllers/reservas_controller.dart';
import 'package:tecnovig/Models/Espacio.dart';
import 'package:tecnovig/Models/Reservas_espacios.dart';
import 'package:tecnovig/Utilities/alertDialog.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/convertiStringATimeofDay.dart';
import 'package:tecnovig/Utilities/obtener_fecha_a_letras.dart';

class ReservaEspacios extends StatefulWidget {
  final int? idUser;
  const ReservaEspacios({super.key, required this.idUser});

  @override
  _ReservaEspaciosState createState() => _ReservaEspaciosState();
}

class _ReservaEspaciosState extends State<ReservaEspacios> {
  
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? tiempoInicio;
  TimeOfDay? tiempoFin;
  Espacio? espacioSelecetd;

  List<Espacio> listaEspacios = [];
  List<Reserva> listaReservas = [];

  String? descripcion = "";
  String? subTileResultReserva = "";
  String? resultadoReserva;

  PageController _pageController = PageController();

  @override
  void initState() {

    _selectedDay = DateTime.now();
    consultaEspacios();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      _selectedDay!.difference(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)).inDays < 0 ?
        null :

       FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _mostrarBottomSheet(context);
        },
      ),
      body: Column(
        children: [

          appBar(context),


          calendario(),

          SizedBox(height: 16),

          reservas(),
        ],
      ),
    );
  }




  //*METODOS WIDGETS

  FutureBuilder<dynamic> reservas() {
    return FutureBuilder<dynamic>(
      future: ReservasController().consultaReservas(idConsulta: widget.idUser),
      builder: (context, snapshot) {
        // Manejamos la carga inicial
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }

        // Manejamos errores específicos
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        // Si no hay datos
        if (!snapshot.hasData || snapshot.data == null) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reserva un espacio",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          );
        }

        // Si el resultado es un mensaje de error (códigos de estado)
        if (snapshot.data == "STATUS 400") {
          return Center(
            child: Text(
              "Error de conexión (STATUS 400).",
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          );
        } else if (snapshot.data == "STATUS 500") {
          return Center(
            child: Text(
              "Error del servidor (STATUS 500).",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        // Mostrar la lista de reservas si hay datos válidos
        listaReservas = snapshot.data;

        listaReservas.removeWhere(
          (element) => element.fecha != formatearFecha(_selectedDay!),
        );

        listaReservas.sort((a, b) {
          TimeOfDay horaA = convertirStringATimeOfDay(a.horaFin);
          TimeOfDay horaB = convertirStringATimeOfDay(b.horaFin);

          return horaA.hour == horaB.hour
              ? horaA.minute.compareTo(
                horaB.minute,
              ) // Comparar minutos si las horas son iguales
              : horaA.hour.compareTo(horaB.hour); // Comparar horas
        });

        return Expanded(
          child:
              listaReservas.isEmpty
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Reserva un espacio",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  )
                  : ListView(
                    shrinkWrap: true,
                    children: [
                      for (int i = 0; i < listaReservas.length; i++)
                        _eventCard(
                          listaReservas[i],
                          listaReservas[i].espacioNombre,

                          '${formatearHora(listaReservas[i].horaInicio)} - ${formatearHora(listaReservas[i].horaFin)}',
                          listaReservas[i].residente != widget.idUser
                              ? 'Reservado'
                              : "Mi reserva",
                          extraInfo: listaReservas[i].observaciones,

                          listaReservas[i].residente != widget.idUser
                              ? Colors.white
                              : Colors.blue[200],
                        ),
                    ],
                  ),
        );
      },
    );
  }

  // vista del calendario
  TableCalendar<dynamic> calendario() {
    return TableCalendar(
      locale: 'es_ES',
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
     
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });


  
      },
      headerStyle: HeaderStyle(
        leftChevronIcon: const Icon(Icons.arrow_back, color: Colors.black54),
        rightChevronIcon: const Icon(
          Icons.arrow_forward,
          color: Colors.black54,
        ),
        titleCentered: false,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // appBar de flecha atras  y titulo
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
            "Calendario",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),

          IconButton(
            onPressed: () {
              if (_calendarFormat == CalendarFormat.month) {
                _calendarFormat = CalendarFormat.week;
              } else {
                _calendarFormat = CalendarFormat.month;
              }

              setState(() {});
            },
            icon: Icon(
              _calendarFormat == CalendarFormat.month
                  ? Icons.calendar_view_week
                  : Icons.calendar_view_month_sharp,
            ),
          ),
        ],
      ),
    );
  }

  // este metodo muestra el formulario de crear reserva
  void _mostrarBottomSheet(BuildContext contextBottonSheet) {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,

      context: contextBottonSheet,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.grey[300],
      isScrollControlled: true,
      builder: (contexts) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 1) {
                return pageViewValidarReservas();
              }

              if (index == 2) {
                return resultadoReserva == "success"
                    ? pageRespuestaReserva(
                      pathLottie: "succesLottie.json",
                      title: "Reserva  creada",
                      subtile: subTileResultReserva,
                      titleColor: Colors.greenAccent,
                    )
                    : pageRespuestaReserva(
                      pathLottie: "errorLottie.json",
                      title: "Reserva no creada",
                      subtile: subTileResultReserva,
                      titleColor: Colors.red[400],
                    );
              }

              return Stack(
                alignment: Alignment.topRight,
                children: [
                  formCrearReserva(contextBottonSheet),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  dynamic pageRespuestaReserva({
    String? pathLottie,
    String? title,
    Color? titleColor,
    String? subtile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Lottie.asset(pathLottie!),
        Column(
          children: [
            Text(title!, style: TextStyle(fontSize: 35, color: titleColor)),
            Text(
              textAlign: TextAlign.center,
              subtile!,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Volver", style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column pageViewValidarReservas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('cargandoLottie.json'),
        Text(
          "Estamos validando tu reserva ...",
          style: TextStyle(fontSize: 25),
        ),
      ],
    );
  }

  Padding formCrearReserva(BuildContext contexto) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          metod() {
            setState(() {});
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Nueva reserva",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  obtenerFechaEnLetras(_selectedDay!),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    color: Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.add_home_rounded,
                              color: Colors.black87,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton<Espacio>(
                              isExpanded: true,
                              value: espacioSelecetd,
                              hint: Row(
                                children: [
                                  Text(
                                    "Seleccione un espacio",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.black87,
                                  size: 32,
                                ),
                              ),
                              underline: SizedBox.shrink(),
                              items:
                                  listaEspacios.map((espacio) {
                                    return DropdownMenuItem<Espacio>(
                                      value: espacio,
                                      child: Text(
                                        espacio.descripcion,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                              
                                espacioSelecetd = value;

                                List<Reserva> listFiltro = [];

                                listFiltro.addAll(listaReservas);

                                listFiltro.removeWhere((element) {
                                  return element.espacioNombre !=
                                      espacioSelecetd!.descripcion;
                                });

                                if (listFiltro.isNotEmpty) {
                                  tiempoInicio = convertirStringATimeOfDay(
                                    listFiltro[listFiltro.length - 1].horaFin,
                                  );
                                } else {
                                  tiempoInicio = convertirStringATimeOfDay(
                                    espacioSelecetd!.horaInicio,
                                  );
                                }

                                tiempoFin = convertirStringATimeOfDay(
                                  espacioSelecetd!.horaFin,

                            
                                );

                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Min horas : ${espacioSelecetd != null ? espacioSelecetd!.horasMin.toString() : ""}",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        "Max Horas : ${espacioSelecetd != null ? espacioSelecetd!.horasMax.toString() : ""}",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                _buildTimeField(
                  "Hora inicio",
                  "la hora no debe ser menor a ${ tiempoInicio != null ?formatearHora(tiempoInicio!.format(context) ) : ""}",
                  context,
                  metod,
                  tiempoInicio,
                  0,
                ),
                SizedBox(height: 12),
                _buildTimeField(
                  "Hora fin",
                  "la hora no debe ser menor a ${espacioSelecetd != null ? formatearHora(espacioSelecetd!.horaFin) : ""}",
                  context,
                  metod,
                  tiempoFin,
                  1,
                ),
                SizedBox(height: 12),
                Text(
                  "Descripcion",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    descripcion = value;
                  },
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    //labelText: "Descripción",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (validarCamposDelFormulario().isEmpty) {
                      await _pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );

                      // Datos a enviar en el body
                      Map<String, dynamic> datosReserva = {
                        "fecha": _selectedDay.toString().substring(0, 10),
                        "espacio": espacioSelecetd!.id.toString(),
                        "residente": widget.idUser.toString(),
                        "hora_inicio": formatTimeOfDay(tiempoInicio!),
                        "hora_fin": formatTimeOfDay(tiempoFin!),
                        "observaciones": descripcion,
                      };

                      crearReservaDeEspacio(datosReserva);
                    } else {
                      alertDIalogInfoCustomError(
                        context,
                        Icon(Icons.cancel, size: 40, color: Colors.red),
                        validarCamposDelFormulario(),
                        () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Crear reserva",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    String note,
    BuildContext context,
    Function actualizarEstado,
    TimeOfDay? tiempo,
    int? horaInicioFin,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            espacioSelecetd != null
                ? Text(
                  note,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          child: Card(
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tiempo != null
                        ? formatearHora(tiempo.format(context))
                        : "00:00",
                    style: TextStyle(color: Colors.black54),
                  ),

                  IconButton(
                    onPressed:
                        espacioSelecetd == null
                            ? null
                            : () {
                              //     seleccionarHora(context);

                              _showDialog(
                                CupertinoDatePicker(
                                  initialDateTime:
                                      horaInicioFin == 0
                                          ? DateTime(
                                            2025,
                                            1,
                                            1,
                                            tiempoInicio!.hour,
                                            tiempoInicio!.minute,
                                          )
                                          : DateTime(
                                            2025,
                                            1,
                                            1,
                                            tiempoFin!.hour,
                                            tiempoFin!.minute,
                                          ),
                                  mode: CupertinoDatePickerMode.time,
                                  use24hFormat: false,
                                  // This is called when the user changes the time.
                                  onDateTimeChanged: (DateTime newTime) {
                                    if (horaInicioFin == 0) {
                                      tiempoInicio = TimeOfDay(
                                        hour: newTime.hour,
                                        minute: newTime.minute,
                                      );
                                    } else {
                                      tiempoFin = TimeOfDay(
                                        hour: newTime.hour,
                                        minute: newTime.minute,
                                      );
                                    }

                                    actualizarEstado();
                                  },
                                ),
                              );

                              actualizarEstado();
                            },
                    icon: Icon(Icons.access_time_filled_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

//card  que muestra el contenido de la reserva o evento
  Widget _eventCard(
    Reserva reserva,
    String title,
    String time,
    String status,
    Color? color, {
    String? extraInfo,
  }) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              reserva.residente == widget.idUser
                  ? Row(
                    children: [  
                      IconButton(
                        splashRadius: 10,
                        onPressed: () {
                          mostrarBottomSheetEliminar(context, () {
                          eliminarReserva(reserva.id.toString());
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  )
                  : SizedBox.shrink(),
            ],
          ),
          if (extraInfo != null && reserva.residente == widget.idUser) ...[
            SizedBox(height: 4),
            Text(extraInfo, style: TextStyle(color: Colors.black54)),
          ],
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: TextStyle(color: Colors.black54)),
              Text(
                status,
                style: TextStyle(
                  color: color == Colors.white ? Colors.black45 : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<void> seleccionarHora(BuildContext context) async {
    TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (horaSeleccionada != null) {
      print(
        "Hora seleccionada: ${horaSeleccionada.format(context)}",
      ); // Formato 12 horas
    }
  }

  // este dialog muestra el selector de horas de Ios
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Stack(
            children: [
              Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The bottom margin is provided to align the popup above the system
                // navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: child,
              ),
              Positioned(
                right: 4,
                top: 4,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel, size: 40, color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void mostrarBottomSheetEliminar(
    BuildContext context,
    VoidCallback onConfirmar,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "¿Deseas eliminar esta reserva?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmar();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  SnackBar _snackBar() {
    SnackBarBehavior? _snackBarBehavior = SnackBarBehavior.floating;

    // final SnackBarAction? action =
    //     _withAction
    //         ? SnackBarAction(
    //           label: _longActionLabel ? 'Long Action Text' : 'Action',
    //           onPressed: () {
    //             // Code to execute.
    //           },
    //         )
    //         : null;
    final double? width =
        _snackBarBehavior == SnackBarBehavior.floating ? 400.0 : null;
    // final String label =
    //     _multiLine
    //         ? 'A Snack Bar with quite a lot of text which spans across multiple '
    //             'lines. You can look at how the Action Label moves around when trying '
    //             'to layout this text.'
    //         : 'Single Line Snack Bar';
    return SnackBar(
      elevation: 10,
      content: Text(
        "ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
      ),
      //showCloseIcon: _withIcon,
      width: width,
      behavior: _snackBarBehavior,
      // action: action,
      duration: const Duration(seconds: 3),
      //    actionOverflowThreshold: _sliderValue,
    );
  }


  //* METODOS LOGICOS
  consultaEspacios() async {
    dynamic result = await EspacioController().consultaEspacios();
    listaEspacios = result;
  }


  crearReservaDeEspacio(Map<String, dynamic> datosPost) async {
  
    dynamic result = await ReservasController().crearReservaDeEspacio(datosPost);

    setState(() {});
    if (result["status"].toString() == "success") {
      resultadoReserva = "success";
      subTileResultReserva = result["message"].toString();

      await _pageController.animateToPage(
        2,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else {
      subTileResultReserva = result["message"].toString();
      resultadoReserva = "error";

      await _pageController.animateToPage(
        2,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  eliminarReserva(String id) async {
    dynamic result = await ReservasController().eliminarReserva(id);

    if (result["status"].toString() == "success") {
      if (mounted) {
        mostrarMensaje(
          context,
          result["message"].toString(),
          color: Colors.green,
        );
      }
    } else {

      if (mounted) {
        mostrarMensaje(
          context,
          result["message"].toString(),
          color: Colors.red,
        );
      }


    }
    setState(() {});
  }


  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String formatearFecha(DateTime fecha) {
    return "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  String formatearHora(String hora24) {
    // Separar la hora y los minutos
    List<String> partes = hora24.split(":");
    int horas = int.parse(partes[0]);
    String minutos = partes[1];

    // Determinar AM o PM
    String periodo = horas >= 12 ? "PM" : "AM";

    // Convertir a formato 12 horas
    horas = horas % 12;
    if (horas == 0) horas = 12;

    return "$horas:$minutos $periodo";
  }

  // este metodo valida los campos del formulario para crear las reservas
  String validarCamposDelFormulario() {
    String errorInputs = "";

    if (descripcion == null || descripcion!.isEmpty) {
      errorInputs += "• Debes completar el campo Descripción.\n";
    }

    if (tiempoInicio == null) {
      errorInputs += "• Debes seleccionar un tiempo de inicio.\n";
    }

    if (tiempoFin == null) {
      errorInputs += "• Debes seleccionar un tiempo de fin.\n";
    }

    if (espacioSelecetd == null) {
      errorInputs += "• Debes seleccionar un espacio.\n";
    } else if (convertirATimeDate(tiempoInicio!).isBefore(
      convertirATimeDate(
        convertirStringATimeOfDay(espacioSelecetd!.horaInicio),
      ),
    )) {
      errorInputs +=
          "• la hora seleccionada no debe ser inferior a las ${formatearHora(espacioSelecetd!.horaInicio)} \n";
    } else if (convertirATimeDate(tiempoFin!).isAfter(
      convertirATimeDate(convertirStringATimeOfDay(espacioSelecetd!.horaFin)),
    )) {
      errorInputs +=
          "• la hora seleccionada no debe ser superior a las ${formatearHora(espacioSelecetd!.horaFin)} \n";
    } else if (convertirATimeDate(tiempoInicio!).isAfter(
      convertirATimeDate(convertirStringATimeOfDay(espacioSelecetd!.horaFin)),
    )) {
      errorInputs +=
          "• la hora de inicio no debe ser superior a las ${formatearHora(espacioSelecetd!.horaFin)} \n";
    } else if (convertirATimeDate(tiempoFin!).isBefore(
      convertirATimeDate(
        convertirStringATimeOfDay(espacioSelecetd!.horaInicio),
      ),
    )) {
      errorInputs +=
          "• la hora final no debe ser inferior a las ${formatearHora(espacioSelecetd!.horaInicio)} \n";
    } else if (convertirATimeDate(
          tiempoFin!,
        ).difference(convertirATimeDate(tiempoInicio!)).inMinutes >=
        espacioSelecetd!.horasMax * 60) {
      errorInputs +=
          "• no puedes reservar mas horas del  maximo  permitido ( ${espacioSelecetd!.horasMax}.Hrs ) \n";
    } else if (convertirATimeDate(
          tiempoFin!,
        ).difference(convertirATimeDate(tiempoInicio!)).inMinutes <=
        espacioSelecetd!.horasMin * 60) {
      errorInputs +=
          "• no puedes reservar menos horas del minimo  permitido ( ${espacioSelecetd!.horasMin}.Hrs ) \n";
    }

    return errorInputs.trim(); // Eliminamos espacios innecesarios al final
  }

  DateTime convertirATimeDate(TimeOfDay time) {
    return DateTime(2025, 1, 1, time.hour, time.minute);
  }

}
