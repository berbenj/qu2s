import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Downloading other versions on this platform is not supported!")),
    );
  }
}
