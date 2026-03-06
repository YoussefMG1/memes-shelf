import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memetic_whats/models/opject_detection.dart';

// import 'object_detection_model.dart'; // الموديل بتاعك

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? imageFile;
  Size? originalImageSize;

  List<ObjectDetection> detections = [];

  bool isLoading = false;
  bool showResults = false;

  //==============================
  // اختيار صورة
  //==============================
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;

    final file = File(result.files.first.path!);

    final size = await getImageSize(file);

    setState(() {
      imageFile = file;
      originalImageSize = size;
      detections = [];
      showResults = false;
    });
  }

  //==============================
  // الحصول على حجم الصورة الأصلي
  //==============================
  Future<Size> getImageSize(File file) async {
    final image = Image.file(file);
    final completer = Completer<Size>();

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
          Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ),
        );
      }),
    );

    return completer.future;
  }

  //==============================
  // إرسال الصورة للـ API
  //==============================
  Future<void> analyzeImage() async {
    if (imageFile == null) return;

    setState(() => isLoading = true);

    final uri =
        Uri.parse("https://api.api-ninjas.com/v1/objectdetection");

    var request = http.MultipartRequest("POST", uri);
    request.headers['X-Api-Key'] = "ufn4LQ0OHuKEZy3EFxaQAkFH5rkbcWKlva8D3piE";

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile!.path,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      detections = jsonList
          .map((e) => ObjectDetection.fromJson(e))
          .toList();

      log("Detections: ${detections.length}");
    } else {
      log("Error: ${response.body}");
    }

    setState(() => isLoading = false);
  }

  //==============================
  // رسم Bounding Boxes مع Scale

  //==============================
  Widget buildImageWithBoxes() {
    if (imageFile == null || originalImageSize == null) {
      return const Center(child: Text("اختر صورة"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double displayWidth = constraints.maxWidth;
        double imageRatio =
            originalImageSize!.height / originalImageSize!.width;
        double displayHeight = displayWidth * imageRatio;

        double scaleX = displayWidth / originalImageSize!.width;
        double scaleY = displayHeight / originalImageSize!.height;

        return SizedBox(
          width: displayWidth,
          height: displayHeight,
          child: Stack(
            children: [
              Image.file(
                imageFile!,
                width: displayWidth,
                height: displayHeight,
                fit: BoxFit.fill,
              ),

              // رسم البوكسات
              ...detections.map((obj) {
                final box = obj.boundingBox!;
                double.parse(box.x1!);
                return Positioned(
                  left: double.parse(box.x1!) * scaleX,
                  top: double.parse(box.y1!) * scaleY,
                  child: Container(
                    width: (double.parse(box.x2!) - double.parse(box.x1!)) * scaleX,
                    height: (double.parse(box.y2!) - double.parse(box.y1!)) * scaleY,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          obj.label! +": "+obj.confidence!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  //==============================
  // UI
  //==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Object Detection")),
      body: Column(
        children: [
          //==============================
          // منطقة الصورة
          //==============================
          Expanded(child: buildImageWithBoxes()),

          const SizedBox(height: 10),

          //==============================
          // الأزرار
          //==============================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("اختيار صورة"),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : analyzeImage,
                child: const Text("تحليل"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (isLoading) const CircularProgressIndicator(),

          //==============================
          // زر عرض النتائج
          //==============================
          if (!isLoading && detections.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showResults = !showResults;
                });
              },
              child: Text(showResults
                  ? "إخفاء النتائج"
                  : "عرض النتائج (${detections.length})"),
            ),

          //==============================
          // قائمة النتائج
          //==============================
          if (showResults)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: detections.length,
                itemBuilder: (context, index) {
                  final obj = detections[index];
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(obj.label ?? ""),
                    subtitle: Text(
                      "Confidence: ${(obj.confidence!)}%",
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
