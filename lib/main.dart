import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/reservas_controller.dart';
import 'package:tecnovig/Utilities/CONST/mitheme.dart';
import 'package:tecnovig/Views/%E2%9C%89%EF%B8%8F%20Correspondencia/correspondencia_screen.dart';
import 'package:tecnovig/Views/%F0%9F%93%84%20Visitantes/visita_screen.dart';
import 'package:tecnovig/Views/%F0%9F%94%90%20Login/login_screen.dart';
import 'package:tecnovig/Views/%F0%9F%8F%A0Home/home_cliente_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tecnovig/Views/%F0%9F%8F%9E%EF%B8%8F%20Reserva_espacios/reserva_espacios.dart';

// git add .
//  git commit -m  "se agregar la nueva version del codigo"
//*git push -u origin main

void main() {
  runApp(const MyApp());
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

  void consultaReservasDESKTOP() async {
 
    //  dynamic result = await ReservasController().consultaReservas(
    //    idConsulta: ,
    //  );

    //  resultadoReservasDESKTOP = result;
    
    //  loading = false;

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
              //    return CorrespondenciaScreen(idCorrespondencia: "20",);
              //
              //
               return HomeCliente();
    
            //  return ReservaEspacios(idUser: 1);
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
