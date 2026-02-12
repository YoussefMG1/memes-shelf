import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class StickersList extends StatelessWidget {
  StickersList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final stickersPath = Provider.of<FileProvider>(context).stickers;
    return DisplayList(pageTitle: "stickers", files: stickersPath,drawerNum: 4,);
  }
}
