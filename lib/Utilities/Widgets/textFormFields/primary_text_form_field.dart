import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField primaryTextFormField({
  String? hintText,
  String? labelText,
  TextEditingController? controller,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool obscureText = false,
  bool onlyNumbers = false,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    inputFormatters: onlyNumbers
        ? [FilteringTextInputFormatter.digitsOnly]
        : [],
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
}