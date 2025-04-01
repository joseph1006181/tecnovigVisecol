import 'package:flutter/material.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Views/login.dart';

void alertDIalogInfoCustom(BuildContext context , String? title ,String? descripcion , Function()? aceptar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:  Text(
          title!,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content:  Text(
          descripcion!,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:  Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: aceptar,
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




void alertDIalogInfoCustomError(BuildContext context , Widget? title ,String? descripcion , Function()? aceptar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title:  title,

        content:  Text(
          descripcion!,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          
          TextButton(
            onPressed: aceptar,
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