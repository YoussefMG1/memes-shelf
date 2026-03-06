import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class VideosList extends StatelessWidget {
  VideosList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final videoFiles = Provider.of<FileProvider>(context).videos;
    return DisplayList(pageTitle: "Videos", files: videoFiles,drawerNum: 3,);
  }
}
