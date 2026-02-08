import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memetic_whats/models/opject_detection.dart';

class ApiTesting extends ChangeNotifier {
  List<ObjectDetection> detectedObjects = [];

   // trying API
  Future<String> sendImageToApi(String imagePath) async {
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

      detectedObjects = jsonList
          .map((json) => ObjectDetection.fromJson(json))
          .toList();
      log('message');
      log(detectedObjects.length.toString());
      return "Detected ${detectedObjects.length} objects";
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
}