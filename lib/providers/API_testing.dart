import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memetic_whats/models/opject_detection.dart';

class ApiTesting extends ChangeNotifier {
  List<ObjectDetection> detectedObjects1 = [];
  List<ObjectDetection> detectedObjects2 = [];
  PlatformFile file1 = PlatformFile(name: "name1", size: 0);
  PlatformFile file2 = PlatformFile(name: "name2", size: 0);

   // trying API
  Future<String> sendImage1ToApi(String imagePath) async {
    final uri = Uri.parse("https://api.api-ninjas.com/v1/objectdetection");

    var request = http.MultipartRequest("POST", uri);

    // لو فيه API Key
    // request.headers['Authorization'] = 'Bearer YOUR_API_KEY';
    request.headers['X-Api-Key'] = 'ufn4LQ0OHuKEZy3EFxaQAkFH5rkbcWKlva8D3piE';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // اسم الفيلد اللي الـ API مستنيه
        imagePath,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      log("Object Detection Result: $jsonList");

      detectedObjects1 = jsonList
          .map((json) => ObjectDetection.fromJson(json))
          .toList();
      log('message');
      log(detectedObjects1.length.toString());
      return "Detected ${detectedObjects1.length} objects";
      // هنا هترجع JSON فيه كل الـ labels + bounding boxes + confidence
    } else {
      // i want to try to throw an error instead of returning massage
      log("Error: ${response.statusCode}");
      log("Body: ${response.body}");
      return "Error: ${response.statusCode} : ${response.body}";
    }

    // final response = await request.send();
    // final responseBody = await response.stream.bytesToString();
    // log(responseBody);
  }
  Future<String> sendImage2ToApi(String imagePath) async {
    final uri = Uri.parse("https://api.api-ninjas.com/v1/objectdetection");

    var request = http.MultipartRequest("POST", uri);

    // لو فيه API Key
    // request.headers['Authorization'] = 'Bearer YOUR_API_KEY';
    request.headers['X-Api-Key'] = 'ufn4LQ0OHuKEZy3EFxaQAkFH5rkbcWKlva8D3piE';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // اسم الفيلد اللي الـ API مستنيه
        imagePath,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      log("Object Detection Result: $jsonList");

      detectedObjects2 = jsonList
          .map((json) => ObjectDetection.fromJson(json))
          .toList();
      log('message');
      log(detectedObjects2.length.toString());
      return "Detected ${detectedObjects2.length} objects";
      // هنا هترجع JSON فيه كل الـ labels + bounding boxes + confidence
    } else {
      // i want to try to throw an error instead of returning massage
      log("Error: ${response.statusCode}");
      log("Body: ${response.body}");
      return "Error: ${response.statusCode} : ${response.body}";
    }

    // final response = await request.send();
    // final responseBody = await response.stream.bytesToString();
    // log(responseBody);
  }

  void pickFiles1() async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    file1 = result.files.first;
    notifyListeners();
  }

  void pickFiles2() async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    file2 = result.files.first;
    log(file2.name);
    notifyListeners();
  }

  Future<Size> getImageSize(File file) async {
  final image = Image.file(file);
  final completer = Completer<Size>();

  image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      final myImage = info.image;
      completer.complete(
        Size(myImage.width.toDouble(), myImage.height.toDouble()),
      );
    }),
  );

  return completer.future;
}

}
