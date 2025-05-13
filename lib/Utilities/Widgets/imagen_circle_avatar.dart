import 'package:flutter/material.dart';
import 'package:tecnovig/Utilities/validar_imagen.dart';

CircleAvatar imagenCircleAvatar({
  String? imagenNetworkUrl = "",
  double? radiusSize = 25,
}) {
  final String? url = (imagenNetworkUrl != null && imagenNetworkUrl.isNotEmpty)
      ? "https://software.tecnovig.com/$imagenNetworkUrl"
      : null;

  return CircleAvatar(
    radius: radiusSize,
    backgroundColor: Colors.grey[300],
    child: (url != null && isValidImageUrl(url))
        ? ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: "loading.gif",
              image: url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: 30, color: Colors.grey[700]);
              },
            ),
          )
        : Icon(Icons.person, size: 30, color: Colors.grey[700]),
  );
}