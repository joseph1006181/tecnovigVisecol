DateTime? convertirStringADateTime(String fecha) {
  try {
    if (fecha.contains('/')) {
      return DateTime.parse(fecha.replaceAll('/', '-'));
    } else if (fecha.contains('-')) {
      return DateTime.parse(fecha);
    }
  } catch (e) {
    print("Error al convertir: $e");
  }
  return null;
}