import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

class RecuperarContrasena extends StatefulWidget {
  final String? correo;
  final String? codigoRecuperacion;
  final String? cedula;

  const RecuperarContrasena({
    super.key,
    required this.correo,
    this.codigoRecuperacion,
    required this.cedula,
  });

  @override
  State<RecuperarContrasena> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validateCodigoRecuperacionController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool loading = false;
  bool mostrar = true;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    if (value.length < 8) {
      return 'Debe tener al menos 8 caracteres';
    }
    // if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    //   return 'Debe contener al menos una letra mayúscula';
    // }
    // if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    //   return 'Debe contener al menos una letra minúscula';
    // }
    // if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    //   return 'Debe contener al menos un número';
    // }
    // if (!RegExp(r'(?=.*[@\$!%*?&])').hasMatch(value)) {
    //   return 'Debe contener al menos un carácter especial (@\$!%*?&)';
    // }
    if (['123456', 'password', 'admin'].contains(value)) {
      return 'La contraseña es demasiado común';
    }

    return null;
  }

  String? _validateCodigoRecuperacion(String? value) {
    if (value != widget.codigoRecuperacion) {
      return 'El codigo que ingresaste  no coincide';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Text(
                "Cambio de contraseña",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Text(
                "para , ${widget.correo}",
                style: TextStyle(color: Colors.white),
              ),
            ),

            ListTile(
              subtitle: Text(
                "Por favor, ingresa el código de recuperación enviado a tu correo y establece una nueva contraseña para tu cuenta ",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _validateCodigoRecuperacionController,

                      //   obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers, color: Colors.black54),
                        labelStyle: TextStyle(color: Colors.white60),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        labelText: 'Codigo de recuperacion',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateCodigoRecuperacion,
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: mostrar,
                      controller: _passwordController,
                      //obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              mostrar = !mostrar;
                            });
                          },
                          child: Icon(
                            !mostrar ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),

                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                        labelStyle: TextStyle(color: Colors.white60),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'Nueva contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: mostrar,
                      controller: _confirmPasswordController,
                      //obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              mostrar = !mostrar;
                            });
                          },
                          child: Icon(
                            !mostrar ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),

                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                        labelStyle: TextStyle(color: Colors.white60),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'Confirma contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateConfirmPassword,
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color?>(
                            myTheme.primaryColor,
                          ),
                          shape: WidgetStatePropertyAll<OutlinedBorder?>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ), // Borde redondeado
                              //  side: BorderSide(color: Colors.red, width: 2), // Color y grosor del borde
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            await LoginController()
                                .recuperarPassword(
                                  context,
                                  int.parse(widget.cedula!),
                                  _passwordController.text,
                                )
                                .whenComplete(() {
                                  setState(() {
                                    loading = true;
                                  });
                                });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                              loading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    "Guardar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
