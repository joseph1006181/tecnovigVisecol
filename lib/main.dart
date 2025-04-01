import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/mitheme.dart';
import 'package:tecnovig/Views/homeClienteVisitante.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tecnovig/Views/olvidarContrase%C3%B1a.dart';
import 'package:tecnovig/Views/reserva_espacios.dart';
import 'package:tecnovig/Views/validaUser.dart';

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
      home: Scaffold(
        body: FutureBuilder<List<String?>>(
          initialData: [],

          future: LoginController().verificarSesion(),

          builder: (context, snapshot) {
            if (snapshot.data!.isNotEmpty) {
              return HomeCliente();
            } else {
              return ValidarUser();
           
            }
          },
        ),
      ),

    
    );
  }

//*METODOS LOGICOS









}


