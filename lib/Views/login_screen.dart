import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/logos_animados_desktop.dart';
import 'package:tecnovig/Utilities/responsive_layout.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/generador_codigo_digitos.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Utilities/ocultar_correo.dart';
import 'package:tecnovig/Views/desktop/valida_user_desktop.dart';
import 'package:tecnovig/Views/home_cliente_screen.dart';
import 'package:tecnovig/Models/usuario_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //? -------UTILS VIEWS ------> pageViewValidaUserMobile

  final _formKeyViewValidarUserMobile =
      GlobalKey<FormState>(); // valida textField de la vista ValidarUserMobile

  TextEditingController cedulaControllerTextField = TextEditingController(
    text: "",
  );

  //? -------UTILS VIEWS ------> pageViewLogginMobile

  LoginController loginController = LoginController();

  final _formKeyViewLogginMobile =
      GlobalKey<FormState>(); // valida textField de la vista loggin

  TextEditingController passwordLogginControllerTextField =
      TextEditingController(text: "");

  //? -------UTILS VIEWS ------> pageViewActivarCuentaMobile

  bool cuentaActivada = false;

  //? -------UTILS VIEWS ------> pageViewOlvidarPassword

  final _formKeyViewOlvidarPasswordEmail =
      GlobalKey<FormState>(); // valida textField de la vista OlvidarContraseña

  final _formKeyViewOlvidarPassword =
      GlobalKey<FormState>(); // valida textField de la vista OlvidarContraseña

  String? codigoRecuperacion = "";

  TextEditingController codigoRecuperacionControllerTextField =
      TextEditingController(text: "");

  TextEditingController newPasswordControllerTextField = TextEditingController(
    text: "",
  );

  TextEditingController confirmPasswordControllerTextField =
      TextEditingController(text: "");

  TextEditingController campoEmailControllerTextField = TextEditingController(
    text: "",
  );

  bool correoEnviado = false;

  bool ocultarConfirmPassword = false;

  //? -------UTILS VARIABLES SHARED ------> pageViewOlvidarPassword

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  UsuarioModel? user;

  bool loading = false;

  bool obscureText = false;

  double currentPage = 0.0;

  @override
  void initState() {
    codigoRecuperacion = generateCode();

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: logginViewResponsiveMOBILE(context),

      tabletBody: Scaffold(backgroundColor: Colors.red),
      //   desktopBody: Scaffold(backgroundColor: Colors.red),
      desktopBody: logginViewResponsiveDESKTOP(context),
    );
  }

  Scaffold logginViewResponsiveMOBILE(BuildContext context) {
    pageController = PageController(initialPage: currentPage.toInt());

    return Scaffold(
      backgroundColor: Color(0xff375CA6),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return pageViewValidaUserMobile(context);

              case 1:
                return pageViewLogginMobile(context);

              case 2:
                return pageViewActivarCuentaMobile(context);

              case 3:
                return pageViewOlvidarPassword(context);

              default:
                return SizedBox.fromSize();
            }
          },
        ),
      ),
    );
  }

  Scaffold logginViewResponsiveDESKTOP(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 67, 127),

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
              logosAnimadosLoginDesktop(),
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
                      controller: pageController,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return pageViewValidaUserDESKTOP();

                          case 1:
                            return pageViewLogginDESKTOP();

                          case 2:
                            return pageViewActivarCuentaDESKTOP();

                          case 3:
                            return pageViewRecuperarPasswordDESKTOP();

                          default:
                            return SizedBox.fromSize();
                        }
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

  // PAGES_VIEWS

  //?  pageViewValidaUserMobile ----------------------------------------------- INICIO -----------------------------------------------

  Column pageViewValidaUserMobile(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
          child: Image.asset("logoTecnoVigLogin.png"),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKeyViewValidarUserMobile,
              child: textFormFieldMOBILE(
                validator: validatorExistenciaUser,
                controller: cedulaControllerTextField,
                title: "campo cedula",
                //  hintText: "Digita tu numero de cedula",
                label: "Digita tu numero de cedula",

                obscureText: obscureText,
                prefixIcon: Icon(Icons.person),
                inputFormatters: true,
              ),
            ),

            bottomMOBILE(
              nameText: "Continuar",
              onPressed: () {
                validarUserExistenciaController();
              },
            ),
          ],
        ),
      ],
    );
  }

  void validarUserExistenciaController() async {
    if (_formKeyViewValidarUserMobile.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      dynamic result = await LoginController().validarExistenciaNewMethod(
        int.parse(cedulaControllerTextField.text),
        context,
      );

      if (result != null) {
        if (result["activarCuenta"] == "activarCuenta") {
          user = result["user"];
          pageController.jumpToPage(2);
          currentPage = 2;
        } else if (result["loggin"] == "loggin") {
          user = result["user"];

          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );
          currentPage = 1;
        } else {
          loading = false;
        }
      }

      loading = false;
    }

    setState(() {});
  }

  String? validatorExistenciaUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'La cedula no puede estar vacía';
    } else if (value.length < 10) {
      return 'ingresa una cedula valida';
    }
    return null; // Contraseña válida
  }

  //?  pageViewValidaUserMobile ----------------------------------------------- FIN -----------------------------------------------

  //?  pageViewLogginMobile ----------------------------------------------- INICIO -----------------------------------------------

  Column pageViewLogginMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(
          context,
          onPressed: () {
            pageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
            );
            currentPage = 0;

            setState(() {});
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
          child: Image.asset("logoTecnoVigLogin.png"),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                "Iniciar sesion",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            // textField(
            //   controller: passwordLogginControllerTextField,
            //   ejecucion: () {},
            //   label: "Digita tu contraseña",
            //   icono: Icons.lock,
            // ),
            Form(
              key: _formKeyViewLogginMobile,
              child: textFormFieldMOBILE(
                validator: validatorIniciarSesion,
                controller: passwordLogginControllerTextField,
                title: "campo cedula",
                //  hintText: "Digita tu numero de cedula",
                label: "Digita tu contraseña",
                suffixIcon: GestureDetector(
                  onTap:
                      () => setState(() {
                        obscureText = !(obscureText);
                      }),
                  child: Icon(
                    (obscureText) ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                obscureText: obscureText,
                prefixIcon: Icon(Icons.lock),
                inputFormatters: false,
              ),
            ),

            bottomMOBILE(
              nameText: "Iniciar",
              onPressed: () {
                iniciarSesionControllerMOBILE();
              },
            ),

            TextButton(
              onPressed: () {
                pageController.jumpToPage(3);
                currentPage = 3;
                setState(() {});
              },
              child: Text(
                "¿ Olvidaste la contraseña ?",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void iniciarSesionControllerMOBILE() async {
    if (_formKeyViewLogginMobile.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      await loginController.iniciarSesion(
        context,
        cedulaControllerTextField.text,
        passwordLogginControllerTextField.text,
      );

      setState(() {
        loading = false;
      });
    }
  }

  String? validatorIniciarSesion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    return null; // Contraseña válida
  }

  //?  pageViewLogginMobile ----------------------------------------------- FIN -----------------------------------------------

  //?  pageViewActivarCuentaMobile ----------------------------------------------- INICIO -----------------------------------------------

  Column pageViewActivarCuentaMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(
          context,
          title: "Activacion de cuenta",
          onPressed: () {
            pageController.jumpToPage(0);
            currentPage = 0;
            setState(() {});
          },
        ),

        cuentaActivada
            ? ListTile(
              title: Text(
                "Activacion exitosa",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Text(
                "Tu  cuenta ya está lista . \n Se han enviado tus credenciales de acceso al correo ${ocultarCorreo(user!.correo)}",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
            : ListTile(
              title: Text(
                "¡Activa tu cuenta ahora! ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Text(
                "Tu cuenta está casi lista. Solo falta un paso para comenzar a disfrutar de nuestros servicios. Presiona el botón a continuación para activar tu cuenta y acceder a todas las funcionalidades.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

        cuentaActivada
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bottomMOBILE(
                  nameText: "Inicia sesion",
                  onPressed: () {
                    currentPage = 1;
                    pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );

                    setState(() {});
                  },
                ),

                ListTile(
                  title: Text(
                    "   📩 ¿No recibiste el correo?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextButton(
                      onPressed: () async {
                        activarCuentaController();
                      },
                      child: Text(
                        " Revisa tu bandeja de spam o haz clic aquí para reenviar el mensaje.",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
            : bottomMOBILE(
              nameText: "Activar cuenta",
              onPressed: () {
                activarCuentaController();
              },
            ),
      ],
    );
  }

  void activarCuentaController() async {
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
        cuentaActivada = true;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });

      if (mounted) {
        mostrarMensaje(
          context,
          "Ocurrio un error en la consulta",
          color: Colors.red,
        );
      }
    }
  }

  //?  pageViewActivarCuentaMobile ----------------------------------------------- FIN -----------------------------------------------

  //?  pageViewOlvidarPasswordMOBILE ----------------------------------------------- INICIO -----------------------------------------------

  dynamic pageViewOlvidarPassword(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar(
            context,
            title: "Restablecer contraseña",
            onPressed: () {
              correoEnviado = false;
              codigoRecuperacionControllerTextField.clear();
              confirmPasswordControllerTextField.clear();
              newPasswordControllerTextField.clear();

              pageController.jumpToPage(1);
              currentPage = 1;
              setState(() {});
            },
          ),

          correoEnviado
              ?
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
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Por favor ingrese el codigo de recuperacion enviado a tu correo registrado y establece una nueva contraseña",
                          style: TextStyle(fontSize: 14, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKeyViewOlvidarPassword,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),

                          child: textFormFieldMOBILE(
                            title: "Codigo de recuperacion",
                            validator: validatorCodigoRecuperacion,
                            controller: codigoRecuperacionControllerTextField,
                            label: "Codigo de recuperacion",
                            obscureText: false,
                            prefixIcon: Icon(Icons.numbers),
                            inputFormatters: true,
                          ),
                        ),

                        SizedBox(height: 10),

                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),

                          child: textFormFieldMOBILE(
                            title: "Nueva Contraseña",
                            validator: validatorNewPassword,
                            controller: newPasswordControllerTextField,
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
                            label: "Nueva Contraseña",
                            obscureText: ocultarConfirmPassword,
                            prefixIcon: Icon(Icons.lock),
                            inputFormatters: false,
                          ),
                        ),

                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: textFormFieldMOBILE(
                            title: "Confirma Contraseña",
                            validator: validatorConfirmPassword,
                            controller: confirmPasswordControllerTextField,
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
                            label: "Confirma Contraseña",
                            obscureText: ocultarConfirmPassword,
                            prefixIcon: Icon(Icons.lock),
                            inputFormatters: false,
                          ),
                        ),

                        SizedBox(height: 15),

                        bottomMOBILE(
                          nameText: "Guardar nueva contraseña",
                          onPressed: () => guardarNuevaPassword(),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ListTile(
                      subtitle: Text(
                        "Por favor ingrese su direccion de correo electronico . le enviaremos un codigo para restablecer contraseña",
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKeyViewOlvidarPasswordEmail,
                    child: textFormFieldMOBILE(
                      validator: validatorEmail,
                      title: "Email",
                      controller: campoEmailControllerTextField,
                      label: "Email",
                      prefixIcon: Icon(Icons.email),
                      inputFormatters: false,
                      obscureText: false,
                    ),
                  ),

                  bottomMOBILE(
                    onPressed: () => enviarEnlaceDeRecuperacion(),

                    nameText: "Enviar enlace de recuperacion",
                  ),
                ],
              ),
        ],
      ),
    );
  }

  String? validatorNewPassword(String? value) {
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

  String? validatorConfirmPassword(String? value) {
    if (value != newPasswordControllerTextField.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo no puede estar vacío';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null; // Correo válido
  }

  String? validatorCodigoRecuperacion(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo  no puede estar vacío';
    } else if (value != codigoRecuperacion) {
      return 'El codigo que ingresaste  no coincide';
    }
    return null; // Correo válido
  }

  void guardarNuevaPassword() async {
    if (_formKeyViewOlvidarPassword.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      dynamic resul = await LoginController().recuperarPasswordNewMethod(
        context,
        int.parse(user!.cedula),
        confirmPasswordControllerTextField.text,
      );

      if (resul != null && resul == "200") {
        pageController.jumpToPage(1);
        currentPage = 1;
        codigoRecuperacionControllerTextField.clear();
        newPasswordControllerTextField.clear();
        confirmPasswordControllerTextField.clear();
        setState(() {});
      } else {}

      setState(() {
        loading = false;
      });
    } else {}
  }

  void enviarEnlaceDeRecuperacion() async {
    if (_formKeyViewOlvidarPasswordEmail.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await LoginController().validarCorreoDesktop(
        context,
        int.parse(user!.cedula),
        campoEmailControllerTextField.text,
        codigoRecuperacion,
      );

      if (result != null && result == "ok") {
        correoEnviado = true;
      }

      setState(() {
        loading = false;
      });
    }
  }

  //?  pageViewOlvidarPasswordMOBILE ----------------------------------------------- FIN -----------------------------------------------

  //*DESKTOP

  //?  pageViewValidaUserDESKTOP ----------------------------------------------- INICIO  -----------------------------------------------

  SizedBox pageViewValidaUserDESKTOP() {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("logoTecnoVig2.png", width: 300),

          Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 50),

            child: Form(
              key: _formKeyViewValidarUserMobile,
              child: textFormFieldDESKTOP(
                validator: validatorExistenciaUser,
                title: "campoCedula",
                inputFormatters: true,
                hintText: "Ingresa tu número de cedula",
                controller: cedulaControllerTextField,
                prefixIcon: Icon(Icons.person, color: Colors.black54),
                obscureText: false,
              ),
            ),
          ),

          bottomDESKTOP(
            nameText: "Continuar",
            onPressed: () async {
              validarUserExistenciaController();
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

  //?  pageViewValidaUserDESKTOP ----------------------------------------------- FIN  -----------------------------------------------

  //?  pageViewLogginUserDESKTOP ---------------------------------------------- INICIO  -----------------------------------------------

  SizedBox pageViewLogginDESKTOP() {
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
                  pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );

                  setState(() {
                    currentPage = 0;
                  });
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

                child: Form(
                  key: _formKeyViewLogginMobile,
                  child: textFormFieldDESKTOP(
                    title: "campoContraseña",
                    inputFormatters: false,
                    hintText: "Ingresa tu contraseña",
                    controller: passwordLogginControllerTextField,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap:
                          () => setState(() {
                            obscureText = !obscureText;
                          }),
                      child: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    obscureText: obscureText,
                  ),
                ),
              ),
              bottomDESKTOP(
                nameText: "Iniciar",
                onPressed: () {
                  iniciarSesionControllerMOBILE();
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    pageController.jumpToPage(3);
                    currentPage = 3;
                    setState(() {});
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

  //?  pageViewLogginUserDESKTOP ----------------------------------------- FIN  -----------------------------------------------

  //?  pageViewActivarCuentaDESKTOP ------------------------------------ INICIO  -----------------------------------------------

  SizedBox pageViewActivarCuentaDESKTOP() {
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
                      currentPage = 1;
                      pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );

                      setState(() {});
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
                    cuentaActivada
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
              cuentaActivada
                  ? bottomDESKTOP(
                    onPressed: () async {
                      pageController.jumpToPage(1);
                      currentPage = 1;
                      setState(() {});
                    },
                    nameText: "Iniciar sesion",
                  )
                  : bottomDESKTOP(
                    onPressed: () async {
                      activarCuentaController();
                    },
                    nameText: "Activar",
                  ),
              SizedBox(height: 14),

              cuentaActivada
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
                          activarCuentaController();
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
    );
  }

  //?  pageViewActivarCuentaDESKTOP ------------------------------- FIN  -----------------------------------------------

  //?  pageViewOlvidarPasswordDESKTOP ----------------------------------------------- INICIO -----------------------------------------------

  pageViewRecuperarPasswordDESKTOP() {
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
                        pageController.jumpTo(1);
                        currentPage = 1;

                        correoEnviado = false;
                        setState(() {});
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

            !correoEnviado
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

                      child: Form(
                        key: _formKeyViewOlvidarPasswordEmail,
                        child: textFormFieldDESKTOP(
                          validator: validatorEmail,
                          title: "Email",
                          controller: campoEmailControllerTextField,
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                          inputFormatters: false,
                          obscureText: false,
                        ),
                      ),
                    ),

                    bottomDESKTOP(
                      onPressed: ()  {


                      enviarEnlaceDeRecuperacion();
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
                      key: _formKeyViewOlvidarPassword,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 0),

                            child: textFormFieldDESKTOP(
                              validator: validatorCodigoRecuperacion,
                              controller: codigoRecuperacionControllerTextField,
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

                            child: textFormFieldDESKTOP(
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
                              validator: validatorNewPassword,
                              controller: newPasswordControllerTextField,
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
                            child: textFormFieldDESKTOP(
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
                              validator: validatorConfirmPassword,
                              controller: confirmPasswordControllerTextField,
                              title: "Confirma Contraseña",
                              hintText: "Confirma Contraseña",
                              obscureText: ocultarConfirmPassword,
                              prefixIcon: Icon(Icons.lock),
                              inputFormatters: false,
                            ),
                          ),

                          SizedBox(height: 15),

                          bottomDESKTOP(
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
    );
  }

  //?  pageViewOlvidarPasswordDESKTOP ----------------------------------------------- FIN -----------------------------------------------



  //*METODOS WIDGETS

  Padding appBar(BuildContext context, {String? title, Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            splashRadius: 30,
            onPressed: onPressed,
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          ),

          Text(title ?? "", style: TextStyle(color: Colors.white)),
          Text(""),
        ],
      ),
    );
  }

  Padding textFormFieldMOBILE({
    required bool inputFormatters,
    String? hintText,
    String? title,
    String? label,
    TextEditingController? controller,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    bool? obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.grey[200]),
        obscureText: obscureText!,
        validator: validator,
        inputFormatters:
            inputFormatters
                ? [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))]
                : [],
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: prefixIcon,
          label: Text(label ?? ""),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  TextFormField textFormFieldDESKTOP({
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

  //Utils Buttoms

  Padding bottomMOBILE({String? nameText, required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed:loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: myTheme.primaryColor, // Color de fondo rojo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
            ),
          ),
          child:
              loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                    nameText ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
        ),
      ),
    );
  }

  Padding bottomDESKTOP({String? nameText, required Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed:loading ? null : onPressed,
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
}
