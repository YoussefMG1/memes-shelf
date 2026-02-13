import 'package:flutter/material.dart';
import 'package:memetic_whats/ObjectDetectionPage.dart';
import 'package:memetic_whats/lists/audio_list.dart';
import 'package:memetic_whats/lists/images_list.dart';
import 'package:memetic_whats/lists/stickers_list.dart';
// import 'package:memetic_whats/lists/test_list.dart';
import 'package:memetic_whats/lists/recent_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:memetic_whats/themes/theme_provider.dart';
// import 'package:memetic_whats/providers/file_management_shared_preference.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer(this.widgetNum, {super.key});
  int widgetNum;
  List<String> titles = ["Resent", "Images", "Audios", "Stickers"];
  List<Widget> pages = [
    RecentList(),
    ImagesList(),
    AudioList(),
    StickersList(),
    // TestList(),
  ];
  List<String> imagesPath = [
    "assets/folder_icon.png",
    "assets/gallery.png",
    "assets/audio.png",
    "assets/file_icon.png",
    // "assets/file_icon.png",
  ];

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Memy App"),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: pages.length,
            itemBuilder: (_, i) {
              return (i == widgetNum - 1)
                  ? ListTile(
                      tileColor: Colors.blue[200],
                      title: Text(titles[i]),
                      leading: SizedBox(
                        height: 50,
                        child: Image.asset(imagesPath[i]),
                      ),
                    )
                  : ListTile(
                      title: Text(titles[i]),
                      leading: SizedBox(
                        height: 50,
                        child: Image.asset(imagesPath[i]),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => pages[i]),
                        );
                        // Navigator.pop(context);
                      },
                    );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ObjectDetectionPage()),
            ),
            child: Text("ObjectDetectionPage"),
          ),
          ElevatedButton(
            onPressed: () => fileProvider.pickFiles(),
            child: Text("pick files"),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context).toggleTheme();
            },
            child: Text("Change theme"),
          ),
        ],
      ),
      // Column( //may chang it to Column as may cause a problem that there is ListView inside a ListView
      //   children: [
      //     DrawerHeader(
      //       decoration: BoxDecoration(color: Colors.blue),
      //       child: Text("Memy App"),
      //     ),

      //   ],
      // ),
    );
  }
}
