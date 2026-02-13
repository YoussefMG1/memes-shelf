import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

import '../providers/meme_database.dart';
import '../models/meme_file.dart';

class FileProvider extends ChangeNotifier {
  /// كل الملفات
  List<MemeFile> _allFiles = [];

  /// Lists للـ UI
  List<MemeFile> images = [];
  List<MemeFile> audios = [];
  List<MemeFile> stickers = [];
  List<MemeFile> recent = [];

  late StreamSubscription _intentDataStreamSubscription;

  FileProvider() {
    log('FileProvider constructor');
    _loadFromDatabase();

    _intentDataStreamSubscription =
        FlutterSharingIntent.instance.getMediaStream().listen(
      _handleSharedFiles,
      onError: (err) {
        log("Sharing stream error: $err");
      },
    );

    FlutterSharingIntent.instance.getInitialSharing().then(
      _handleSharedFiles,
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  // ==================================================
  // ================= LOAD & SPLIT ===================
  // ==================================================

  Future<void> _loadFromDatabase() async {
    _allFiles = await MemeDatabase.instance.getAllFiles();
    log("all files in app ${_allFiles.length}");
    _splitLists();
    notifyListeners();
  }

  void _splitLists() {
    images = _allFiles.where((f) => f.type == 'image').toList();
    audios = _allFiles.where((f) => f.type == 'audio').toList();
    stickers = _allFiles.where((f) => f.type == 'sticker').toList();
    recent = _allFiles.where((f) => f.isRecent).toList();
  }

  // ==================================================
  // ================= ADD FILES ======================
  // ==================================================

  void pickFiles() async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;

    for (final file in result.files) {
      final type = _detectType(file.extension);
      if (type == null || file.path == null) continue;
      log(file.path!);
      final newFile = await saveFileLocally(file);
      log(newFile.path);
      await MemeDatabase.instance.addFile(
        MemeFile(
          path: newFile.path,
          displayName: newFile.path.split('/').last,
          type: type,
          isRecent: false,
        ),
      );
    }

    await _loadFromDatabase();
  }
  
  Future<File> saveFileLocally(PlatformFile file) async {
  final appDir = await getApplicationDocumentsDirectory();
  final newPath = '${appDir.path}/${file.name}';

  final newFile = File(newPath);

  if (file.path != null) {
    await File(file.path!).copy(newPath);
  } else if (file.bytes != null) {
    await newFile.writeAsBytes(file.bytes!);
  }

  return newFile;
}


  void _handleSharedFiles(List<SharedFile> files) async {
    for (final file in files) {
      if (file.value == null) continue;

      final type = _detectType(file.value!.split('.').last);
      if (type == null) continue;

      await MemeDatabase.instance.addFile(
        MemeFile(
          path: file.value!,
          displayName: file.value!.split('/').last,
          type: type,
          isRecent: true,
        ),
      );
    }

    await _loadFromDatabase();
  }

  // ==================================================
  // ================= DELETE =========================
  // ==================================================

  void deleteFile(MemeFile file) async {
    await MemeDatabase.instance.deleteFile(file.id!);
    await _loadFromDatabase();
  }

  void deleteSelectiveFiles(List<MemeFile> list, Set<int> indexes) async {
    for (final index in indexes) {
      // await MemeDatabase.instance.deleteFile(list[index].id!);
      deleteFile(list[index]);
    }
    // await _loadFromDatabase();
  }

  // ==================================================
  // ================= UPDATE =========================
  // ==================================================

  void addToRecent(MemeFile file) async {
    final updated = file.copyWith(isRecent: true);
    // await MemeDatabase.instance.updateFile(updated);
    deleteFile(file);
    MemeDatabase.instance.addFile(updated);
    await _loadFromDatabase();
  }

  void renameFile(MemeFile file,String newName) async {
    final updated = file.copyWith(displayName: newName);
    await MemeDatabase.instance.updateFile(updated);
    await _loadFromDatabase();
  }

  // ==================================================
  // ================= SHARE ==========================
  // ==================================================

  void shareSingleFile(MemeFile file) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)]),
    );
  }

  void shareMultipleFiles(List<MemeFile> list, Set<int> indexes) async {
    final files = indexes.map((i) => XFile(list[i].path)).toList();
    await SharePlus.instance.share(
      ShareParams(files: files),
    );
  }

  // ==================================================
  // ================= HELPERS ========================
  // ==================================================

  String? _detectType(String? ext) {
    if (ext == null) return null;
    ext = ext.toLowerCase();

    if (['jpg', 'png', 'jpeg'].contains(ext)) return 'image';
    if (['mp3', 'wav', 'aac', 'opus'].contains(ext)) return 'audio';
    if (['webp', 'gif', 'mp4'].contains(ext)) return 'sticker';
    return null;
  }
}
