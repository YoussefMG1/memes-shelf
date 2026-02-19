import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '/controllers/selection_controller.dart';
import '/custom_widgets/myAppbar.dart';
import '/custom_widgets/my_drawer.dart';
import '/models/meme_file.dart';
import '/providers/file_management_db.dart';
import '/open_files/image_display.dart';

class DisplayList extends StatelessWidget {
  DisplayList({
    required this.pageTitle,
    required this.files,
    required this.drawerNum,
    super.key,
  });
  final List<MemeFile> files;
  final String pageTitle;
  final int drawerNum;
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Myappbar(
        itemsList: files,
        controller: controller,
        title: pageTitle,
      ),
      drawer: MyDrawer(drawerNum),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            // physics: NeverScrollableScrollPhysics(),
            itemCount: files.length,
            itemBuilder: (_, i) {
              int index = files.length - 1 - i;
              final file = files[index];
              final selected = controller.isSelected(index);
              bool exist = File(file.path).existsSync();
              if (!exist) {
                return TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("deleted: ${file.displayName}"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    fileProvider.deleteFile(file);
                  },
                  child: Text(
                    "couldn't find file: ${file.path} - ${file.displayName}",
                  ),
                );
              }
              return ListTile(
                // tileColor: Colors.blue[400],
                title: Text(file.displayName),
                leading: ['image', 'sticker'].contains(file.type)
                    ? SizedBox(height: 80, child: Image.file(File(file.path)))
                    : SizedBox(
                        height: 80,
                        child: Image.asset("assets/audio.png"),
                      ),
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
                                  onTap: () => OpenFile.open(file.path),
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text("Share file"),
                                  onTap: () =>
                                      fileProvider.shareSingleFile(file),
                                ),
                                ListTile(
                                  leading: Icon(Icons.text_rotation_none_sharp),
                                  title: Text("Rename file"),
                                  onTap: () {
                                    final textController =
                                        TextEditingController();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Rename file"),
                                        content: TextField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            hintText: "Enter new name",
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              String newName =
                                                  textController.text;
                                              if (newName.isNotEmpty) {
                                                // Call your rename function here
                                                fileProvider.renameFile(
                                                  file,
                                                  newName,
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text("Change name"),
                                          ),
                                        ],
                                      ),
                                    );
                                    // fileProvider.shareSingleFile(file);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete file"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    fileProvider.deleteFile(file);
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
                    controller.toggle(index);
                  } else {
                    fileProvider.addToRecent(file);
                    if (['image', 'sticker'].contains(file.type)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDisplay(File(file.path)),
                        ),
                      );
                    } else {
                      OpenFile.open(file.path);
                    }
                  }
                },
                onLongPress: () {
                  controller.toggle(index);
                },
              );
            },
          );
        },
      ),
    );
  }
}
