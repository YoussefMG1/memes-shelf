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
          child: Column(// stack :image, lable. then previse & next puttons to display one lable
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Image.file(imageFile),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(height: 70,
        child: ElevatedButton(onPressed: () async {
            log(imageFile.path);
            final response = await api.sendImage1ToApi(imageFile.path);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
          }, child: Text("test API",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),),
      )
      
      // ListTile(
      //   leading: Icon(Icons.network_ping),
      //   title: Text("test API"),
      //   onTap: () async {
      //     log(imageFile.path);
      //     final response = await api.sendImageToApi(imageFile.path);
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      //   },
      // ),
    );
  }
}
