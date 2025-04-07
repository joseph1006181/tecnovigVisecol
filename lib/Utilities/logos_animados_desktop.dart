 import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Expanded logosAnimadosLoginDesktop() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Animate(
            effects: [
              SlideEffect(
                begin: Offset(
                  -2.0,
                  0,
                ), // Comienza bien fuera de la pantalla a la izquierda
                end: Offset(0.0, 0), // Llega a su posición normal
                duration: 800.ms, // Duración de la animación
                curve: Curves.decelerate,
              ),
            ], // Movimiento desacelerado al final)],

            child: Image.asset("logoTecnoVigLogin.png", width: 300),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50, left: 50),
              child: Image.asset(
                    "logoRedondo.png",
                  ) //  .animate(onPlay:   (controller) => controller.repeat())
                  .animate()
                  // .fadeIn(
                  //   duration: 1.seconds,
                  //   delay: Duration(milliseconds: 300),
                  // )
                  .scale(duration: 800.ms, delay: Duration(milliseconds: 300))
                  .rotate(
                    begin: 0,
                    end: 1,
                    duration: 5.seconds,
                    curve: Curves.linear,
                  )
                  .swap(
                    // Usa swap para iniciar una animación infinita después
                    builder:
                        (context, child) => child!.animate(
                          effects: [
                            RotateEffect(
                              begin: 0,
                              end: 1,
                              duration: 5.seconds,
                              curve: Curves.linear,
                            ),
                          ],
                          onPlay:
                              (controller) =>
                                  controller
                                      .repeat(), // Hace que la rotación se repita
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }