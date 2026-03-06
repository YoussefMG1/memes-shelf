import 'dart:io';
import 'dart:developer';

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
  final List<MemeFile> files;
  final String pageTitle;
  final int drawerNum;

  DisplayList({
    required this.pageTitle,
    required this.files,
    required this.drawerNum,
    super.key,
  });

  @override

  final SelectionController controller = SelectionController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final displayedFiles = searchController.text.isEmpty
        ? files
        : files
              .where(
                (file) => file.displayName.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ),
              )
              .toList();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Myappbar(
        itemsList: files,
        controller: controller,
        title: pageTitle,
        searchController: searchController,
        onSearchChanged: (value) {
          // setState(() {});
        },
      ),
      drawer: MyDrawer(drawerNum),
      body: displayedFiles.isEmpty
          ? Center(
              child: Text(
                "This list is empty",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            )
          : AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return ListView.builder(
                  itemCount: displayedFiles.length,
                  itemBuilder: (_, i) {
                    int index = displayedFiles.length - 1 - i;
                    final file = displayedFiles[index];
                    final selected = controller.isSelected(index);///////////////
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
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            child: ['image', 'sticker',].contains(file.type)
                                ? Image.file(File(file.path), fit: BoxFit.cover)
                                :  file.type =='video'?

                                Image.asset(
                                    "assets/video-icon.png",
                                    fit: BoxFit.cover,
                                  ):
                                Image.asset(
                                    "assets/audio.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        title: Text(
                          file.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        subtitle: Text(
                          file.type,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),

                        trailing: controller.isSelectionMode
                            ? Checkbox(
                                value: selected,
                                onChanged: (_) => controller.toggle(index),
                              )
                            : PopupMenuButton(
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.play_arrow),
                                          title: const Text("Open file"),
                                          onTap: () => OpenFile.open(file.path),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.share),
                                          title: const Text("Share file"),
                                          onTap: () => fileProvider
                                              .shareSingleFile(file),
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.text_rotation_none_sharp,
                                          ),
                                          title: const Text("Rename file"),
                                          onTap: () {
                                            final textController =
                                                TextEditingController();
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  "Rename file",
                                                ),
                                                content: TextField(
                                                  controller: textController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            "Enter new name",
                                                      ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      String newName =
                                                          textController.text;
                                                      if (newName.isNotEmpty) {
                                                        fileProvider.renameFile(
                                                          file,
                                                          newName,
                                                        );
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Change name",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        (fileProvider.recent.contains(file))?

                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text("Remove from recent"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            fileProvider.removeFromRecent(file);
                                          },
                                        ): 
                                        ListTile(
                                          leading: const Icon(Icons.add),
                                          title: const Text("Add to recent"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            fileProvider.addToRecent(file);
                                          },
                                        ),
                                        
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text("Delete file"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            fileProvider.deleteFile(file);
                                          },
                                        ),
                                      ],
                                    ),
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
                                  builder: (context) =>
                                      ImageDisplay(File(file.path)),
                                ),
                              );
                            } else {
                              OpenFile.open(file.path);
                            }
                          }
                        },

                        onLongPress: () {
                         controller.toggle(index);
                        //  log(index.toString());
                        //  log(file.id!.toString());
                        }
                      ),
                    );

                  },
                );
              },
            ),
    );
  }
}
