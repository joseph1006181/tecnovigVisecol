class VisitaModel {
  int _id;
  int _visitante;
  String _fecha;
  String _hora;
  int _residente;
  int _vigilante;
  String? _salidaFecha;
  String? _salidaHora;
  int _motivo;
  int? _estado;

  String _observaciones;
  String _nombre1;
  String _nombre2;
  String _telefono;
  String? _foto;

  // Constructor
  VisitaModel({
    required int id,
    required int visitante,
    required String fecha,
    required String hora,
    required int residente,
    required int vigilante,
    String? salidaFecha,
    String? salidaHora,
    String? foto,
    int motivo = 2, // Valor por defecto
    int? estado ,
    required String observaciones,
    required String nombre1,
    required String nombre2,
    required String telefono,

  })  : _id = id,
        _visitante = visitante,
        _fecha = fecha,
        _hora = hora,
        _residente = residente,
        _vigilante = vigilante,
        _salidaFecha = salidaFecha,
        _salidaHora = salidaHora,
        _motivo = motivo,
        _estado = estado,
        _observaciones = observaciones,
        _nombre1 = nombre1,
        _nombre2 = nombre2,
        _telefono = telefono,
        _foto = foto;

  // Getters
  int get id => _id;
  int get visitante => _visitante;
  String get fecha => _fecha;
  String get hora => _hora;
  int get residente => _residente;
  int get vigilante => _vigilante;
  String? get salidaFecha => _salidaFecha;
  String? get salidaHora => _salidaHora;
  int get motivo => _motivo;
  int? get estado => _estado;

  String get observaciones => _observaciones;
  String get nombre1 => _nombre1;
  String get nombre2 => _nombre2;
  String get telefono => _telefono;
  String? get foto => _foto;


  // Setters
  set id(int value) => _id = value;
  set visitante(int value) => _visitante = value;
  set fecha(String value) => _fecha = value;
  set hora(String value) => _hora = value;
  set residente(int value) => _residente = value;
  set vigilante(int value) => _vigilante = value;
  set salidaFecha(String? value) => _salidaFecha = value;
  set salidaHora(String? value) => _salidaHora = value;
  set motivo(int value) => _motivo = value;
  set observaciones(String value) => _observaciones = value;
  set nombre1(String value) => _nombre1 = value;
  set nombre2(String value) => _nombre2 = value;
  set telefono(String value) => _telefono = value;

  // Método para convertir un JSON a un objeto Visita
  factory VisitaModel.fromJson(Map<String, dynamic> json) {
    return VisitaModel(
      id:int.parse(json['id'].toString()),
      visitante: int.parse(json['visitante']),
      fecha: json['fecha'],
      hora: json['hora'],
      residente: int.parse(json['residente']),
      vigilante: int.parse(json['vigilante']),
      salidaFecha: json['salida_fecha'],
      salidaHora: json['salida_hora'],
      motivo: int.parse(json['motivo']), // Si no viene el motivo, usa 2
      estado: int.parse(json['estado']), 

      observaciones: json['observaciones'],
      nombre1: json['nombre1'],
      nombre2: json['nombre2'],
      telefono: json['telefono'],
      foto: json['foto'],

    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'visitante': _visitante,
      'fecha': _fecha,
      'hora': _hora,
      'residente': _residente,
      'vigilante': _vigilante,
      'salida_fecha': _salidaFecha,
      'salida_hora': _salidaHora,
      'motivo': _motivo,
      'estado': _estado,

      'observaciones': _observaciones,
      'nombre1': _nombre1,
      'nombre2': _nombre2,
      'telefono': _telefono,
      'foto': _foto,


    };
  }
}
