// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qu2s/version.dart';

class DownloadTab extends StatelessWidget {
  const DownloadTab({
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
              onPressed: () => downloadFile('./download/qu2s_${version}_win.zip', 'qu2s_${version}_windows'),
            ),
            const SizedBox(width: 20),
            OutlinedButton(
              child: const Text('Download for android'),
              onPressed: () => downloadFile('./download/qu2s_${version}_android.apk', 'qu2s_${version}_android'),
            ),
          ],
        ),
      ),
    );
  }
}

void downloadFile(String url, String name) {
  if (kIsWeb) {
    html.AnchorElement a = html.AnchorElement(href: url);
    a.download = name;
    a.click();
  }
}
