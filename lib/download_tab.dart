import 'package:flutter/material.dart';

class DownloadTab extends StatelessWidget {
  const DownloadTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // important: this should never be called
    return const Scaffold(
      body: Center(child: Text("Downloading other versions on this platform is not supported!")),
    );
  }
}
