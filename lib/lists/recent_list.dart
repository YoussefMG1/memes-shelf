import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class RecentList extends StatelessWidget {
  RecentList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final recentList = Provider.of<FileProvider>(context).recent;
    return  DisplayList(pageTitle: "recent files", files: recentList,drawerNum: 1,);
  }
}
