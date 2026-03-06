import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File imageFile;
  const ImageDisplay(this.imageFile, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20.0),
              minScale: 0.1,
              maxScale: 5.0,
              child: Image.file(imageFile),
            ),
          ),
        ),
      ),
    );
  }
}
