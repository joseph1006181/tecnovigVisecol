import 'dart:math';

String generarContrasena({int longitud = 6}) {
  const String caracteres = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  return List.generate(longitud, (index) => caracteres[random.nextInt(caracteres.length)]).join();
}