import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/responsive_layout.dart';
import 'package:tecnovig/Utilities/mitheme.dart';
import 'package:tecnovig/Views/desktop/valida_user_desktop.dart';
import 'package:tecnovig/Views/home_cliente_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tecnovig/Views/login_screen.dart';
import 'package:tecnovig/Views/reserva_espacios.dart';




// git add .
//  git commit -m  "se agregar la nueva version del codigo"
//*git push -u origin main







void main() {
  runApp(
    const MyApp(),

    // const MyApp()
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  final _scafoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey:
          _scafoldKey, // 🔹 Para manejar el SnackBar globalmente

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },

      locale: const Locale('es', 'ES'), // Cambia el idioma aquí
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        // Locale('en', 'US'), // Inglés (opcional)
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'tecnovig',
      theme: myTheme,
      home:
       Scaffold(
        body: FutureBuilder<List<String?>>(
          initialData: [],

          future:  LoginController().verificarSesion(),

          builder: (context, snapshot) {
        
           if (snapshot.data!.isNotEmpty) {
              return HomeCliente();
            } else {
              //return ValidarUser();
              return LoginScreen();
             
            }
            // if (snapshot.data!.isNotEmpty) {
             
            //  //iniciado
            //  return ResponsiveLayout(
            //   desktopBody: HomeCliente(),
            //   mobileBody: HomeCliente(),
            //   tabletBody: HomeCliente(),);
          
          
            // } else {
             
            //  //No iniciado
             
            //  return ResponsiveLayout(
            //   desktopBody: DesktopScaffold(),
            //   mobileBody: ValidarUser(),
            //   tabletBody: ValidarUser(),);
           




            // }
          },
        ),
      ),

    
    );
  }

//*METODOS LOGICOS









}


