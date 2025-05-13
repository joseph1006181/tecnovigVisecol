import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Widget accionesCardImageDESKTOP({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
    required bool isHovering,
    required Function(bool) onHoverChanged,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          child: GestureDetector(
            onTap: isEnabled ? onTap : null,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => onHoverChanged(true),
              onExit: (_) => onHoverChanged(false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen con zoom o shimmer si está deshabilitado
                    isEnabled
                        ? AnimatedScale(
                          scale: isHovering ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        )
                        : Container(color: Colors.grey[300])
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(duration: 800.ms),

                    // Sombra lateral
                    isEnabled
                        ? Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),

                    // Texto con fondo blur
                    isEnabled
                        ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  color: Colors.black.withOpacity(0.3),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }