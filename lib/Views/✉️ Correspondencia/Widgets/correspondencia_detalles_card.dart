import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tecnovig/Models/correspondencia_model.dart';
import 'package:tecnovig/Models/visita_model.dart';
import 'package:url_launcher/url_launcher.dart';

Widget correspondenciaDetallesCardDesktop({
  CorrespondenciaModel? correspondencia,
  required bool isHovering,
  required Function(bool) onHoverChanged,
}) {
  return Expanded(
    flex: 2,
    child: Card(
      margin: EdgeInsets.fromLTRB(10, 8, 0, 0),
      child: SizedBox(
        height: double.maxFinite,
        child:
            correspondencia != null
                ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "D E T A L L E S",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      Text("Correspondencia  N° ${correspondencia.id}"),

                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.inventory_2, size: 40),
                      ),

                      ListTile(
                        title: Text("Descripcion"),
                        //leading: Icon(Icons.phone),
                        subtitle: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              correspondencia.descripcion,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ListTile(
                        title: Text("Registro fotografico"),

                        //leading: Icon(Icons.keyboard_double_arrow_down_sharp),
                        subtitle: imagen(
                          "https://software.tecnovig.com/${correspondencia.foto!}",
                          isHovering: isHovering,
                          onHoverChanged: onHoverChanged,
                        ),
                      ),

                      ListTile(
                        //leading: Icon(Icons.content_paste_search_rounded),
                        title: SizedBox(child: Text("Observaciones")),
                        subtitle: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SizedBox(
                              height: 60,
                              child: Text(
                                maxLines: 2,
                                correspondencia
                                    .observacionesCorrespondenciaResidente!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      ListTile(
                        title: Text("Fecha recepcion"),

                        //leading: Icon(Icons.keyboard_double_arrow_down_sharp),
                        subtitle: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              correspondencia.fechaCorrespondenciaResidente!,

                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ListTile(
                        title: Text("Fecha entrega"),

                        //leading: Icon(Icons.keyboard_double_arrow_up_sharp),
                        subtitle: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              correspondencia.fecha!.toLocal().toString(),

                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                    ],
                  ),
                )
                : Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "D E T A L L E S",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ads_click_rounded, color: Colors.grey),
                            Text(
                              "selecciona un elemento",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    ),
  );
}

dynamic imagen(
  String? image, {
  required bool isHovering,
  required Function(bool) onHoverChanged,
}) {


   String imageUrl = image!;


  return GestureDetector(
    onTap: () async {
      try {
        await _launchInBrowser(Uri.parse(imageUrl));
      } catch (e) {
        print("Error al abrir el navegador: $e");
      }
    },
    child:Material(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) => onHoverChanged(false),
          child: AnimatedScale(
            scale: isHovering ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.maxFinite,
                  errorBuilder: (context, error, stackTrace) {
                    imageUrl = "";
                 
                    return GestureDetector(
                      onTap: () {
                        // Acción alternativa si se desea
                      },
                      child: Container(
                        color: Colors.white,
                        width: double.maxFinite,
                        height: 150,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),

                isHovering
                    ? Container(
                      width: double.maxFinite,
                      height: 150,
                      color: Colors.black26,
                      child:
                        Icon(
                          imageUrl.isNotEmpty  ?  Icons.remove_red_eye  :
                           Icons.image_not_supported
                          ,
                            color: Colors.grey[300],
                          ).animate().fadeIn(),
                    )
                    : SizedBox.shrink(),








              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    browserConfiguration: const BrowserConfiguration(showTitle: true),
    webViewConfiguration: const WebViewConfiguration(),
    url,
    mode: LaunchMode.inAppWebView,
  )) {
    throw Exception('Could not launch $url');
  }
}
