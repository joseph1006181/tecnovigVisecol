import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/CONST/mitheme.dart';
import 'package:tecnovig/Utilities/VALIDATORS/validator.dart';
import 'package:tecnovig/Views/%F0%9F%94%90%20Login/Widgets/app_bar.dart';
import 'package:tecnovig/Views/%F0%9F%94%90%20Login/Widgets/logos_animados_desktop.dart';
import 'package:tecnovig/Views/%F0%9F%94%90%20Login/Widgets/text_form_field_desktop.dart';
import 'package:tecnovig/Views/%F0%9F%94%90%20Login/Widgets/text_form_field_mobile.dart';
import 'package:tecnovig/Utilities/Widgets/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/generador_codigo_digitos.dart';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Utilities/ocultar_correo.dart';
import 'package:tecnovig/Models/usuario_model.dart';
import 'package:tecnovig/Utilities/Widgets/buttons/primary_button.desktop.dart'
    show PrimaryButtonDesktop;

import 'package:tecnovig/Utilities/Widgets/buttons/primary_button_mobile.dart';

import '../../Utilities/Widgets/responsive_layout.dart';

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

 // String? codigoRecuperacion = "";

  TextEditingController codigoRecuperacionControllerTextField =
      TextEditingController(text: "");

  TextEditingController newPasswordControllerTextField = TextEditingController(
    text: "",
  );

  TextEditingController confirmPasswordControllerTextField =
      TextEditingController(text: "");

  TextEditingController emailControllerTextField = TextEditingController(
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

  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController(
      initialPage: currentPage.toInt(),
      keepPage: true,
    );
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
      mobileBody: logginViewResponsiveMOBILE(context, pageController),

      tabletBody: logginViewResponsiveMOBILE(context, pageController),

      desktopBody: logginViewResponsiveDESKTOP(context),
    );
  }


  Scaffold logginViewResponsiveMOBILE(
    BuildContext context,
    PageController pageControllerMOBILE,
  ) {
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
                return pageViewOlvidarPasswordMobile(context);

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

  //?--------------------------------------  pageViewValidaUserMobile ----------------------------------------------- 
  Widget pageViewValidaUserMobile(BuildContext context) {
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
                validator: Validators.validatorCedula,
                controller: cedulaControllerTextField,
                title: "campo cedula",
                label: "Digita tu numero de cedula",
                obscureText: obscureText,
                prefixIcon: Icon(Icons.person),
                inputFormatters: true,
              ),
            ),

            PrimaryButtonMobile(
              loading: loading,
              text: "Continuar",
              onPressed: () {
                validarExistenciaController();
              },
            ),
          ],
        ),
      ],
    );
  }



  //? --------------------------------------- pageViewLogginMobile ----------------------------------------------- 
  Widget pageViewLogginMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(
          context,
          onPressed: () {
            goToPageView(0, animated: true);
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

            Form(
              key: _formKeyViewLogginMobile,
              child: textFormFieldMOBILE(
                validator: Validators.isNotEmpty,
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

            PrimaryButtonMobile(
              loading: loading,
              text: "Iniciar",
              onPressed: () {
                iniciarSesionController();
              },
            ),

            TextButton(
              onPressed: () {
                goToPageView(3, animated: false);
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



  //? ---------------------------------------- pageViewActivarCuentaMobile ----------------------------------------

    Widget pageViewActivarCuentaMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBar(
          context,
          title: "Activacion de cuenta",
          onPressed: () {
            goToPageView(0, animated: false);
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
                PrimaryButtonMobile(
                  loading: loading,
                  text: "Inicia sesion",
                  onPressed: () {
                    goToPageView(1, animated: true);
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
            : PrimaryButtonMobile(
              loading: loading,
              text: "Activar cuenta",
              onPressed: () {
                activarCuentaController();
              },
            ),
      ],
    );
  }

 



  //? ------------------------------------------ pageViewOlvidarPasswordMOBILE -------------------------------------- 

  Widget pageViewOlvidarPasswordMobile(BuildContext context) {
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

              goToPageView(1, animated: false);
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
                            validator:
                                (value) =>
                                    Validators.isNotEmpty(
                                      value,
                                    ),
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
                            validator: Validators.isPasswordValid,
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
                            validator:
                                (value) => Validators.confirmPassword(
                                  value,
                                  newPasswordControllerTextField.text,
                                ),
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

                        PrimaryButtonMobile(
                          loading: loading,
                          text: "Guardar nueva contraseña",
                          onPressed: () => savePassword(),
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
                      validator: Validators.isEmail,
                      title: "Email",
                      controller: emailControllerTextField,
                      label: "Email",
                      prefixIcon: Icon(Icons.email),
                      inputFormatters: false,
                      obscureText: false,
                    ),
                  ),

                  PrimaryButtonMobile(
                    loading: loading,
                    onPressed: () => enviarEnlaceDeRecuperacion(),

                    text: "Enviar enlace de recuperacion",
                  ),
                ],
              ),
        ],
      ),
    );
  }



  //? ------------------------------------------- pageViewValidaUserDESKTOP -----------------------------------------

  Widget pageViewValidaUserDESKTOP() {
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
                validator: Validators.validatorCedula,
                title: "campoCedula",
                inputFormatters: true,
                hintText: "Ingresa tu número de cedula",
                controller: cedulaControllerTextField,
                prefixIcon: Icon(Icons.person, color: Colors.black54),
                obscureText: false,
              ),
            ),
          ),

          PrimaryButtonDesktop(
            loading: loading,
            text: "Continuar",
            onPressed: () async {
              validarExistenciaController();
            },
          ),
        ],
      ),
    );
  }

  
  //? ------------------------------------------- pageViewLogginUserDESKTOP ------------------------------------------

  Widget pageViewLogginDESKTOP() {
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
                  goToPageView(0, animated: true);
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
              PrimaryButtonDesktop(
                loading: loading,
                text: "Iniciar",
                onPressed: () {
                  iniciarSesionController();
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    goToPageView(3, animated: false);
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
    );
  }



  //?  --------------------------------------------pageViewActivarCuentaDESKTOP ------------------------------------ 

  Widget pageViewActivarCuentaDESKTOP() {
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
                      goToPageView(1, animated: true);
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
                  ? PrimaryButtonDesktop(
                    loading: loading,

                    onPressed: () async {
                      goToPageView(1, animated: false);
                    },
                    text: "Iniciar sesion",
                  )
                  : PrimaryButtonDesktop(
                    loading: loading,
                    onPressed: () async {
                      activarCuentaController();
                    },
                    text: "Activar",
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


  //?  --------------------------------------------pageViewOlvidarPasswordDESKTOP -----------------------------
 Widget pageViewRecuperarPasswordDESKTOP() {
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
                        correoEnviado = false;
                        goToPageView(1, animated: false);
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
                          validator: Validators.isEmail,
                          title: "Email",
                          controller: emailControllerTextField,
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                          inputFormatters: false,
                          obscureText: false,
                        ),
                      ),
                    ),

                    PrimaryButtonDesktop(
                      loading: loading,
                      onPressed: () => enviarEnlaceDeRecuperacion(),
                      text: "Enviar enlace de recuperacion",
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
                              validator:
                                  (value) =>
                                      Validators.isNotEmpty(
                                        value,
                                      ),

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
                              validator: Validators.isPasswordValid,
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
                              validator:
                                  (value) => Validators.confirmPassword(
                                    value,
                                    newPasswordControllerTextField.text,
                                  ),

                              controller: confirmPasswordControllerTextField,
                              title: "Confirma Contraseña",
                              hintText: "Confirma Contraseña",
                              obscureText: ocultarConfirmPassword,
                              prefixIcon: Icon(Icons.lock),
                              inputFormatters: false,
                            ),
                          ),

                          SizedBox(height: 15),

                          PrimaryButtonDesktop(
                            loading: loading,
                            text: "Guardar nueva contraseña",
                            onPressed: () {
                              savePassword();
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



  //        *METHODS

  void activarCuentaController() async {
    activarLoading();

    dynamic resul = await LoginController().activarCuenta(
      context,
      int.parse(user!.cedula),
      user!.nombre,
      user!.correo,
    );

    if (resul == "200") {
      setState(() {
        cuentaActivada = true;
      });
    } else {
      if (mounted) {
        mostrarMensaje(
          context,
          "Ocurrio un error en la consulta",
          color: Colors.red,
        );
      }
    }

    desactivarLoading();
  }

  void iniciarSesionController() async {
    if (_formKeyViewLogginMobile.currentState!.validate()) {
      activarLoading();

      await loginController.iniciarSesion(
        context,
        cedulaControllerTextField.text,
        passwordLogginControllerTextField.text,
      );

      desactivarLoading();
    }
  }

  void validarExistenciaController() async {
    if (_formKeyViewValidarUserMobile.currentState!.validate()) {
      activarLoading();

      dynamic result = await LoginController().validarExistenciaNewMethod(
        int.parse(cedulaControllerTextField.text),
        context,
      );

      if (result != null) {
        if (result["activarCuenta"] == "activarCuenta") {
          user = result["user"];

          goToPageView(2, animated: false);
        } else if (result["loggin"] == "loggin") {
          user = result["user"];

          goToPageView(1, animated: true);
        }
      }

      desactivarLoading();
    }
  }

  void savePassword() async {


    if (_formKeyViewOlvidarPassword.currentState!.validate()) {
      activarLoading();

      dynamic resul = await LoginController().recuperarPasswordNewMethod(
        context,
        int.parse(user!.cedula),
        confirmPasswordControllerTextField.text,
        codigoRecuperacionControllerTextField.text
      );


      if (resul["status"] == "success") {
     
     
        codigoRecuperacionControllerTextField.clear();
        newPasswordControllerTextField.clear();
        confirmPasswordControllerTextField.clear();       
        goToPageView(1, animated: false);
      
      
      } 





      desactivarLoading();
    } else {}
  }

  void enviarEnlaceDeRecuperacion() async {
    if (_formKeyViewOlvidarPasswordEmail.currentState!.validate()) {
      activarLoading();

      dynamic result = await LoginController().validarCorreoDesktop(
        context,
        int.parse(user!.cedula),
        emailControllerTextField.text,
      );

      if (result != null && result == "ok") {
        correoEnviado = true;
      }

      desactivarLoading();
    }
  }

  void desactivarLoading() {
    setState(() {
      loading = false;
    });
  }

  void activarLoading() {
    setState(() {
      loading = true;
    });
  }

  void goToPageView(int page, {bool animated = true}) {
    currentPage = page;

    if (animated) {
      pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    } else {
      pageController.jumpToPage(page);
    }
      pageController = PageController(initialPage: page);

    setState(() {});
  }
}
