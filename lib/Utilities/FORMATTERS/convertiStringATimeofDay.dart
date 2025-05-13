import 'package:flutter/material.dart';

TimeOfDay convertirStringATimeOfDay(String hora) {
  List<String> partes = hora.split(":");
  int horas = int.parse(partes[0]);
  int minutos = int.parse(partes[1]);

  return TimeOfDay(hour: horas, minute: minutos);
}