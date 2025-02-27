import 'package:flutter/material.dart';
import 'package:tecnovig/Models/Usuario.dart';

class Profile extends StatefulWidget {
  Usuario? user;
   Profile({super.key , this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   TextEditingController phoneController =
      TextEditingController();
   TextEditingController emailController =
      TextEditingController();

@override
  void initState() {
    // TODO: implement initState
phoneController = TextEditingController(text:widget.user!.telefono.toString());
emailController = TextEditingController(text:widget.user!.correo.toString());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My perfil", style: TextStyle(fontSize: 20 , color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.apartment_rounded, size: 100, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                widget.user!.espacio,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: Colors.black),
              ),
              SizedBox(height: 20),
          
          
              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: _buildProfileField(Icons.badge, widget.user!.nombre, isEditable: false),
                  leading: Icon(Icons.person),
          
          
                ),),
          
              SizedBox(height: 30),
                
              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: _buildProfileField(Icons.badge, widget.user!.cedula, isEditable: false),
                  leading: Icon(Icons.badge_rounded),
          
          
                ),),
          
              SizedBox(height: 30),
          
                   Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  trailing: Icon(Icons.edit),
          
                  title:  _buildProfileField(Icons.badge, phoneController.text, isEditable: true),
          
                  leading: Icon(Icons.phone),
          
          
                ),),
          
              SizedBox(height: 30),
          
                  Card(
                    
          
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  trailing: Icon(Icons.edit),
                  title:  _buildProfileField(Icons.badge,emailController.text, isEditable: true),
                  leading: Icon(Icons.email),
          
          
                ),),
              // _buildProfileField(Icons.person, "marco antonio fernadez zapata",
              //     isEditable: false),
              // _buildProfileField(Icons.badge, "1006181610", isEditable: false),
              // _buildProfileField(Icons.phone, phoneController),
              // _buildProfileField(Icons.email, emailController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Acción de guardar cambios
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Color del botón
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text("guardar cambios",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(IconData icon, dynamic content,
      {bool isEditable = true}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
             style: TextStyle(color: Colors.black54),
            enabled: isEditable,
                  controller: TextEditingController(text: content),
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                )
              
        ),
         
      ],
    );
  }
}
