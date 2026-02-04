import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/my_drawer.dart';
import 'package:memetic_whats/custom_widgets/selection_appbar.dart';
import 'package:open_file/open_file.dart';
import '../providers/file_provider.dart';
import 'package:provider/provider.dart';

class RecentList extends StatelessWidget {
  RecentList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: SelectionAppBar(
        itemsList: fileProvider.recent,
        itemsListName: "recent",
        controller: controller,
        title: "Recent",
        onDelete: () {
          // is not used ,hhhhhhhhhhhhhhhhhh
          // fileProvider.removeFilesFromRecent(controller.selectedItems.toList());
          controller.clear();
        },
      ),
      // Scaffold.of(context).openDrawer();
      body: fileProvider.recent.isNotEmpty?
      AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return ListView.builder(
            itemCount: fileProvider.recent.length,
            itemBuilder: (_, i) {
              final file = fileProvider.recent[i];
              final selected = controller.isSelected(i);
              bool isAudio = ['mp3','wav','aac','opus',]
                .contains(file.split(".").last);
              return ListTile(
                // tileColor: Colors.blue[400],
                title: Text(file.split('/').last),
                leading: SizedBox(
                  height: 80,
                  child: isAudio
                      ? Image.asset("assets/audio.png")
                      : Image.file(File(file)),
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
                                  onTap: () =>
                                      OpenFile.open(file)
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text("Share file"),
                                  onTap: () =>
                                      fileProvider.shareSingleFile(file),
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("remove from recent"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    fileProvider.deleteStoreFile(
                                      fileProvider.recent,
                                      i,
                                      "recent",
                                    );
                                    // fileProvider.deleteStoreFile(fileProvider.images, i, "images");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                onTap: () {
                  if (controller.isSelectionMode) {
                    controller.toggle(i);
                  } else {
                    OpenFile.open(file);
                    fileProvider.addToRecent(file);
                  }
                },
                onLongPress: () {
                  controller.toggle(i);
                },
              );
            },
          );
        },
      )
      :Center(
        child: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(15),
        color: Colors.lightBlue,
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()=>fileProvider.pickFiles(), child: Text("pick files")),
            ElevatedButton(onPressed: ()=>Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => RecentList()),
                        ), child: Text("show recent files")),
          ],
        ),
      ),
      ),
      drawer: MyDrawer(1),
    );
  }
}
