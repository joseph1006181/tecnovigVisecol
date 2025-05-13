

class FechaAletras {
  static final List<String> _meses = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
  ];

  static final List<String> _diasSemana = [
    "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
  ];

  /// Devuelve la fecha completa: "Lunes, 22 de Abril de 2025"
  static String fechaCompleta(DateTime fecha) {
    final nombreMes = _meses[fecha.month - 1];
    final nombreDia = _diasSemana[fecha.weekday - 1];
    return "$nombreDia, ${fecha.day} de $nombreMes de ${fecha.year}";
  }

  /// Devuelve solo el nombre del día: "Martes"
  static String nombreDia(DateTime fecha) {
    return _diasSemana[fecha.weekday - 1];
  }

  /// Devuelve solo el nombre del mes: "Abril"
  static String nombreMes(DateTime fecha) {
    return _meses[fecha.month - 1];
  }
}