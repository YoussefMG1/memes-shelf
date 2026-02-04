import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

class FileProvider extends ChangeNotifier {
  List<String> images = [];
  List<String> audios = [];
  List<String> stickers = [];
  List<String> recent = [];
  // ignore: unused_field
  late StreamSubscription _intentDataStreamSubscription ;

  // List<SharedFile>? list;
  // List<PlatformFile> images = [];

  FileProvider(){
    log("constructor is called");
     _loadAll();
    _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream()
        .listen((List<SharedFile> listenedFiles) {
          _addListenedFiles(listenedFiles);
    }, onError: (err) {
      log("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> listenedFiles) {
      _addListenedFiles(listenedFiles);
    });
    storeAll();
  }

  @override
  void dispose() { // when does dispose() is called???????????? because the stream do not close
    log("FileProvider disposed");
    // if i don't cancel the stream when i get out of the app , it will create another instance of it in the RAM
    _intentDataStreamSubscription.cancel(); // 🔥 مهم
    super.dispose();
  }

  void _addListenedFiles(List<SharedFile> listenedFiles){
    log("5- images : ${images.length}");
    for (var file in listenedFiles) {
      // log(file.toString());
      // log(file.duration.toString());
      // log(file.mimeType.toString());
      log(file.type.toString());
      log(file.type.name.toString());
      log(file.value.toString());
      final ext = file.value?.split('.').last;

        if (['jpg', 'png', 'jpeg'].contains(ext)) {
          images.add(file.value!);
        } else if (['mp3', 'wav', 'aac', 'opus'].contains(ext)) {
          audios.add(file.value!);
        } else if (['webp', 'gif', 'mp4', 'webp'].contains(ext)) {
          stickers.add(file.value!);
        }
    }
    // to store files automaticlly 
    //i should store it here not after the listeners in the constructor 
    //cause it will store before the stream is finished
    log("6- images : ${images.length}");
    notifyListeners();
    log("7- images : ${stickers.length} and cancel stream listener");
    log(_intentDataStreamSubscription.toString());
    _intentDataStreamSubscription.cancel();
    log(_intentDataStreamSubscription.toString());
    storeAll();

  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      //we can do this if we want
      //List<XFile> xFiles = result.xFiles;
      for (var file in result.files) {
        log(file.toString());
        log(file.path.toString());
        log(file.bytes.toString());
        log(file.name.toString());
        log(file.size.toString());
        log(file.extension.toString());
        log(file.xFile.toString());
        final ext = file.extension?.toLowerCase();

        if (['jpg', 'png', 'jpeg'].contains(ext)) {
          images.add(file.path!);
        } else if (['mp3', 'wav', 'aac', 'opus'].contains(ext)) {
          audios.add(file.path!);
        } else if (['webp', 'gif', 'mp4', 'webp'].contains(ext)) {
          stickers.add(file.path!);
        }
      }
      storeAll();
    } else {
      // User canceled the picker
    }
    notifyListeners();
  }

  void deleteSelectiveFiles(List<String> list, Set<int> selectiveIndexes,String storageName)async {
    for (var i = 0; i < selectiveIndexes.length; i++) {
      list.remove(list[selectiveIndexes.elementAt(i)]);
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageName, list);
    notifyListeners();
  }
  void deleteStoreFile(List<String> list, int fileIndex,String storageName)async {
    list.removeAt(fileIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(storageName, list);
    notifyListeners();
  }
  void shareMultipleFiles(List<String> list, Set<int> indexes) async {
    // List<XFile> xFileImages = images
    // .where((f) => f != null)
    // .map((f) => XFile(f))
    // .toList();
    List<XFile> xFileList = [];
    for (var i = 0; i < indexes.length; i++) {
      xFileList.add(XFile(list[indexes.elementAt(i)]));
    }
    final params = ShareParams(files: xFileList);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.dismissed) {
      log('Did you not like these files?');
    }
    notifyListeners();
  }
  void shareSingleFile(String filePath) async {
    XFile xFile = XFile(filePath);
    log(xFile.name);
    log(xFile.path);
    final params = ShareParams(files: [xFile]);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.dismissed) {
      log('Did you not like the file?');
    }
    
    notifyListeners();
  }

  void addToRecent(String filePath)async {
    recent.remove(filePath);
    recent.insert(0, filePath);
    if (recent.length > 20) recent.removeLast();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("recent", recent);
    notifyListeners();
  }

  void storeAll() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("images", images);
    await prefs.setStringList("audios", audios);
    await prefs.setStringList("stickers", stickers);
    await prefs.setStringList("recent", recent);
    notifyListeners();
  }
  void _loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList("images");
    if (items != null) {
      images.clear();
      images.addAll(items);
    }
    items = prefs.getStringList("recent");
    if (items != null) {
      recent.clear();
      recent.addAll(items);
    }
    items = prefs.getStringList("audios");
    if (items != null) {
      audios.clear();
      audios.addAll(items);
    }
    items = prefs.getStringList("stickers");
    if (items != null) {
      stickers.clear();
      stickers.addAll(items);
    }    
  }

}