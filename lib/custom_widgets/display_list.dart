import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memetic_whats/providers/file_provider.dart';
import 'package:memetic_whats/open_files/image_display.dart';
// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DisplayList extends StatelessWidget {
  DisplayList({super.key, required this.paths});
  List<int> indexs = [];
  bool selectionMode = false;
  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          selectionMode
              ? Row(
                  children: [
                    Text(indexs.length.toString()),
                    PopupMenuButton(
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text("Share files"),
                                onTap: () => fileProvider.shareMultipleFiles(
                                  paths,
                                  indexs.toSet(),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Delete files"),
                                onTap: () {
                                  Navigator.pop(context);
                                  for (var i = 0; i < indexs.length; i++) {
                                    paths.remove(
                                      paths[indexs[i]],
                                    );
                                  }
                                  selectionMode = false;
                                },
                              ),
                            ],
                          ),
                          // onTap: () => OpenFilex.open(filePath),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Image section"),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: paths.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final imageFile = File(paths[index]);
                    final filePath = paths[index];
                    return ListTile(
                      tileColor: Colors.blue[400],
                      title: SizedBox(height: 80, child: Image.file(imageFile)),
                      trailing: selectionMode
                          ? Icon(
                              indexs.contains(index)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            )
                          : PopupMenuButton(
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.play_arrow),
                                        title: Text("Open with"),
                                        onTap: () async {
                                          log(filePath);
                                          File myFile = File(filePath);
                                          if (await myFile.exists()) {
                                            log(
                                              'File is present, attempting to open...',
                                            );
                                            // final result = await OpenFile.open(
                                            //   filePath,
                                            // );
                                            // log(
                                            //   'File is present, it should have been opened',
                                            // );
                                            // log(result.type.toString());
                                            // log(result.message.toString());
                                          } else {
                                            log(
                                              'File does not exist at path: $filePath',
                                            );
                                          }
                                          // OpenFile.open(filePath);
      
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(
                                          //     content: Text(
                                          //       "Can not open files on different apps yet",
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.share),
                                        title: Text("Share file"),
                                        onTap: () => fileProvider.shareSingleFile(
                                          paths[index],
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text("Delete file"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          fileProvider.deleteStoreFile(paths, index, "test");//-------------------------------
                                          // paths.removeAt(index);
                                          // fileProvider.storeImages();
                                        },
                                      ),
                                    ],
                                  ),
                                  // onTap: () => OpenFilex.open(filePath),
                                ),
                              ],
                            ),
      
                      onTap: () {
                        if (selectionMode) {
                          trigger(index);
                        } else {
                          fileProvider.addToRecent(filePath);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageDisplay(imageFile),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        selectionMode = true;
                        indexs.add(index);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
  void trigger(int index) {
    if (indexs.contains(index)) {
      indexs.remove(index);
      if (indexs.isEmpty) selectionMode = false;
    } else {
      indexs.add(index);
    }
  }
}