import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class AudioList extends StatelessWidget {
  AudioList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<FileProvider>(context).audios;
    return  DisplayList(pageTitle: "audio", files: audio,drawerNum: 3,);
  }
}