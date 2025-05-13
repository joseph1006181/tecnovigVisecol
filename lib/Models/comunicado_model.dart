class Comunicado {
  int id;
  int clien;
  int usua;
  DateTime fecha;
  String imagen;
  DateTime? fechaDuracion;
  int activo;
  String? link;
  String? descripcion;

  Comunicado({
    required this.id,
    required this.clien,
    required this.usua,
    required this.fecha,
    required this.imagen,
    this.fechaDuracion,
    required this.activo,
    this.link,
    this.descripcion,
  });

  // GETTERS
  int get getId => id;
  int get getClien => clien;
  int get getUsua => usua;
  DateTime get getFecha => fecha;
  String get getImagen => imagen;
  DateTime? get getFechaDuracion => fechaDuracion;
  int get getActivo => activo;
  String? get getLink => link;
  String? get getDescripcion => descripcion;

  // SETTERS
  set setId(int value) => id = value;
  set setClien(int value) => clien = value;
  set setUsua(int value) => usua = value;
  set setFecha(DateTime value) => fecha = value;
  set setImagen(String value) => imagen = value;
  set setFechaDuracion(DateTime? value) => fechaDuracion = value;
  set setActivo(int value) => activo = value;
  set setLink(String? value) => link = value;
  set setDescripcion(String? value) => descripcion = value;

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clien': clien,
      'usua': usua,
      'fecha': fecha.toIso8601String(),
      'imagen': imagen,
      'fechaDuracion': fechaDuracion?.toIso8601String(),
      'activo': activo,
      'link': link,
      'descripcion': descripcion,
    };
  }

  // Crear desde JSON / Map
  factory Comunicado.fromJson(Map<String, dynamic> json) {
    return Comunicado(
      id: int.parse(json['id']),
      clien: int.parse(json['cliente']),
      usua: int.parse(json['usuario']),
      fecha: DateTime.parse(json['fecha']),
      imagen: json['imagen'],
      fechaDuracion: DateTime.now(),
      activo: int.parse(json['activo']),
      link: json['link']??"",
      descripcion: json['descripcion']?? "",
    );
  }
}
