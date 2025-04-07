import 'package:flutter/material.dart';
import 'package:tecnovig/Controllers/login_controller.dart';

class EspacioScreen extends StatefulWidget {
  const EspacioScreen({super.key});

  @override
  State<EspacioScreen> createState() => _EspacioScreenState();
}

class _EspacioScreenState extends State<EspacioScreen> {

  int indexCategoria = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(onPressed: () {
        


      },),
      
      body:
    
     SingleChildScrollView(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           
        Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    splashRadius: 30,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded),
                  ),
                  Text(
                    "Zonas comunes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text("  ")
                ],
              ),
            ),
       
       
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Categorias" , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
            ),
       
       
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 8,height: 15,) ,
              
              
                categoria("Todas" , Icons.window_outlined , 0) ,
                  SizedBox(width: 25,) ,
              
              
              categoria("humedaS", Icons.pool_rounded, 1),
                  SizedBox(width: 25,) ,
                  
              categoria("salones", Icons.other_houses_rounded, 2),
                  SizedBox(width: 25,) ,
                 
                 
              categoria("deportes", Icons.fitness_center_rounded,3)
              
              
              ],),
            ) ,
       
       
            Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              
              child: 
            
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("piscina.jpg", fit: BoxFit.cover,),
                ),
                ListTile(title: Text("Piscina", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(
                  maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  
                  "subtitles  qqqqqqqqqqqqqqqqqqqq ""\nqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
                "\nscsqqqqqqqqqqqqqqqqqqqqqqqqqqqqfffffffffffffffffffffffffffffffffff", style: TextStyle(color: Colors.black54),),
                )
              ],
            )
            
            ,),
       
       
       Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              
              child: 
            
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("salonEventos.jpg", fit: BoxFit.cover,),
                ),
                ListTile(title: Text("Salon de eventos", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(
                  maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  
                  "subtitles  qqqqqqqqqqqqqqqqqqqq ""\nqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
                "\nscsqqqqqqqqqqqqqqqqqqqqqqqqqqqqfffffffffffffffffffffffffffffffffff", style: TextStyle(color: Colors.black54),),
                )
              ],
            )
            
            ,)
       
       
       
       
       
       
       
       
       
       
       
       
       
         ],
       ),
     ));
  }

  Column categoria(String nombre , IconData icono , int index) {
    return Column(
            children: [
              Container(

                decoration: BoxDecoration(

                  border: indexCategoria == index ? Border.all(color: Colors.black , width: 2): null,
                  color: Colors.white,
                borderRadius: BorderRadius.circular(8) ),
                       padding: EdgeInsets.all(8),     
                child: Center(child: Icon(icono , color: Colors.black, size: 45,)),),

                 Text(nombre, style: TextStyle(fontSize: 13 , fontWeight: FontWeight.bold , color: Colors.black),)
            ],
          );
  }
}