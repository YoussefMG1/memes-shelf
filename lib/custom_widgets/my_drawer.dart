import 'package:flutter/material.dart';
import 'package:memetic_whats/lists/audio_list.dart';
import 'package:memetic_whats/lists/images_list.dart';
import 'package:memetic_whats/lists/stickers_list.dart';
import 'package:memetic_whats/lists/recent_list.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:memetic_whats/themes/theme_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  final int widgetNum;

  MyDrawer(this.widgetNum, {super.key});

  final List<String> titles = ["Recent", "Images", "Audios", "Stickers"];
  final List<Widget> pages = [
    RecentList(),
    ImagesList(),
    AudioList(),
    StickersList(),
  ];
  final List<String> imagesPath = [
    "assets/folder_icon.png",
    "assets/gallery.png",
    "assets/audio.png",
    "assets/file_icon.png",
  ];

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final mytheme = Provider.of<ThemeProvider>(context).myThemeData;
    // final myGrey = Colors.grey[850];
    final mySecondary = Theme.of(context).colorScheme.secondary;

    return Drawer(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background, // const Color(0xFF121212)
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ), // const Color(0xFF1F1F1F)
            child: Row(
              children: const [
                Icon(
                  Icons.menu_book,
                  size: 40,
                  //  color: Colors.white
                ),
                SizedBox(width: 16),
                Text(
                  "EasyMeme",
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (_, i) {
                bool selected = (i == widgetNum - 1);
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? mySecondary // ------------- 1
                        : Theme.of(
                            context,
                          ).colorScheme.primary, // -------------
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      imagesPath[i],
                      width: 35,
                      height: 35,
                      // color: Colors.white,// -------------
                    ),
                    title: Text(
                      titles[i],
                      style: TextStyle(
                        // color: Colors.white, // -------------
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => pages[i]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(
            // color: Colors.white54
          ), // -------------
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: 
                      const Icon(
                        Icons.upload_file,
                        // color: Colors.white,
                      ), // -------------
                   label:const Text("Pick Files"),

                  style: ElevatedButton.styleFrom(
                    // backgroundColor: myGrey, // -------------
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => fileProvider.pickFiles(),
                ),
                // const SizedBox(height: 8),
                // ElevatedButton.icon(
                //   icon: const Icon(Icons.save, color: Colors.white),// -------------
                //   label: const Text("Store All Files"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: myGrey,// -------------
                //     minimumSize: const Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   onPressed: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text("Stored all received files"),
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(height: 8),
                // ElevatedButton.icon(
                //   icon: Icon(
                //     themeProvider.isDarkMode
                //         ? Icons.dark_mode
                //         : Icons.light_mode,
                //     color: Colors.white, // -------------
                //   ),
                //   label: Text(
                //     themeProvider.isDarkMode
                //         ? "Switch to Light"
                //         : "Switch to Dark",
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: myGrey, // -------------
                //     minimumSize: const Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   onPressed: () {
                //     themeProvider.toggleTheme();
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
