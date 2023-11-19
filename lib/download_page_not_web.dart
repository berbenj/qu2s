// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Download for windows'),
              onPressed: () => downloadFile('./download/qu2s.zip', 'qu2s'),
            ),
            const SizedBox(width: 20),
            OutlinedButton(
              child: const Text('Download for android'),
              onPressed: () => downloadFile('', ''),
            ),
          ],
        ),
      ),
    );
  }
}

void downloadFile(String url, String name) {
  if (kIsWeb) {
    // html.AnchorElement a = html.AnchorElement(href: url);
    // a.download = name;
    // a.click();
  }
}
