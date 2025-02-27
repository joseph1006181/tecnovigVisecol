import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tecnovig/Utilities/mitheme.dart';

class NotificacionesView extends StatefulWidget {
  const NotificacionesView({super.key});

  @override
  State<NotificacionesView> createState() => _NotificacionesViewState();
}

class _NotificacionesViewState extends State<NotificacionesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Column(
      
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
                  "Notificaciones",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text("    ")
              ],
            ),
          ),
Padding(
  padding: const EdgeInsets.only( left:  8.0 , top:0),
  child: Text("Ajustes de notifiaciones" , style: TextStyle(color: Colors.black54, fontSize: 13 , fontWeight: FontWeight.bold),),
),


Card(
  margin: EdgeInsets.all(10),
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      trailing: IconButton(onPressed: () {
        
      }, icon: Icon(Icons.check_box_outline_blank)),
      leading: Icon(Ionicons.logo_whatsapp , size: 40,),
      title: Text("Whatsapp", style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("notificaciones via whatsapp" , style: TextStyle(color: Colors.black54 , fontSize: 13),),
      
      
      ),
  ),
),



Card(
  margin: EdgeInsets.all(10),
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      trailing: IconButton(onPressed: () {
        _showBottomSheet( context);
      }, icon: Icon(Icons.check_box_outline_blank)),
      leading: Icon(Icons.email_outlined , size: 40,),
      title: Text("Email" , style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("notificaciones via whatsapp" , style: TextStyle(color: Colors.black54 , fontSize: 13),),
      
      
      ),
  ),
)






    ],)
    
    
    
    
    
    
    
    
    
     ,);
  }









  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
   isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height*0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text("Autorizar notificaciones",
                    textAlign: TextAlign.center,
                     style: TextStyle(
                      color: Colors.black,
                      fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
               Padding(
                 padding: const EdgeInsets.fromLTRB(10, 4, 10, 4)
                  ,                 child: Image.asset("notifi.png", scale:6,),
               ),
                  
                  
             ListTile(leading: Icon(Icons.people_alt,size: 30,),title: Text("Aviso de visitantes"),),
             ListTile(leading: Icon(Ionicons.cube,size: 30,),title: Text("Aviso de correspondencia"),),
             ListTile(leading: Icon(Ionicons.megaphone,size: 30,),title: Text("Aviso Noticias y alertas"),),
                  
                  
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                     style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color?>(
                          Color(0xfff375CA6),
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
                    onPressed: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Autorizar", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );


  }



}