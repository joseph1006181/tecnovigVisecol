import 'package:flutter/material.dart';

void mostrarMensaje(BuildContext context, String mensaje , {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(mensaje)));
  }