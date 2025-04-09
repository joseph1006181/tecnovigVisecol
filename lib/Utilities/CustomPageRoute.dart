import 'package:flutter/material.dart';
import 'package:tecnovig/Utilities/responsive_layout.dart';
import 'package:tecnovig/Views/desktop/valida_user_desktop.dart';
class CustomPageRoute extends PageRouteBuilder {
  final Widget page;


  CustomPageRoute({required this.page,})
    : super(
       pageBuilder: (context, animation, secondaryAnimation) =>page,
        // pageBuilder: (context, animation, secondaryAnimation) {
        //   return ResponsiveLayout(
        //     mobileBody: page,
          
        //   );
        // },

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Inicia desde la derecha
          const end = Offset.zero; // Termina en la posición normal
          const curve = Curves.easeInOut; // Animación suave

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
            //   child: ResponsiveLayout(mobileBody: ValidarUser(), tabletBody: child, desktopBody: DesktopScaffold()),
          );
        },
        transitionDuration: Duration(
          milliseconds: 400,
        ), // Duración de la animación
      );
}
