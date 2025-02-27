import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

import 'package:http/http.dart' as http;
import 'package:tecnovig/Views/homeClienteVisitante.dart';
import 'package:tecnovig/Models/Usuario.dart';

class Loggin extends StatefulWidget {
  const Loggin({super.key});

  @override
  State<Loggin> createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  TextEditingController campoCedula = TextEditingController(text: "100712445");
  TextEditingController campoPassword = TextEditingController(text: "");

  LoginController loginController = LoginController();
  Usuario? useria;

  bool loading =  false;
  @override
  void initState() {
   


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff375CA6),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
            child: Image.asset("logoTecnoVigLogin.png"),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Inicia sesion",
                  style: TextStyle(fontSize: 25, color: Colors.grey[200]),
                ),
              ),

              textField(
                controller: campoCedula,
                ejecucion: () {},
                label: "Digita tu numero de cedula",
                icono: Icons.person,
              ),

              textField(
                controller: campoPassword,
                ejecucion: () {},
                label: "Digita tu contraseña",
                icono: Icons.lock,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                child: SizedBox(
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
                    onPressed: () {
setState(() {
  loading = true;
});

                  //    maisn(["d"]);
//consultaUsuario(campoCedula.text);
  //user = await ApiService().fetchUsuario(campoCedula.text);
//consultaUsuario(campoCedula.text);
loginController.iniciarSesion(context, campoCedula.text, "password");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: 
                      
                     loading ?

                     SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white,)) : 
                      Text(
                        "Iniciar sesion",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Text("¿ Olvidaste la contraseña ?"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding textField({
    String? label,
    IconData? icono,
    Function? ejecucion,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
       //   print("object"+value);
        },
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.grey[200]),

        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(icono, color: Colors.black54),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }


  void consultaUsuario(String id) async {
  String cedula = id;

  var url = Uri.parse(
    "http://127.0.0.1:5001/uranosssss/us-central1/widgets/buscar?cedula=$cedula",
  );

  try {
    var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "application/json", // Asegura que se envía como JSON
      // },
      //   body: jsonEncode(datos),
    );

    if (response.statusCode == 200) {
      
      //print("✅ Respuesta: ${response.body.runtimeType}");
     
     // Decodificar el JSON
      var jsonResponse = jsonDecode(response.body);


        useria = Usuario.fromJson(jsonResponse[0]);



         guardarDatosDeInicioEncache();


   Navigator.push(context,MaterialPageRoute(builder: (context) {
   

     return HomeCliente();
   },));


   
    } else {
      print("❌ Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("❌ Excepción: $e");
  }
}

  void guardarDatosDeInicioEncache()async {

 SharedPreferences cacheInicio = await SharedPreferences.getInstance();



 cacheInicio.setString("inicioGuardado", "ok");


print("datos guradados con exito");



  }

}

