
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecnovig/Controllers/login_controller.dart';
import 'package:tecnovig/Controllers/usuario_controller.dart';
import 'package:tecnovig/Models/Usuario.dart';
import 'package:tecnovig/Utilities/CustomPageRoute.dart';
import 'package:tecnovig/Utilities/alertDialog.dart';
import 'package:tecnovig/Views/correspondencia.dart';
import 'package:tecnovig/Views/notificaciones.dart';
import 'package:tecnovig/Views/profile.dart';
import 'package:tecnovig/Views/visitantes.dart';
import 'package:tecnovig/Views/zonas_comunes.dart';




//* esta vista sera la que se muestre al usuario despues de haber hecho el loggin , aqui se mostraran las opciones del menu 
class HomeCliente extends StatefulWidget {
  
  const HomeCliente({super.key});
  

  @override
  State<HomeCliente> createState() => _HomeClienteState();
}

class _HomeClienteState extends State<HomeCliente> {

Usuario? user; 
List<String?> inicioSesionPreferences = [];
  
  late Timer _timer;
  int _currentPage = 0;
  final PageController _pageController = PageController();

    final List<Color> _pages = [Colors.red, Colors.green, Colors.blue];

@override
  void initState() {
  consultaPreferes();











 _startTimer() ;
    // TODO: implement initState
    super.initState();
  }


  void _startTimer() {
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   setState(() {
    //     if (_currentPage < _pages.length - 1) {
    //       _currentPage++;
    //     } else {
    //       _currentPage = 0; // Regresar a la primera página
    //     }
    //     _pageController.animateToPage(
    //       _currentPage,
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut,
    //     );
    //   });
    // });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: Stack(
        children: [
          Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(color:Colors.black),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("logoTecnoVigLogin.png"),
                      SizedBox(height: 8,),
                      Text(
             user != null  ? user!.nombre : "",
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.apartment_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4),
                          Text(
                          user != null ? user!.espacio : "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[100],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ListTile(
                  onTap: () {
                    Navigator.push(context, CustomPageRoute(page: Profile(user: user,)));
                  },
                  leading: Icon(Icons.person, size: 27),
                  title: Text("Perfil", style: TextStyle(fontSize: 15)),
                ),

                ListTile(
                   onTap: () {
                    Navigator.push(context, CustomPageRoute(page:NotificacionesView()));
                  },
                  leading: Icon(Icons.notifications, size: 27),
                  title: Text("Notificaciones", style: TextStyle(fontSize: 15)),
                ),
                ListTile(
                  leading: Icon(Icons.question_mark, size: 27),
                  title: Text("Ayuda", style: TextStyle(fontSize: 15)),
                ),
                ListTile(
                  leading: Icon(Icons.question_answer_sharp, size: 27),
                  title: Text("Pqrs", style: TextStyle(fontSize: 15)),
                  subtitle: Text(
                    "peticiones, quejas, reclamos, sugerencias ",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            bottom: 15,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 5),
                    TextButton(onPressed: () {




alertDIalogInfoCustom(
  context,  //contexto
  "Cerrar sesion" , //title
  "¿Estás seguro de que deseas cerrar sesión?",//descripcion
() {
              Navigator.of(context).pop();

 LoginController().cerrarSesion(context);  // Function
 }
);
                      
                    }, child: Text("cerrar sesion")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [Image.asset("LogoTecnoVigLogin.png")],
       // backgroundColor: Color(0xfff375CA6),
        backgroundColor: Colors.black,

      ),


    body:

  
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

    Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: ListTile(
        
         trailing: IconButton(onPressed: () {
           
         }, icon: Icon(Icons.notifications_sharp)),
        title: 
        user == null  ?

          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(""),
            ),) : 
        Text(
          "Hola , ${user!.nombre}" ,
          maxLines: 1,overflow: TextOverflow.ellipsis,),
      
      ),
    ) ,


    Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
      child: Text("Noticias" ,style: TextStyle(fontSize: 12, color: Colors.black54),),
    ),


    SizedBox(
      height: 135,
      child: PageView(
       //  controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: 
        
        
        [
for(int i = 0 ; i< _pages.length ; i++)
        GestureDetector(
          onTap: () {
            
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
            child:
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset("comunicado.png", fit: BoxFit.cover,))
            //anuncioEscrito(),
            
            ),
        )
      ],)) ,
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

  // Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),
  // Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),

  //   Icon(Icons.circle , color: _currentPage.toDouble() == _pageController.page ? Colors.red : null,   ),
     Icon(Icons.circle , size: 12,),
     Icon(Icons.circle   ,size: 12, ),

     Icon(Icons.circle  ,size: 12,  ),

],),

      Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Text("Utilidades" ,style: TextStyle(fontSize: 12, color: Colors.black54),),
    ),

    Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 columnas
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1, // Proporción 1:1 (cuadrado)
        ),
        itemCount: 4, // 2 filas * 2 columnas = 4 elementos
        itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
       

//Navigator.push(context, CustomPageRoute(page: Vistantes()));

switch (index) {
  case 0:
    Navigator.push(context, CustomPageRoute(page: Vistantes()));
    break;

     case 1: 
Navigator.push(context, CustomPageRoute(page: Correspondencia()));
    
    break;

     case 2:
Navigator.push(context, CustomPageRoute(page: ZonasComunes()));

    
    break;
     case 3:
    
    break;
  default:
}


        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Center(
            child: 
            
            user == null ?   
            
           SizedBox(
        
            
            width: double.maxFinite,
            height: double.maxFinite,
             child: Card(
              elevation: 0,
              margin: EdgeInsets.all(25),
              color: Colors.grey[300],),
           )
            
              :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                 index == 0 ? 
                  Center(
                    child: Image.asset(
                      "visitantes.png"
                     ),
                  ) : 
        index == 1 ? 
                  Center(
                    child: Image.asset(
                       height:  0.18* MediaQuery.of(context).size.height,
                      "correspondencia.png"
                     ),
                  ) : 
        
                   index == 2 ? 
                  Center(
                    child: Image.asset(
                       height:  0.18* MediaQuery.of(context).size.height,
                      "reservaEspacios.png"
                     ),
                  ) :                     
        Center(
          child: Image.asset(
            height:  0.16* MediaQuery.of(context).size.height,
                      "pagoAdmin.png"
                     ),
        ) ,
                    //  index == 0 ? 
                    //  "visitantes.png" :
                    // index ==  1 ? 
                    //  "correspondencia.png" :
                    // index ==  2 ? 
                  
                    //  "reservaEspacios.png" :
                  
                    //  "Adminstracion"
                    // ,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Divider(height: 0, color: Colors.black54,),
                        SizedBox(height: 6,),
                        Text(
                        index == 0 ? 
                        "Visitantes " :
                        index ==  1 ? 
                        "Correspondencia" :
                        index ==  2 ? 
                                          
                         "Reserva espacios" :
                                          
                         "Adminstracion"
                        ,
                                          
                        style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                      ],
                    ),  
                ],
              ),
            ),
          ),
        ),
      );
        },
      ),
    )






      ],),





    );
  }

  ListTile anuncioEscrito() {
    return ListTile(
          onTap: () {
           // crearCahce();
           setState(() {
             
           });
          },
          title:
          user == null  ?

        Card(
          margin: EdgeInsets.only   ( top : 8 , right: 120),
          color: Colors.grey[300],
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(""),
          ),) : 
          
           Text("! ATENCION ¡"),
          subtitle:

        user == null  ?
            Column(
              children: [
              
              for (int i  = 0 ; i < 2 ; i++)
                SizedBox(
                  width: double.maxFinite,
                  child: Card(
                              margin: EdgeInsets.only(top: 8),
                              color: Colors.grey[300],
                              elevation: 0,
                              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(""),
                              ),),
                ),
              ],
            ) :
            Text("dcdcscsdcdssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssscdcsssssssddddddddddddddddddddddddddddddddddddssssssssssssssssssssssssssssssssss",
           style: TextStyle(color: Colors.black54),
           overflow: TextOverflow.ellipsis,
           maxLines: 3,
          
           ),
          
          );
  }
  
  void consultaPreferes() async {
 
 SharedPreferences prefs = await SharedPreferences.getInstance();
     

  user = await Usuariocontroller().consultaUsuario(prefs.getStringList("listInfoUser")![3]);
 

  
   setState(() {
     
   });





  }


}
