import 'package:flutter/material.dart';

Widget basePageCard({
  required String? pageName,
  Widget? userHeader,
  EdgeInsetsGeometry? margin,

  required dynamic content,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11),
        topRight: Radius.circular(11),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
    ),
    margin:margin ?? EdgeInsets.fromLTRB(14, 9, 8, 0),
    child: Column(
      children: [
        // HEAD
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  pageName!,
                  style: TextStyle(
                    letterSpacing: 2.5,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //userInfoHeader(user: user)
              userHeader!,
            ],
          ),
        ),

        // circleAvatar(pageName: "INICIO"),
        Divider(color: Colors.black54, thickness: 0.2),

        content,
      ],
    ),
  );
}
