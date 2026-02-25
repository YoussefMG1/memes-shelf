import 'package:flutter/material.dart';
import 'package:memetic_whats/controllers/selection_controller.dart';
import 'package:memetic_whats/models/meme_file.dart';
import 'package:memetic_whats/providers/file_management_db.dart';
// import 'package:memetic_whats/providers/file_management_db.dart';
import 'package:provider/provider.dart';

class Myappbar extends StatelessWidget implements PreferredSizeWidget {
  final List<MemeFile> itemsList;
  // final String itemsListName;
  final SelectionController controller;
  final String title;
  final TextEditingController? searchController;
final Function(String)? onSearchChanged;
  // final VoidCallback onDelete;//doesn't do anything now

  const Myappbar({
    required this.itemsList,
    // required this.itemsListName,
    required this.controller,
    required this.title,
    this.searchController,
  this.onSearchChanged,
  super.key,
    // required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return AppBar(
          toolbarHeight: controller.isSelectionMode ? kToolbarHeight : 100,
          title: controller.isSelectionMode
    ? Text('${controller.count} selected')
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),

          if (searchController != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search in $title",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.white70,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
          leading: controller.isSelectionMode
              ? IconButton(icon: Icon(Icons.close), onPressed: controller.clear)
              : null,
          actions: controller.isSelectionMode
              ? [
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text("Share files"),
                              onTap: () => fileProvider.shareMultipleFiles(
                                itemsList,
                                controller.selectedItems,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text("Delete files"),
                              onTap: () {
                                Navigator.pop(context);
                                fileProvider.deleteSelectiveFiles(
                                  itemsList,
                                  controller.selectedItems,
                                );
                                controller.clear();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.select_all),
                              title: Text("Select All"),
                              onTap: () {
                                controller.selectAll(itemsList.length);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.change_circle),
                              title: Text("Convert Selection"),
                              onTap: () {
                                for (int i = 0; i < itemsList.length; i++) {
                                  controller.toggle(i);
                                }
                              },
                            ),
                          ],
                        ),
                        // onTap: () => OpenFilex.open(filePath),
                      ),
                    ],
                  ),
                ]
              : [],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
  controller.isSelectionMode ? kToolbarHeight : 100,
);
}
