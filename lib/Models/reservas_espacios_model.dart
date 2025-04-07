class Reserva {
  int id;
  String fecha;
  int espacio;
  String espacioNombre; // Nuevo atributo
  int residente;
  String horaInicio;
  String horaFin;
  String observaciones;
  int estado;

  Reserva({
    required this.id,
    required this.fecha,
    required this.espacio,
    required this.espacioNombre, // Inicialización del nuevo atributo
    required this.residente,
    required this.horaInicio,
    required this.horaFin,
    required this.observaciones,
    required this.estado,
  });

  // Método para crear una instancia desde un JSON
  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: int.parse(json['id']),
      fecha: json['fecha'],
      espacio: int.parse(json['espacio']),
      espacioNombre: json['espacio_nombre'], // Asignación del nuevo atributo
      residente: int.parse(json['residente']),
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      observaciones: json['observaciones'],
      estado: int.parse(json['estado']),
    );
  }

  // Método para convertir la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'espacio': espacio,
      'espacio_nombre': espacioNombre, // Conversión del nuevo atributo
      'residente': residente,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'observaciones': observaciones,
      'estado': estado,
    };
  }
}
