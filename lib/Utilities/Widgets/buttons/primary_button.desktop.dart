import 'package:flutter/material.dart';
import 'package:tecnovig/Utilities/CONST/mitheme.dart';


class PrimaryButtonDesktop extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final  bool loading;
  final Color backgroundColor;

  const PrimaryButtonDesktop({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.backgroundColor = const Color(0xFF375CA6), // Default color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
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
          child:
              loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
        ),
      ),
    );
  }
}













// Padding bottomDESKTOP({String? nameText, required Function()? onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 50.0),
//       child: SizedBox(
//         width: double.infinity,
//         height: 50,
//         child: ElevatedButton(
//           onPressed: loading ? null : onPressed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red, // Color de fondo rojo
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10), // Bordes redondeados
//             ),
//           ),
//           child:
//               loading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text(
//                     nameText!,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//         ),
//       ),
//     );
//   }