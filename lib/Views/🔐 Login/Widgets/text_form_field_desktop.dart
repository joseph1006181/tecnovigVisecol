 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField textFormFieldDESKTOP({
    required bool inputFormatters,
    String? hintText,
    String? title,
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText!,
      inputFormatters:
          inputFormatters
              ? [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))]
              : [],
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey), // Color del hint text
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        // Ícono de usuario
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          borderSide: BorderSide(color: Colors.red, width: 1.5), // Borde rojo
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ), // Borde más grueso al enfocar
        ),
      ),
    );
  }