// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/my_drawer.dart';
import 'package:memetic_whats/custom_widgets/selection_appbar.dart';
import 'package:memetic_whats/providers/file_provider.dart';

import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class AudioList extends StatelessWidget {
  AudioList({super.key});
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {
    final audioFiles = Provider.of<FileProvider>(context).audios;
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      drawer: MyDrawer(3),
      appBar: SelectionAppBar(
        controller: controller,
        title: 'Files',
        onDelete: () {
          // delete logic
          controller.clear();
        }, itemsList: audioFiles, itemsListName: 'audios',
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return ListView.builder(
            itemCount: audioFiles.length,
            itemBuilder: (_, i) {
              final file = audioFiles[i];
              final selected = controller.isSelected(i);
              return ListTile(
                // tileColor: Colors.blue[400],
                title: Text(file.split('/').last),
                leading: SizedBox(height: 80, child: Image.asset("assets/audio.png")),
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
                                  onTap: () async {
                                  },
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
                                    fileProvider.deleteStoreFile(fileProvider.audios, i, "audios");
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
                    OpenFile.open(file);
                    fileProvider.addToRecent(file);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       "can't open audio files now",
                    //     ),
                    //   ),
                    // );
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
  // @override
  // Widget build(BuildContext context) {
  //   final fileProvider = Provider.of<FileProvider>(context);
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Audios'),
  //       leading: Builder(
  //         builder: (context) {
  //           return IconButton(
  //             icon: const Icon(Icons.menu),
  //             onPressed: () {
  //               Scaffold.of(context).openDrawer();
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //     drawer: MyDrawer(3),
  //     body: Center(
  //       child: SingleChildScrollView(
  //         child: 
  //         // Text("Audio section"),
  //             ListView.separated(
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemCount: fileProvider.audios.length,
  //               separatorBuilder: (_, __) => Divider(),
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   leading: IconButton(
  //                     icon: Icon(Icons.play_arrow),
  //                     onPressed: () {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text(
  //                             "Can not open files on different apps yet",
  //                           ),
  //                         ),
  //                       );
  //                       // OpenFilex.open(fileProvider.audio[index].path!),
  //                     },
  //                   ),
  //                   title: Text(fileProvider.audios[index]),
  //                   trailing: IconButton(
  //                     onPressed: () {
  //                       fileProvider.shareSingleFile(fileProvider.audios[index]);
  //                     },
  //                     icon: Icon(Icons.share),
  //                   ),
  //                   onTap: () {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text(
  //                           fileProvider.audios[index],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 );
  //               },
  //             ),
  //       ),
  //     ),
  //   );
  // }

}