  import 'dart:math';

String generateCode({int length = 6}) {
    final random = Random();
    String code = '';

    for (int i = 0; i < length; i++) {
      code += random.nextInt(10).toString(); // Genera un número entre 0 y 9
    }

    return code;
  }