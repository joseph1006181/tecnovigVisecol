import 'package:flutter/material.dart';
import 'package:tecnovig/Views/home_cliente_screen.dart';

// var defaultBackgroundColor = Colors.grey[300];
// var appBarColor = Colors.grey[900];
// var myAppBar = AppBar(
//   backgroundColor: appBarColor,
//   title: Text(' '),
//   centerTitle: false,
// );
var drawerTextColor = TextStyle(color: Colors.grey[600] , fontSize: 14);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 0, top: 8);
var  index = 1;
Widget drawerHomeScreenDESKTOP = Drawer(
  surfaceTintColor: Colors.grey[300],
  backgroundColor: Colors.grey[300],
  elevation: 0,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 48.0, 20.0, 41.0),

            child: Card(
              color: Colors.grey[300],
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset("LogoTecnoVig2.png",width: 200,),
            ),
          ),
          buildDrawerTile(
            indexx: 1,
            icon: Icons.home,
            text: 'I N I C I O',
            onTap: () {
              // acción para inicio
            },
            textStyle: drawerTextColor,
            padding: tilePadding,
          ),
          buildDrawerTile(
            indexx: 2,
            icon: Icons.person,
            text: 'P E R F I L',
            onTap: () {
   
            },
            textStyle: drawerTextColor,
            padding: tilePadding,
          ),
          buildDrawerTile(
            indexx: 3,
            icon: Icons.notifications_sharp,
            text: 'NOTIFICACIONES',
            onTap: () {
              // acción para about
            },
            textStyle: TextStyle(color: Colors.grey[600] , letterSpacing: 4, fontSize: 14),
            padding: tilePadding,
          ),
        ],
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          onTap: () {
            
          },
          leading: Icon(Icons.logout),
          title: Text('S A L I R', style: TextStyle(color: Colors.red[300] , fontSize: 14)),
        ),
      ),
    ],
  ),
);
Widget buildDrawerTile({
  
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  required TextStyle textStyle,
  required EdgeInsets padding,
  required int indexx
}) {
  return Padding(
    padding: padding,
    child: Card(
      color: indexx == 1 ? Colors.white : Colors.transparent,
      elevation: 0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        hoverColor: Colors.grey[200],
        onTap: onTap,
        leading: Icon(icon),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Text(text, style: textStyle),
        ),
      ),
    ),
  );
}
