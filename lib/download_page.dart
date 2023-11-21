import 'package:flutter/material.dart';

class DownloadTab extends StatelessWidget {
  const DownloadTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Downloading other versions on this platform is not supported!")),
    );
  }
}
