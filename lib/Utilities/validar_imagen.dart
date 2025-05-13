// Puedes colocarlo arriba o en un archivo utils.dart si prefieres
bool isValidImageUrl(String? url) {
  return url != null &&
      (url.endsWith(".jpg") ||
       url.endsWith(".jpeg") ||
       url.endsWith(".png") ||
       url.endsWith(".webp") ||
       url.endsWith(".gif"));
}