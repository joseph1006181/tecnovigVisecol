String obtenerFechaEnLetras(DateTime fecha) {
  List<String> meses = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
  ];

  List<String> diasSemana = [
    "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"
  ];

  String nombreMes = meses[fecha.month - 1]; // Obtener el nombre del mes
  String nombreDiaSemana = diasSemana[fecha.weekday - 1]; // Obtener el nombre del día

  return "$nombreDiaSemana, ${fecha.day} de $nombreMes de ${fecha.year}";
}
