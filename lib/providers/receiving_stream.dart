
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

class ReceivingStream extends ChangeNotifier {
  late StreamSubscription _intentDataStreamSubscription ;
  List<SharedFile>? list;

  ReceivingStream(){
    log("constructor is called");
    _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream()
        .listen((List<SharedFile> listenedFiles) {
          list =listenedFiles;
    }, onError: (err) {
      log("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> listenedFiles) {
      list = listenedFiles;
    });
  }

  @override
  void dispose() { // when does dispose() is called???????????? because the stream do not close
    log("ReceivingStream disposed");
    // if i don't cancel the stream when i get out of the app , it will create another instance of it in the RAM
    _intentDataStreamSubscription.cancel(); // 🔥 مهم
    super.dispose();
  }
}