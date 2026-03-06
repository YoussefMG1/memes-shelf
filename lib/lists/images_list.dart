import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class ImagesList extends StatelessWidget {
  ImagesList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final imageFiles = Provider.of<FileProvider>(context).images;
    return DisplayList(pageTitle: "images", files: imageFiles,drawerNum: 2,);
  }
}
