 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textFormFieldMOBILE({
    required bool inputFormatters,
    String? hintText,
    String? title,
    String? label,
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.grey[200]),
        obscureText: obscureText!,
        validator: validator,
        inputFormatters:
            inputFormatters
                ? [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))]
                : [],
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: prefixIcon,
          label: Text(label ?? ""),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
