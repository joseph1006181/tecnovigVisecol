import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/Widgets/CustomPageRoute.dart';

Widget accionesCardMOBILE({
  required BuildContext context,
  required String title,
  required String pathImageAsset,
  required Widget pagePush,
  required UsuarioModel? user,
}) {
  final bool isUserAvailable = user != null;

  return Expanded(
    flex: 2,
    child: GestureDetector(
      onTap:
          isUserAvailable
              ? () => Navigator.push(context, CustomPageRoute(page: pagePush))
              : null,
      child: Card(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 15),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Icono e información
              Row(
                children: [
                  /// Icono
                  Card(
                    color: Colors.grey.withOpacity(0.2),
                    margin: const EdgeInsets.all(12),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        pathImageAsset,
                        color: isUserAvailable ? null : Colors.transparent,
                      ),
                    ),
                  ),

                  /// Título
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child:
                          isUserAvailable
                              ? Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                              : Card(
                                elevation: 0,
                                color: Colors.grey[300],
                                child: const SizedBox(width: 80, height: 17),
                              ),
                    ),
                  ),
                ],
              ),

              /// Flecha o Placeholder
              Align(
                alignment: Alignment.bottomRight,
                child:
                    isUserAvailable
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                        : Card(
                          margin: const EdgeInsets.all(8),
                          elevation: 0,
                          color: Colors.grey[300],
                          child: const SizedBox(width: 45, height: 17),
                        ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget accionesCardMOBILE2({
  required String imagePath,
  required String label,
  required VoidCallback onTap,
  bool isEnabled = true,
  required Function(bool) onHoverChanged,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => onHoverChanged(true),
            onExit: (_) => onHoverChanged(false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen con zoom o shimmer si está deshabilitado
                  isEnabled
                      ? Image.asset(imagePath, fit: BoxFit.cover)
                      : Container(color: Colors.grey[400])
                          .animate(onPlay: (controller) => controller.repeat())
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
                      ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    color: Colors.white10,
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
                          ),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    color: Colors.white10,
                                    child: Icon(
                                      Icons.arrow_forward,
                                        color: Colors.grey[300],
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
