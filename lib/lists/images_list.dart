import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/display_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ImagesList extends StatelessWidget {
  ImagesList({super.key});
  List<int> indexs = [];
  bool selectionMode = false;
  final controller = SelectionController();

  @override
  Widget build(BuildContext context) {

    final imageFiles = Provider.of<FileProvider>(context).images;
    // final fileProvider = Provider.of<FileProviderSP>(context);
    return DisplayList(pageTitle: "images list DB", files: imageFiles,drawerNum: 2,);
    // Scaffold(
    //   backgroundColor: Color(0xff999999),
    //   drawer: MyDrawer(2),
    //   appBar: SelectionAppBarSP(
    //     controller: controller,
    //     title: 'Images',
    //     onDelete: () {
    //       // delete logic
    //       controller.clear();
    //     },
    //     itemsList: imageFiles,
    //     itemsListName: 'images',
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: AnimatedBuilder(
    //       animation: controller,
    //       builder: (_, __) {
    //         return ListView.separated(
    //           itemCount: imageFiles.length,
    //           itemBuilder: (_, i) {
    //             final file = imageFiles[i];
    //             final selected = controller.isSelected(i);
    //             return ListTile(
    //               // tileColor: Colors.blue[400],
    //               tileColor: Colors.white,
    //               contentPadding: EdgeInsets.all(5),
    //               title: Text(file.split('/').last),
    //               leading: SizedBox(height: 80, child: Image.file(File(file))),
    //               trailing: controller.isSelectionMode
    //                   ? Checkbox(
    //                       value: selected,
    //                       onChanged: (_) => controller.toggle(i),
    //                     )
    //                   : PopupMenuButton(
    //                       itemBuilder: (_) => [
    //                         PopupMenuItem(
    //                           child: Column(
    //                             children: [
    //                               ListTile(
    //                                 leading: Icon(Icons.play_arrow),
    //                                 title: Text("Open file"),
    //                                 onTap: () => OpenFile.open(file),
    //                               ),
    //                               ListTile(
    //                                 leading: Icon(Icons.share),
    //                                 title: Text("Share file"),
    //                                 onTap: () =>
    //                                     fileProvider.shareSingleFile(file),
    //                               ),
    //                               ListTile(
    //                                 leading: Icon(Icons.delete),
    //                                 title: Text("Delete file"),
    //                                 onTap: () {
    //                                   Navigator.pop(context);
    //                                   fileProvider.deleteStoreFile(
    //                                     fileProvider.images,
    //                                     i,
    //                                     "images",
    //                                   );
    //                                 },
    //                               ),
    //                             ],
    //                           ),
    //                           // onTap: () => OpenFilex.open(filePath),
    //                         ),
    //                       ],
    //                     ),

    //               onTap: () {
    //                 if (controller.isSelectionMode) {
    //                   controller.toggle(i);
    //                 } else {
    //                   fileProvider.addToRecent(file);
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => ImageDisplay(File(file)),
    //                     ),
    //                   );
    //                 }
    //               },
    //               onLongPress: () {
    //                 controller.toggle(i);
    //               },
    //             );
    //           },
    //           separatorBuilder: (BuildContext context, int index) {
    //             return SizedBox(height: 10);
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
