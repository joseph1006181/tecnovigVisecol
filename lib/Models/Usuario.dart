class Usuario {
  
  int _id;
  DateTime _fechaCreacion;
  String _espacio;
  String _nombre;
  String _cedula;
  String _telefono;
  String _correo;
  int _cliente;
  String _estado;
  int _usuario;
  int _area;
  int _tipo;
  int _salidaPeatonal;
  int _vehiculoHabilitado;
  String _password;
  int? _contactoWhatsapp;
  int? _contactoWhatsappEnviado;
  String? _contactoWhatsappFecha;
  int? _contactoCorreo;
  int? _contactoCorreoEnviado;
  String? _contactoCorreoFecha;













 set contactoWhatsapp( value) => this._contactoWhatsapp = value;


 set contactoWhatsappEnviado( value) => this._contactoWhatsappEnviado = value;


 set contactoWhatsappFecha( value) => this._contactoWhatsappFecha = value;


 set contactoCorreo( value) => this._contactoCorreo = value;


 set contactoCorreoEnviado( value) => this._contactoCorreoEnviado = value;


 set contactoCorreoFecha( value) => this._contactoCorreoFecha = value;
 



  Usuario({
    required int id,
    required DateTime fechaCreacion,
    required String espacio,
    required String nombre,
    required String cedula,
    required String telefono,
    required String correo,
    required int cliente,
    required String estado,
    required int usuario,
    required int area,
    required int tipo,
    required int salidaPeatonal,
    required int vehiculoHabilitado,
    required String password,
    required int? contactoWhatsapp,
    required int? contactoWhatsappEnviado,
    required String? contactoWhatsappFecha,
    required int?   contactoCorreo,
    required int? contactoCorreoEnviado,
    required String? contactoCorreoFecha,
  })  : _id = id,
        _fechaCreacion = fechaCreacion,
        _espacio = espacio,
        _nombre = nombre,
        _cedula = cedula,
        _telefono = telefono,
        _correo = correo,
        _cliente = cliente,
        _estado = estado,
        _usuario = usuario,
        _area = area,
        _tipo = tipo,
        _salidaPeatonal = salidaPeatonal,
        _vehiculoHabilitado = vehiculoHabilitado,
        _password = password,
        _contactoWhatsapp = contactoWhatsapp,
        _contactoWhatsappEnviado =contactoWhatsappEnviado ,
        _contactoWhatsappFecha =  contactoWhatsappFecha,
        _contactoCorreo =    contactoCorreo,
        _contactoCorreoEnviado = contactoCorreoEnviado,
        _contactoCorreoFecha = contactoCorreoFecha;
  // Getters
  int get id => _id;
  DateTime get fechaCreacion => _fechaCreacion;
  String get espacio => _espacio;
  String get nombre => _nombre;
  String get cedula => _cedula;
  String get telefono => _telefono;
  String get correo => _correo;
  int get cliente => _cliente;
  String get estado => _estado;
  int get usuario => _usuario;
  int get area => _area;
  int get tipo => _tipo;
  int get salidaPeatonal => _salidaPeatonal;
  int get vehiculoHabilitado => _vehiculoHabilitado;
  String get password => _password;

  
   int? get contactoWhatsapp => _contactoWhatsapp;
  get contactoWhatsappEnviado => _contactoWhatsappEnviado;
  get contactoWhatsappFecha => _contactoWhatsappFecha;
  get contactoCorreo => _contactoCorreo;
  get contactoCorreoEnviado =>_contactoCorreoEnviado;
  get contactoCorreoFecha => _contactoCorreoFecha;













  // Setters
  set id(int value) => _id = value;
  set fechaCreacion(DateTime value) => _fechaCreacion = value;
  set espacio(String value) => _espacio = value;
  set nombre(String value) => _nombre = value;
  set cedula(String value) => _cedula = value;
  set telefono(String value) => _telefono = value;
  set correo(String value) => _correo = value;
  set cliente(int value) => _cliente = value;
  set estado(String value) => _estado = value;
  set usuario(int value) => _usuario = value;
  set area(int value) => _area = value;
  set tipo(int value) => _tipo = value;
  set salidaPeatonal(int value) => _salidaPeatonal = value;
  set vehiculoHabilitado(int value) => _vehiculoHabilitado = value;
  set password(String value) => _password = value;



  // Convertir de JSON a objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {



//   print(int.parse(json['contacto_whatsapp']));
//      print(int.parse(json['contacto_whatsapp_enviado']));
//   print( json['contacto_whatsapp_fecha']);
//  print(int.parse(json['contacto_correo']));
//      print(int.parse(json['contacto_correo_enviado']));
//      print(json['contacto_correo_fecha']??"dd");
    
       








    return Usuario(
      id: int.parse(json['id']),
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      espacio: json['espacio'],
      nombre: json['nombre'],
      cedula: json['cedula'],
      telefono: json['telefono'],
      correo: json['correo'],
      cliente: int.parse(json['cliente']),
      estado: json['estado'],
      usuario: int.parse(json['usuario']),
      area: int.parse(json['area']),
      tipo: int.parse(json['tipo']),
      salidaPeatonal: int.parse(json['salida_peatonal']),
      vehiculoHabilitado: int.parse(json['vehiculo_habilitado']),
      password: json['password'],
      contactoWhatsapp:  int.parse(json['contacto_whatsapp']),
      contactoWhatsappEnviado:  int.parse(json['contacto_whatsapp_enviado']),
      contactoWhatsappFecha: json['contacto_whatsapp_fecha']??"",
      contactoCorreo: int.parse(json['contacto_correo']),
      contactoCorreoEnviado: int.parse(json['contacto_correo_enviado']),
      contactoCorreoFecha:  json['contacto_correo_fecha']?? "",

    );
  }

  // Convertir de objeto Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'fecha_creacion': _fechaCreacion.toIso8601String(),
      'espacio': _espacio,
      'nombre': _nombre,
      'cedula': _cedula,
      'telefono': _telefono,
      'correo': _correo,
      'cliente': _cliente,
      'estado': _estado,
      'usuario': _usuario,
      'area': _area,
      'tipo': _tipo,
      'salida_peatonal': _salidaPeatonal,
      'vehiculo_habilitado': _vehiculoHabilitado,
      'password': _password,
    };
  }
}
