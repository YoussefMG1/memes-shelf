import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/custom_widgets/my_drawer.dart';
import 'package:memetic_whats/custom_widgets/selection_appbar.dart';
import 'package:memetic_whats/providers/file_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TestList extends StatelessWidget {
  final controller = SelectionController();
  final String pageText = """Testing was here , 
  now i want to 
  1- know how to use the body as i want, 
  not only having AnimatedBuilder which has ListView.builder inside 

  2- and i want to add something in the drawer 
  now it has ListView.build of pages
  but i want make listView with header , pages and buttons like pick files 
  
  3- fix the recent page as it doesn't show the list until i refreash the page { even this feature is not in the app :) } """;

  @override
  Widget build(BuildContext context) {
    final imageFiles = Provider.of<FileProvider>(context).images;
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      bottomNavigationBar: ElevatedButton(onPressed: ()=>fileProvider.pickFiles(), child: Text("pick files")),
      drawer: MyDrawer(5),
      appBar: SelectionAppBar(
        controller: controller,
        title: 'Files',
        onDelete: () {
          // delete logic
          controller.clear();
        }, 
        itemsList: imageFiles, 
        itemsListName: 'images',
      ),
      body: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(15),
        color: Colors.lightBlue,
        ),
        padding: EdgeInsets.all(15),
        child: Text(pageText,style: TextStyle(fontSize: 18),),
      ),
      // body: AnimatedBuilder(
      //   animation: controller,
      //   builder: (_, __) {
      //     return ListView.builder(
      //       itemCount: imageFiles.length,
      //       itemBuilder: (_, i) {
      //         final file = imageFiles[i];
      //         final selected = controller.isSelected(i);
      //         return ListTile(
      //           // tileColor: Colors.blue[400],
      //           title: Text(file.split('/').last),
      //           leading: SizedBox(height: 80, child: Image.file(File(file))),
      //           trailing: controller.isSelectionMode
      //               ? Checkbox(
      //                   value: selected,
      //                   onChanged: (_) => controller.toggle(i),
      //                 )
      //               : PopupMenuButton(
      //                   itemBuilder: (_) => [
      //                     PopupMenuItem(
      //                       child: Column(
      //                         children: [
      //                           ListTile(
      //                             leading: Icon(Icons.play_arrow),
      //                             title: Text("test API"),
      //                             onTap: () async {
      //                               log(file);
      //                               await fileProvider.sendImageToApi(file);
      //                             },
      //                           ),
      //                           ListTile(
      //                             leading: Icon(Icons.share),
      //                             title: Text("Share file"),
      //                             onTap: () =>
      //                                 fileProvider.shareSingleFile(file),
      //                           ),
      //                           ListTile(
      //                             leading: Icon(Icons.delete),
      //                             title: Text("Delete file"),
      //                             onTap: () {
      //                               Navigator.pop(context);
      //                               fileProvider.deleteStoreFile(fileProvider.images, i, "images");
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                       // onTap: () => OpenFilex.open(filePath),
      //                     ),
      //                   ],
      //                 ),
      //           onTap: () {
      //             if (controller.isSelectionMode) {
      //               controller.toggle(i);
      //             } else {
      //               fileProvider.addToRecent(file);
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => ImageDisplay(File(file)),
      //                 ),
      //               );
      //             }
      //           },
      //           onLongPress: () {
      //             controller.toggle(i);
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
    
    );
  }
}
