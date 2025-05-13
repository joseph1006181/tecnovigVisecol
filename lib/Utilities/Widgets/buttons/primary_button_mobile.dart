import 'package:flutter/material.dart';
import 'package:tecnovig/Utilities/CONST/mitheme.dart';

class PrimaryButtonMobile extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final Color backgroundColor;

  const PrimaryButtonMobile({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.backgroundColor = const Color(0xFF375CA6), // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: myTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}