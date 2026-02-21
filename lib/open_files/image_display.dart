import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memetic_whats/providers/API_testing.dart';
import 'package:provider/provider.dart';

class ImageDisplay extends StatelessWidget {
  final File imageFile;
  const ImageDisplay(this.imageFile, {super.key});

  @override
  Widget build(BuildContext context) {
    // i think i should call it as object not provider
    // to have the detectedObjects for this image only
    final api = Provider.of<ApiTesting>(context);

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
            // Container(
            //   decoration: BoxDecoration(color: Colors.blue),
            //   child: Image.file(imageFile),
            // ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 70,
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       log(imageFile.path);
      //       final response = await api.sendImage1ToApi(imageFile.path);
      //       ScaffoldMessenger.of(
      //         context,
      //       ).showSnackBar(SnackBar(content: Text(response)));
      //     },
      //     child: Text(
      //       "test API",
      //       style: TextStyle(
      //         color: Colors.black,
      //         fontWeight: FontWeight.bold,
      //         fontSize: 20,
      //       ),
      //     ),
      //   ),
      // ),


    );
  }
}
