import 'package:flutter/material.dart';
// import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
// import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:memetic_whats/providers/API_testing.dart';
import 'package:memetic_whats/providers/file_provider.dart';
import 'package:provider/provider.dart';
import 'lists/recent_list.dart';
// import 'picking_files.dart';
// import 'dart:async';

// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProvider(create: (context) => ApiTesting()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memes Repo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RecentList(),
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late StreamSubscription _intentDataStreamSubscription;
//   List<SharedFile>? list;
//   @override
//   void initState() {
//     super.initState();
//     // For sharing images coming from outside the app while the app is in the memory
//     _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream()
//         .listen((List<SharedFile> value) {
//       setState(() {
//         list = value;
//       });
//       print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
//     }, onError: (err) {
//       print("getIntentDataStream error: $err");
//     });

//     // For sharing images coming from outside the app while the app is closed
//     FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) {
//       print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
//       setState(() {
//         list = value;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 24),
//               child: Text('Sharing data: \n${list?.join("\n\n")}\n')),
//         ),
//       ),
//     );
//   }
//   @override
//   void dispose() {
//     _intentDataStreamSubscription.cancel();
//     super.dispose();
//   }
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
// class _MyAppState extends State<MyApp> {
//   late StreamSubscription _intentSub;
//   final _sharedFiles = <SharedMediaFile>[];
//   @override
//   void initState() {
//     super.initState();
//     // Listen to media sharing coming from outside the app while the app is in the memory.
//     _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
//       setState(() {
//         _sharedFiles.clear();
//         _sharedFiles.addAll(value);
//         print(_sharedFiles.map((f) => f.toMap()));
//       });
//     }, onError: (err) {
//       print("getIntentDataStream error: $err");
//     });
//     // Get the media sharing coming from outside the app while the app is closed.
//     ReceiveSharingIntent.instance.getInitialMedia().then((value) {
//       setState(() {
//         _sharedFiles.clear();
//         _sharedFiles.addAll(value);
//         print(_sharedFiles.map((f) => f.toMap()));
//         // Tell the library that we are done processing the intent.
//         ReceiveSharingIntent.instance.reset();
//       });
//     });
//   }
//   @override
//   void dispose() {
//     _intentSub.cancel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Text("Shared files:", style: textStyleBold),
//               Text(_sharedFiles
//                       .map((f) => f.toMap())
//                       .join(",\n****************\n")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }