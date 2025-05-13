
import 'package:flutter/material.dart';

class ButtomCustom1 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final  bool loading;
  final Color backgroundColor;

  const ButtomCustom1({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.backgroundColor = const Color(0xFF375CA6), // Default color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:
            loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
      ),
    );
  }
}
