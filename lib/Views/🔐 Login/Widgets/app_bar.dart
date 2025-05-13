  import 'package:flutter/material.dart';

Widget appBar(BuildContext context, {String? title, Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            splashRadius: 30,
            onPressed: onPressed,
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          ),

          Text(title ?? "", style: TextStyle(color: Colors.white)),
          Text(""),
        ],
      ),
    );
  }