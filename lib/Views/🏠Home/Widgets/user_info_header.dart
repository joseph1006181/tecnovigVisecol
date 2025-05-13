import 'package:flutter/material.dart';
import 'package:tecnovig/Models/usuario_model.dart';

Widget userInfoHeader({required UsuarioModel? user }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user != null ? user.nombre : "",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                user != null ? user.espacio : "",
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
          SizedBox(width: 8),
      
          CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.person),
          ),
        ],
      ),
    );
  }