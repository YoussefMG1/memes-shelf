import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/providers/file_provider.dart';
import 'package:provider/provider.dart';

class SelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final List<String> itemsList;
  final String itemsListName;
  final SelectionController controller;
  final String title;
  final VoidCallback onDelete;//doesn't do anything now

  const SelectionAppBar({
    required this.itemsList,
    required this.itemsListName,
    required this.controller,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return AppBar(
          title: controller.isSelectionMode
              ? Text('${controller.count} selected')
              : Text(title),
          leading: controller.isSelectionMode
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: controller.clear,
                )
              : null,
          actions: controller.isSelectionMode
              ? [
                  PopupMenuButton(
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text("Share files"),
                                onTap: () => fileProvider.shareMultipleFiles(
                                  itemsList,
                                  controller.selectedItems,
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Delete files"),
                                onTap: () {
                                  Navigator.pop(context);
                                  fileProvider.deleteSelectiveFiles(itemsList, controller.selectedItems,itemsListName);
                                  controller.clear();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.select_all),
                                title: Text("Select All"),
                                onTap: () {
                                  controller.selectAll(itemsList);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.change_circle),
                                title: Text("Convert Selection"),
                                onTap: () {
                                  for (int i =0; i< itemsList.length; i++) {
                                    controller.toggle(i);
                                  }
                                },
                              ),
                            ],
                          ),
                          // onTap: () => OpenFilex.open(filePath),
                        ),
                      ],
                    ),
                ]
              : [],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
