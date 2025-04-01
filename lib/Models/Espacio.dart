class Espacio {
  int id;
  String descripcion;
  int horasMin;
  int horasMax;
  String horaInicio;
  String horaFin;
  int estado;
  int cliente;

  Espacio({
    required this.id,
    required this.descripcion,
    required this.horasMin,
    required this.horasMax,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    required this.cliente,
  });

  // Método para crear una instancia desde un mapa (ideal para Firebase o JSON)
  factory Espacio.fromJson(Map<String, dynamic> map) {



    return Espacio(
      id: int.parse(map['id'].toString()) ,
      descripcion: map['descripcion'] ?? '',
      horasMin: int.parse(map['horas_min']) ,
      horasMax:  int.parse(map['horas_max']),
      horaInicio: map['hora_inicio'] ?? '',
      horaFin: map['hora_fin'] ?? '',
      estado: int.parse(map['estado']),
      cliente:  int.parse(map['cliente']),
    );
  }

  // Método para convertir la instancia a un mapa (ideal para Firebase o JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'horas_min': horasMin,
      'horas_max': horasMax,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'estado': estado,
      'cliente': cliente,
    };
  }

  @override
  String toString() {
    return 'Espacio(id: $id, descripcion: $descripcion, horasMin: $horasMin, horasMax: $horasMax, horaInicio: $horaInicio, horaFin: $horaFin, estado: $estado, cliente: $cliente)';
  }
}
