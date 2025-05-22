// ignore_for_file: avoid_print

import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:tecnovig/Models/reservas_espacios_model.dart';
Widget calendarioDESKTOP({Function? crearEvento, Function? onTapCell}) {
  return calendar.MonthView(
    
    // Personaliza cada celda del calendario
    cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            color:
                isToday
                    ? Colors.blue[100]
                    : (isInMonth ? Colors.white : Colors.grey[300]),
          ),
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isInMonth ? Colors.black : Colors.grey,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      //  Card(child: Text(events[1].title),)
                      // Mostrar los títulos de los eventos (máximo 2 por ejemplo)
                      //    ...events.take(2).map((event) {
                      ...events.map((event) {
                        Reserva obReserva = event.event as Reserva;
                        return Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: event.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      event.title, // o cualquier propiedad que tengas
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),

                                    Text(
                                      obReserva.confirmacion == 0 ?'Pendiente' : 
                                      obReserva.confirmacion == 1 ?'Autorizado' : 
                                      ''
                                      , // o cualquier propiedad que tengas
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        backgroundColor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: 
                                        
                                         obReserva.confirmacion == 0  ?   Colors.deepOrange : 
                                      obReserva.confirmacion == 1 ?    const Color.fromARGB(255, 48, 195, 11) : 
                                         null
                                    
                                      ),
                                    ),
                                  ],
                                ),
                                            
                                Column(
                                  children: [
                                    Text(
                                      formatearHora(
                                        obReserva.horaInicio,
                                      ), // o cualquier propiedad que tengas
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                            
                                    Text(
                                      formatearHora(
                                        obReserva.horaFin,
                                      ), // o cualquier propiedad que tengas
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),


if (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).compareTo(DateTime(date.year, date.month, date.day)) <= 0)
  Align(
    alignment: Alignment.bottomRight,
    child: IconButton(
      onPressed: () {
        crearEvento!(date);
      },
      icon: Icon(Icons.add_box_rounded, color: Colors.green[400]),
    ),
  )
            ],
          ),
        ),
      );
    },

    // Rango de fechas permitidas
    minMonth: DateTime(1990),
    maxMonth: DateTime(2050),
    initialMonth: DateTime.now(),

    // Aspecto de cada celda
    cellAspectRatio: 1.45,

    // Día de inicio de la semana (puedes cambiarlo a monday o cualquier otro)
    startDay: calendar.WeekDays.monday,

    // Estilo del encabezado (flechas de navegación, etc.)
    headerStyle: calendar.HeaderStyle(
      headerTextStyle: TextStyle(color: Colors.white),
      leftIcon: Icon(Icons.chevron_left, color: Colors.white),
      rightIcon: Icon(Icons.chevron_right, color: Colors.white),
      decoration: BoxDecoration(color: Colors.black),
    ),

    // Acciones
    onPageChange: (date, pageIndex) {
      // print("Cambió a mes: $date (página: $pageIndex)");
  
    },

    onCellTap: (events, date) {
     if (events.isEmpty) {
     }else {
      //  callBack!(date);
    onTapCell!(date);
     }
    },

    onEventTap: (event, date) {
   
      //print("Tocaste el evento $event en la fecha $date");
    },

    onEventDoubleTap: (events, date) {
     // print("Doble clic en $date con eventos: $events");
    },

    onEventLongTap: (event, date) {
     // print("Mantén presionado evento: $event");
    },

    onDateLongPress: (date) {
      //print("Mantén presionada fecha: $date");
    },
  
showBorder: false,
    // Visual

    showWeekTileBorder: false,
    showWeekends: true,
    hideDaysNotInMonth:
        true, // descomenta si quieres ocultar días de otros meses
  );
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
