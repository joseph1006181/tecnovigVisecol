import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';


class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  TextEditingController campoCedula = TextEditingController(text: "");
  TextEditingController codigoRecuperacionEditing = TextEditingController(
    text: "",
  );

  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirmPassword = TextEditingController(text: "");
  TextEditingController email = TextEditingController(text: "");
  final _formKeyRecuperarPassword = GlobalKey<FormState>();

  UsuarioModel? user;
  bool loading = false;
  bool ocultarPassword = false;
  bool ocultarConfirmPassword = true;

  bool activacionCuenta = false;

  String? codigoRecuperacion = "12456";

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF375CA6), // #375CA6
              Color(0xFF53518C), // #53518C
              Color(0xFFA63856), // #A63856
              Color(0xFFD93644), // #D93644F
              // Color(0xFFD93644), // #D93644
              // Color(0xFFA63856), // #A63856
              // Color(0xFF53518C), // #53518C
              // Color(0xFF375CA6), // #375CA6
            ],
            stops: [0.0, 0.3, 0.6, 1.0], // Define el rango del gradiente
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              logosAnimados(),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(150, 60, 60, 60),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 13,
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,

                      itemBuilder: (context, index) {
                        return index == 0
                            ? page1ValidarUser()
                            : index == 1
                            ? page2Loggin()
                            : index == 2
                            ? page3ActivarCuenta()
                            : page4RecuperarPassword();
                      },
                    ),
                  ).animate().slide(
                    begin: Offset(
                      2.0,
                      0,
                    ), // Comienza bien fuera de la pantalla a la izquierda
                    end: Offset(0.0, 0), // Llega a su posición normal
                    duration: 800.ms, // Duración de la animación
                    curve: Curves.decelerate,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //*METODOS WIDGEST

  SizedBox page1ValidarUser() {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("logoTecnoVig2.png", width: 300),

          Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 50),

            child: campoTexto(
              title: "campoCedula",
              inputFormatters: true,
              hintText: "Ingresa tu número de cedula",
              controller: campoCedula,
              prefixIcon: Icon(Icons.person, color: Colors.black54),
              obscureText: false,
            ),
          ),

          boton(
            nameText: "Continuar",
            onPressed: () async {
              validarExistenciaDesktop();
            },
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   color: Colors.grey[300],
      // ),
    );
  }

  SizedBox page2Loggin() {
    return SizedBox(
      height: double.maxFinite,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("logoTecnoVig2.png", width: 300),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Iniciar sesion"),
              ),
              Padding(
                padding: EdgeInsets.all(50),

                child: campoTexto(
                  title: "campoContraseña",
                  inputFormatters: false,
                  hintText: "Ingresa tu contraseña",
                  controller: password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap:
                        () => setState(() {
                          ocultarPassword = !ocultarPassword;
                        }),
                    child: Icon(
                      ocultarPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  obscureText: ocultarPassword,
                ),
              ),

              boton(nameText: "Iniciar", onPressed: () {


                     iniciarSesion();






              }),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(3);
                  },
                  child: Text(
                    "¿ Olvidaste la contraseña ?",
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   color: Colors.grey[300],
      // ),
    );
  }

  SizedBox page3ActivarCuenta() {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _pageController.jumpTo(0);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black54,
                    ),
                  ),

                  Text(
                    "Activacion de cuenta",
                    style: TextStyle(
                      fontSize: 18,
                      color: myTheme.textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  SizedBox(width: 10),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child:
                    activacionCuenta
                        ? ListTile(
                          title: Text(
                            "Activacion exitosa",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            "Tu  cuenta ya está lista . \n Se han enviado tus credenciales de acceso al correo ${ocultarCorreo(user!.correo)}",
                            style: TextStyle(
                              color: Colors.black45,

                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                        : ListTile(
                          title: Text(
                            "¡Activa tu cuenta ahora! ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          subtitle: Text(
                            "Tu cuenta está casi lista. Solo falta un paso para comenzar a disfrutar de nuestros servicios. Presiona el botón a continuación para activar tu cuenta y acceder a todas las funcionalidades.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
              ),
              SizedBox(height: 10),
              activacionCuenta
                  ? boton(
                    onPressed: () async {
                      _pageController.jumpToPage(0);
                    },
                    nameText: "Iniciar sesion",
                  )
                  : boton(
                    onPressed: () async {
                      activarCuenta();
                    },
                    nameText: "Activar",
                  ),
              SizedBox(height: 14),

              activacionCuenta
                  ? ListTile(
                    title: Text(
                      "   📩 ¿No recibiste el correo?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextButton(
                        onPressed: () async {
                          activarCuenta();
                        },
                        child: Text(
                          " Revisa tu bandeja de spam o haz clic aquí para reenviar el mensaje.",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   color: Colors.grey[300],
      // ),
    );
  }

  SizedBox page4RecuperarPassword() {
    return SizedBox(
      height: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32.0, 32, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _pageController.jumpTo(0);


                        activacionCuenta = false;
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black54,
                      ),
                    ),

                    Text(
                      "Restablecer contraseña",
                      style: TextStyle(
                        fontSize: 18,
                        color: myTheme.textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),

            !activacionCuenta
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: ListTile(
                        // title: Text(
                        //   "Restablecimiento",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.black54,
                        //     fontWeight: FontWeight.normal,
                        //   ),
                        // ),
                        subtitle: Text(
                          "Por favor ingrese su direccion de correo electronico . le enviaremos un codigo para restablecer contraseña",
                          style: TextStyle(fontSize: 14, color: Colors.black45),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(50),

                      child: campoTexto(
                        title: "Email",
                        controller: email,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        inputFormatters: false,
                        obscureText: false,
                      ),
                    ),

                    boton(
                      onPressed: () async {
                        validarCorreo();
                      },
                      nameText: "Enviar enlace de recuperacion",
                    ),
                  ],
                )
                :
                //esta vista se muestra al enviar el codigo de recuperacion
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: ListTile(
                        title: Text(
                          "Restablecimiento  de contraseña para , ${user != null ? user!.correo : ""}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Por favor ingrese el codigo de recuperacion enviado a tu correo registrado y establece una nueva contraseña",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKeyRecuperarPassword,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 0),

                            child: campoTexto(
                              validator: _validateCodigoRecuperacion,
                              controller: codigoRecuperacionEditing,
                              title: "Codigo de recuperacion",
                              hintText: "Codigo de recuperacion",
                              obscureText: false,
                              prefixIcon: Icon(Icons.numbers),
                              inputFormatters: true,
                            ),
                          ),

                          SizedBox(height: 10),

                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 0),

                            child: campoTexto(
                              suffixIcon: GestureDetector(
                                onTap:
                                    () => setState(() {
                                      ocultarConfirmPassword =
                                          !ocultarConfirmPassword;
                                    }),
                                child: Icon(
                                  !ocultarConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              validator: _validatePassword,
                              controller: password,
                              title: "Nueva Contraseña",
                              hintText: "Nueva Contraseña",
                              obscureText: ocultarConfirmPassword,
                              prefixIcon: Icon(Icons.lock),
                              inputFormatters: false,
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                            child: campoTexto(
                              suffixIcon: GestureDetector(
                                onTap:
                                    () => setState(() {
                                      ocultarConfirmPassword =
                                          !ocultarConfirmPassword;
                                    }),
                                child: Icon(
                                  !ocultarConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              validator: _validateConfirmPassword,
                              controller: confirmPassword,
                              title: "Confirma Contraseña",
                              hintText: "Confirma Contraseña",
                              obscureText: ocultarConfirmPassword,
                              prefixIcon: Icon(Icons.lock),
                              inputFormatters: false,
                            ),
                          ),

                          SizedBox(height: 15),

                          boton(
                            nameText: "Guardar nueva contraseña",
                            onPressed: () {
                              guardarNuevaPassword();
                            },
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(30),
      //   color: Colors.grey[300],
      // ),
    );
  }

  Padding boton({String? nameText, required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Color de fondo rojo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
            ),
          ),
          child:
              loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                    nameText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }

  dynamic campoTexto({
    required bool inputFormatters,
    String? hintText,
    String? title,
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText!,
      inputFormatters:
          inputFormatters
              ? [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))]
              : [],
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey), // Color del hint text
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        // Ícono de usuario
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
          borderSide: BorderSide(color: Colors.red, width: 1.5), // Borde rojo
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ), // Borde más grueso al enfocar
        ),
      ),
    );
  }

  Expanded logosAnimados() {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Animate(
            effects: [
              SlideEffect(
                begin: Offset(
                  -2.0,
                  0,
                ), // Comienza bien fuera de la pantalla a la izquierda
                end: Offset(0.0, 0), // Llega a su posición normal
                duration: 800.ms, // Duración de la animación
                curve: Curves.decelerate,
              ),
            ], // Movimiento desacelerado al final)],

            child: Image.asset("logoTecnoVigLogin.png", width: 300),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50, left: 50),
              child: Image.asset(
                    "logoRedondo.png",
                  ) //  .animate(onPlay:   (controller) => controller.repeat())
                  .animate()
                  // .fadeIn(
                  //   duration: 1.seconds,
                  //   delay: Duration(milliseconds: 300),
                  // )
                  .scale(duration: 800.ms, delay: Duration(milliseconds: 300))
                  .rotate(
                    begin: 0,
                    end: 1,
                    duration: 5.seconds,
                    curve: Curves.linear,
                  )
                  .swap(
                    // Usa swap para iniciar una animación infinita después
                    builder:
                        (context, child) => child!.animate(
                          effects: [
                            RotateEffect(
                              begin: 0,
                              end: 1,
                              duration: 5.seconds,
                              curve: Curves.linear,
                            ),
                          ],
                          onPlay:
                              (controller) =>
                                  controller
                                      .repeat(), // Hace que la rotación se repita
                        ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  //*METODOS LOGICOS

  validarExistenciaDesktop() async {
    if (campoCedula.text.trim().isNotEmpty) {
      setState(() {
        loading = true;
      });

      dynamic result = await LoginController().validarExistenciaDesktop(
        int.parse(campoCedula.text),
        context,
      );

      if (result["activarCuenta"] == "activarCuenta") {
        user = result["user"];
        _pageController.jumpToPage(2);
      }

      if (result["loggin"] == "loggin") {
        user = result["user"];

        _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 600),
          curve: Curves.decelerate,
        );
      }

      if (result["loggin"] != "loggin" ||
          result["activarCuenta"] != "activarCuenta") {
        loading = false;
      }
    } else {
      mostrarMensaje(
        color: Colors.grey[800],
        context,
        "No puedes dejar el campo vacio",
      );
    }

    setState(() {});
  }

  void activarCuenta() async {
    setState(() {
      loading = true;
    });

    dynamic resul = await LoginController().activarCuenta(
      context,

      int.parse(user!.cedula),
      user!.nombre,
      user!.correo,
    );
    if (resul == "200") {
      setState(() {
        activacionCuenta = true;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });

      if(mounted){


        mostrarMensaje(
        context,
        "Ocurrio un error en la consulta",
        color: Colors.red,
      );
      }
    }
  }

  String ocultarCorreo(String correo) {
    List<String> partes = correo.split('@');
    if (partes.length != 2) return correo; // Validación básica

    String usuario = partes[0];
    String dominio = partes[1];

    // Dejar visibles las primeras dos letras y ocultar el resto con '*'
    String usuarioOculto =
        usuario.length > 2
            ? usuario.substring(0, 2) + '*' * (usuario.length - 2)
            : usuario;

    return '$usuarioOculto@$dominio';
  }

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
 
    if (value != codigoRecuperacion) {
      return 'El codigo que ingresaste  no coincide';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != password.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void validarCorreo() async {
    if (email.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

   dynamic result =    await LoginController()
          .validarCorreoDesktop(
            context,
            int.parse("1006181610"),
            email.text,
            "codigoRecuperacion",
          );


if (result != null && result != "ok") {
  
activacionCuenta = true;

  
} else {
activacionCuenta = true;
  
}

      setState(() {  loading = false; });


          // .whenComplete(() {
          //   setState(() {
          //     loading = false;
          //   });
          // });

    } else {
      mostrarMensaje(
        context,
        "no puedes dejar el campo Email vacio",
        color: Colors.grey[800],
      );
    }
  }

  void guardarNuevaPassword() async {
    if (_formKeyRecuperarPassword.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      await LoginController()
          .recuperarPassword(
            context,
            int.parse(user!.cedula),
            confirmPassword.text,
          )
          .whenComplete(() {
            setState(() {
              loading = false;
            });
          });
    } else {}
  }
  
  void iniciarSesion() async {

if (password.text.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });

                        await LoginController().iniciarSesion(
                          context,
                          user!.cedula,
                          password.text,
                        );

                        setState(() {
                          loading = false;
                        });
                      } else {
                        mostrarMensaje(
                          context,
                          "No puedes dejar campos vacios",
                          color: Colors.red,
                        );
                      }





  }
}
