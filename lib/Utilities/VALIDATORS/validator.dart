class Validators {
  static String? isNotEmpty(String? value, {String message = 'Campo obligatorio'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? isEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Correo obligatorio';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Correo no válido';
    return null;
  }

  static String? isPasswordValid(String? value){
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    if (value.length < 8) {
      return 'Debe tener al menos 8 caracteres';
    }
    // if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    //   return 'Debe contener al menos una letra mayúscula';
    // }
    // if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    //   return 'Debe contener al menos una letra minúscula';
    // }
    // if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    //   return 'Debe contener al menos un número';
    // }
    // if (!RegExp(r'(?=.*[@\$!%*?&])').hasMatch(value)) {
    //   return 'Debe contener al menos un carácter especial (@\$!%*?&)';
    // }
    if (['123456', 'password', 'admin'].contains(value)) {
      return 'La contraseña es demasiado común';
    }

    return null;
  }

  static String? confirmPassword(String? value, String compareWith) {
    if (value == null || value.isEmpty) return 'Confirma la contraseña';
    if (value != compareWith) return 'Las contraseñas no coinciden';
    return null;
  }





 static  String? validatorCodigoRecuperacion(String? value, String codigoEsperado) {
  if (value == null || value.isEmpty) {
    return 'El campo no puede estar vacío';
  } else if (value != codigoEsperado) {
    return 'El código que ingresaste no coincide';
  }
  return null;
}


 static  String? validatorCedula(String? value,) {
  if (value == null || value.isEmpty) {
      return 'La cedula no puede estar vacía';
    } else if (value.length < 3) {
      return 'ingresa una cedula valida';
    }
    return null; // Contraseña válida
  }




 static    String? validatorTelefono(String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'El número de teléfono no puede estar vacío';
        }

        if (value.contains(' ')) {
          return 'El número de teléfono no debe contener espacios';
        }
        String trimmedValue = value.trim();

        if (trimmedValue.length < 10) {
          return 'El número de teléfono debe tener al menos 10 dígitos';
        }
        if (trimmedValue.length > 10) {
          return 'El número de teléfono no debe tener mas de 10 dígitos';
        }
        if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
          return 'Solo se permiten números';
        }

        return null; // Teléfono válido
      }












}



  
