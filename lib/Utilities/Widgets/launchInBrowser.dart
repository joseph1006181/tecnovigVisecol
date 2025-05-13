  import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      browserConfiguration: const BrowserConfiguration(showTitle: true),
      webViewConfiguration: const WebViewConfiguration(),
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }