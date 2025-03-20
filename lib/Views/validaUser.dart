


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Utilities/alertaSuelo.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

//*  esta view es la que valida la existencia de la persona en el sistema


class ValidarUser extends StatefulWidget {
  const ValidarUser({super.key});

  @override
  State<ValidarUser> createState() => _ValidarUserState();
}

class _ValidarUserState extends State<ValidarUser> {
  

  TextEditingController campoCedula = TextEditingController(text: "");
  TextEditingController campoPassword = TextEditingController(text: "");


  bool loading =  false;


  @override
  void initState() {
   


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff375CA6),
      body:  
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
            child: Image.asset("logoTecnoVigLogin.png"),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              textField(
                controller: campoCedula,
                ejecucion: () {},
                label: "Digita tu numero de cedula",
                icono: Icons.person,
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
                    onPressed: ()async {


               if (campoCedula.text.isNotEmpty) {
              
              setState(() {loading = true;});
 
  await  LoginController().validarExistencia(int.parse(campoCedula.text) , context);

loading = false;


} else {


  mostrarMensaje(context, "No puedes dejar el campo vacio");

    
}
   
    setState(() {});

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
                        "Continuar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
       inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))],
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

}

