import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Models/Usuario.dart';

class Profile extends StatefulWidget {
  Usuario? user;
  Profile({super.key, this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormFieldState> formKeyPhone = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> formKeyCorreo = GlobalKey<FormFieldState>();

  Usuario? user;
  bool loading = false;

  @override
  void initState() {
    phoneController = TextEditingController(
      text: widget.user!.telefono.toString(),
    );
    emailController = TextEditingController(
      text: widget.user!.correo.toString(),
    );

    user = widget.user;
    super.initState();
  }

  actualizarTelefono() async {
    await UsuarioController().actualizarTelefono(
      context,
      int.parse(user!.cedula),
      phoneController.text,
      emailController.text,
    );

    setState(() {
      user!.telefono = phoneController.text;
      user!.correo = emailController.text;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My perfil",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
     
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Icon(Icons.apartment_rounded, size: 100, color: Colors.grey),

              SizedBox(height: 10),

              Text(
                widget.user!.espacio,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: _buildProfileField(
                    Icons.badge,
                    widget.user!.nombre,
                    isEditable: false,
                  ),
                  leading: Icon(Icons.person),
                ),
              ),

              SizedBox(height: 30),

              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: _buildProfileField(
                    Icons.badge,
                    widget.user!.cedula,
                    isEditable: false,
                  ),
                  leading: Icon(Icons.badge_rounded),
                ),
              ),

              SizedBox(height: 30),

              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  trailing: Icon(Icons.edit),

                  title: _campoTelefono(
                    Icons.badge,
                    phoneController,
                    isEditable: true,
                  ),

                  leading: Icon(Icons.phone),
                ),
              ),

              SizedBox(height: 30),

              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  trailing: Icon(Icons.edit),
                  title: _campoCorreo(
                    Icons.badge,
                    emailController,
                    isEditable: true,
                  ),
                  leading: Icon(Icons.email),
                ),
              ),

              SizedBox(height: 20),


              botonGuardarCambios(),
            ],
          ),
        ),
      ),
    );
  }


//*METODO WIDGETS
  ElevatedButton botonGuardarCambios() {
    return ElevatedButton(
              onPressed: () async {
                // Acción de guardar cambios
                if (formKeyPhone.currentState!.validate() &&
                    formKeyCorreo.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });

                  await actualizarTelefono();
                } else {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Color del botón
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child:
                    loading
                        ? CircularProgressIndicator()
                        : Text(
                          "guardar cambios",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            );
  }

  Widget _buildProfileField(
    IconData icon,
    dynamic content, {
    bool isEditable = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: TextStyle(color: Colors.black54),
            enabled: isEditable,
            controller: TextEditingController(text: content),
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  Widget _campoTelefono(
    IconData icon,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number, // Teclado numérico
            inputFormatters: [
              FilteringTextInputFormatter.allow((RegExp(r'[0-9]'))),
            ],

            key: formKeyPhone,
            onSaved: (newValue) {},

            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'No puedes dejar el campo vacio';
              }
              if (value.length != value.replaceAll(' ', '').length) {
                return 'No debes dejar espacios';
              }

              if (value.length < 10) {
                return 'El campo debe tener 10 digitos';
              }
              return null;
            },
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) => SizedBox.shrink(),
            maxLength: 10,
            style: TextStyle(color: Colors.black54),
            enabled: isEditable,
            controller: controller,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _campoCorreo(
    IconData icon,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: formKeyCorreo,
            onSaved: (newValue) {},

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El correo es obligatorio';
              }

              // Expresión regular para validar correos electrónicos
              final RegExp emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );

              if (!emailRegex.hasMatch(value)) {
                return 'Ingrese un correo válido';
              }

              return null; // Retorna null si el correo es válido
            },
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) => SizedBox.shrink(),
            style: TextStyle(color: Colors.black54),
            enabled: isEditable,
            controller: controller,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
