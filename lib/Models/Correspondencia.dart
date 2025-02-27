class CorrespondenciaModel {
  int _id;
  String _descripcion;
  String? _foto;
  DateTime? _fecha;
  int _residente;
  int _vigilante;
  int _mensajeWhatsapp;
  int _mensajeCorreo;
  String? _fechaCorrespondenciaResidente;
  String? _observacionesCorrespondenciaResidente;
  String? _firmaCorrespondencia;

  // Constructor
  CorrespondenciaModel({
    required int id,
    required String descripcion,
    String? foto,
    DateTime? fecha,
    required int residente,
    required int vigilante,
    int mensajeWhatsapp = 0,
    int mensajeCorreo = 0,
    String? fechaCorrespondenciaResidente,
     String? observacionesCorrespondenciaResidente,
     String? firmaCorrespondencia,
  })  : _id = id,
        _descripcion = descripcion,
        _foto = foto,
        _fecha = fecha,
        _residente = residente,
        _vigilante = vigilante,
        _mensajeWhatsapp = mensajeWhatsapp,
        _mensajeCorreo = mensajeCorreo,
        _fechaCorrespondenciaResidente = fechaCorrespondenciaResidente,
        _observacionesCorrespondenciaResidente = observacionesCorrespondenciaResidente,
        _firmaCorrespondencia = firmaCorrespondencia;

  // Getters
  int get id => _id;
  String get descripcion => _descripcion;
  String? get foto => _foto;
  DateTime? get fecha => _fecha;
  int get residente => _residente;
  int get vigilante => _vigilante;
  int get mensajeWhatsapp => _mensajeWhatsapp;
  int get mensajeCorreo => _mensajeCorreo;
  String? get fechaCorrespondenciaResidente => _fechaCorrespondenciaResidente;
  String? get observacionesCorrespondenciaResidente => _observacionesCorrespondenciaResidente;
  String?get firmaCorrespondencia => _firmaCorrespondencia;

  // Setters
  set id(int value) => _id = value;
  set descripcion(String value) => _descripcion = value;
  set foto(String? value) => _foto = value;
  set fecha(DateTime? value) => _fecha = value;
  set residente(int value) => _residente = value;
  set vigilante(int value) => _vigilante = value;
  set mensajeWhatsapp(int value) => _mensajeWhatsapp = value;
  set mensajeCorreo(int value) => _mensajeCorreo = value;
  set fechaCorrespondenciaResidente(String? value) => _fechaCorrespondenciaResidente = value;
  set observacionesCorrespondenciaResidente(String? value) =>
      _observacionesCorrespondenciaResidente = value;
  set firmaCorrespondencia(String? value) => _firmaCorrespondencia = value!;

  // Método para convertir un JSON a un objeto Correspondencia
  factory CorrespondenciaModel.fromJson(Map<String, dynamic> json) {
    return CorrespondenciaModel(
      id: int.parse(json['id']),
      descripcion: json['descripcion'],
      foto: json['foto'],
      fecha:
          json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      residente: int.parse(json['residente']),
      vigilante: int.parse(json['vigilante']),
      mensajeWhatsapp: int.parse(json['mensaje_whatsapp']) ?? 0,
      mensajeCorreo: int.parse(json['mensaje_correo']) ?? 0,
      fechaCorrespondenciaResidente: json['fecha_entrega_residente'],
      observacionesCorrespondenciaResidente: json['observaciones_Correspondencia_residente'] ?? "",
      firmaCorrespondencia: json['firma_entrega'] ?? "",
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'descripcion': _descripcion,
      'foto': _foto,
      'fecha': _fecha?.toIso8601String(),
      'residente': _residente,
      'vigilante': _vigilante,
      'mensaje_whatsapp': _mensajeWhatsapp,
      'mensaje_correo': _mensajeCorreo,
      'fecha_Correspondencia_residente': _fechaCorrespondenciaResidente,
      'observaciones_Correspondencia_residente': _observacionesCorrespondenciaResidente,
      'firma_Correspondencia': _firmaCorrespondencia,
    };
  }
}
