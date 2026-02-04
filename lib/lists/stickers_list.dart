import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/my_drawer.dart';
import 'package:memetic_whats/custom_widgets/selection_appbar.dart';
import 'package:memetic_whats/providers/file_provider.dart';
import 'package:memetic_whats/open_files/image_display.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class StickersList extends StatelessWidget {
  StickersList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final stickersPath = Provider.of<FileProvider>(context).stickers;
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: SelectionAppBar(
        itemsList: stickersPath,
        itemsListName: "stickers",
        controller: controller,
        title: "Stickers list",
        onDelete: () {},
      ),
      drawer: MyDrawer(4),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return ListView.builder(
            itemCount: stickersPath.length,
            itemBuilder: (_, i) {
              final file = stickersPath[i];
              final selected = controller.isSelected(i);
              return ListTile(
                // tileColor: Colors.blue[400],
                title: Text(file.split('/').last),
                leading: SizedBox(height: 80, child: Image.file(File(file))),
                trailing: controller.isSelectionMode
                    ? Checkbox(
                        value: selected,
                        onChanged: (_) => controller.toggle(i),
                      )
                    : PopupMenuButton(
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.play_arrow),
                                  title: Text("Open file"),
                                  onTap: () => OpenFile.open(file),
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text("Share file"),
                                  onTap: () =>
                                      fileProvider.shareSingleFile(file),
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete file"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    fileProvider.deleteStoreFile(
                                      fileProvider.stickers,
                                      i,
                                      "stickers",
                                    );
                                  },
                                ),
                              ],
                            ),
                            // onTap: () => OpenFilex.open(filePath),
                          ),
                        ],
                      ),

                onTap: () {
                  if (controller.isSelectionMode) {
                    controller.toggle(i);
                  } else {
                    fileProvider.addToRecent(file);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDisplay(File(file)),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  controller.toggle(i);
                },
              );
            },
          );
        },
      ),
    );
  }
}
