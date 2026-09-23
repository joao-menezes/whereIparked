import 'dart:io';

import 'package:flutter/material.dart';

class PhotoViewerScreen extends StatelessWidget {
  const PhotoViewerScreen(this.file, {super.key});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(child: Center(child: Image.file(file))),
    );
  }
}
