
  String ocultarCorreo(String correo) {
    List<String> partes = correo.split('@');
    if (partes.length != 2) return correo; // Validación básica

    String usuario = partes[0];
    String dominio = partes[1];

    // Dejar visibles las primeras dos letras y ocultar el resto con '*'
    String usuarioOculto =
        usuario.length > 2
            ? usuario.substring(0, 2) + '*' * (usuario.length - 2)
            : usuario;

    return '$usuarioOculto@$dominio';
  }
