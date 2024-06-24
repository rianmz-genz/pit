import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';

import 'package:pit/network/task.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/boxData.dart';

import 'package:pit/utils/notificationApi.dart';

import 'package:pit/view/homescreen.dart';

import 'package:pit/view/login_phone.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Future<dynamic> initIsolate() async {
//   Completer completer = Completer<SendPort>();
//   var isolateToMainStream = ReceivePort();
//
//   isolateToMainStream.listen((data) async {
//     if (data is SendPort) {
//       var mainToIsolateStream = data;
//       completer.complete(mainToIsolateStream);
//     } else {
//       print('[isolateToMainStream] $data');
//     }
//   });
//
//   await Isolate.spawn(myIsolate, isolateToMainStream.sendPort);
//   return completer.future;
// }
//
// void myIsolate(SendPort isolateToMainStream) {
//   var mainToIsolateStream = ReceivePort();
//   isolateToMainStream.send(mainToIsolateStream.sendPort);
//   dynamic datas;
//   mainToIsolateStream.listen((data) {
//     print('[mainToIsolateStream] $data');
//     datas = data;
//     // exit(0);
//   });
//
//   isolateToMainStream.send(datas);
// }

// Future<bool> checkMessageExist(String userId, dynamic dataNotif) async {
//   print('fungsi masuk');
//   // final boxdata = boxData(nameBox: "box_setLoginCredential");
//   //
//   // String userId = await boxdata.getLoginCredential(param: "userId");
//   final box_OpenListMessage = await Hive.openBox("box_listMessages");
//   if (box_OpenListMessage.isOpen) {
//     final box_AddMessage = Hive.box("box_listMessages");
//
//     if (box_OpenListMessage.isOpen) {
//       bool checkdata = false;
//       if (box_OpenListMessage.isNotEmpty) {
//         var data = box_OpenListMessage.get(userId);
//         print('data');
//         print(data);
//         if (data != null) {
//           for (var val in data) {
//             if (dataNotif['id'] == val['data']['id']) {
//               print('masuk sini cek data');
//               checkdata = false;
//               return true;
//             } else {
//               checkdata = true;
//             }
//           }
//           if (checkdata) {
//             return false;
//           }
//         }
//       }
//       return false;
//     }
//   }
//   return false;
// }

updateTriggerNotif({bool param = false}) async {
  if (Hive.isBoxOpen("box_loncengNotif")) {
    Hive.box('box_loncengNotif').close();
  }
  await Hive.openBox("box_loncengNotif");

  var openboxLocengnotif = await Hive.openBox("box_loncengNotif");

  if (openboxLocengnotif.isOpen) {
    String userid = "";
    final getUserid = boxData(nameBox: "box_setLoginCredential");
    userid = await getUserid.getLoginCredential(param: "userId");
    var updateLocengnotif = Hive.box("box_loncengNotif");
    Map data = {"loncengNotif": param};
    if (updateLocengnotif.isNotEmpty) {
      updateLocengnotif.put(userid, data);
    }
  }
  if (Hive.isBoxOpen("box_loncengNotif")) {
    Hive.box('box_loncengNotif').close();
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await NotificationApi.init();
  // DartPluginRegistrant.ensureInitialized();

  if (Platform.isAndroid) PathProviderAndroid.registerWith();
  // print('dir main');
  // var mainToIsolateStream = await initIsolate();
  // mainToIsolateStream.send(message);

  var dir = await getApplicationDocumentsDirectory();
  print(dir);
  Hive.init(dir.path);
  print("message.data");
  print(message.data);
  if (Hive.isBoxOpen("box_listMessages")) {
    await Hive.box("box_listMessages").close();
  }
  if (Hive.isBoxOpen("box_loncengNotif")) {
    await Hive.box("box_loncengNotif").close();
  }

  await Hive.openBox("box_loncengNotif");

  await Hive.openBox("box_listMessages");

  await Hive.openBox("box_setLoginCredential");
  String userid = "";
  final getUserid = boxData(nameBox: "box_setLoginCredential");
  userid = await getUserid.getLoginCredential(param: "userId");
  TaskNetwork objTaskNetwork = TaskNetwork();

  if (message.data['name'] != null && message.data['customer'] != null) {
    print('popup munculllll');
    var rng = Random();
    NotificationApi.showNotification(
        id: rng.nextInt(100),
        title: "${message.data['name']}",
        body:
            "${message.data['customer']} Jarak ${message.data['distance']} KM",
        payload: message.data['id']);
  }

  print("message.notification nambilin data di background ketika app di close");
  print(message.data);
  //TODO:tambah pesan ke list
  final AddMessage = boxData(nameBox: "box_listMessages");
  await AddMessage.addMessage(
      title: "${message.data['name']}",
      body: "${message.data['customer']} Jarak ${message.data['distance']} KM",
      data: message.data);
  //TODO: nambah hitungan total pesan
  await updateTriggerNotif(param: true);
  if (Hive.isBoxOpen("box_listMessages")) {
    await Hive.box("box_listMessages").close();
  }
  if (Hive.isBoxOpen("box_loncengNotif")) {
    await Hive.box("box_loncengNotif").close();
  }
}

// Future<void> addMessage({String? title, String? body, dynamic data}) async {
//   if (Hive.isBoxOpen("box_listMessages")) {
//     await Hive.box("box_listMessages").close();
//   }
//
//   final box_OpenListMessage = await Hive.openBox("box_listMessages");
//   if (box_OpenListMessage.isOpen) {
//     final box_AddMessage = Hive.box("box_listMessages");
//     final boxdata = boxData(nameBox: "box_setLoginCredential");
//
//     String userId = await boxdata.getLoginCredential(param: "userId");
//     print(userId);
//     DateTime timeMessage = DateTime.now();
//
//     Map<String, dynamic> dataSave = {"taskid": data['id']};
//     if (box_OpenListMessage.isNotEmpty) {
//       var dataGet = box_OpenListMessage.get(userId);
//       if (dataGet != null && dataGet.length != 0) {
//         dataSave['idmessage'] = dataGet.length;
//         dataSave['title'] = title;
//         dataSave['body'] = body;
//         dataSave['time'] = timeMessage.millisecondsSinceEpoch;
//         dataSave['data'] = data;
//         dataSave['messageOpen'] = false;
//         print("dataSave1");
//         print(dataSave);
//         dataGet.insert(0, dataSave);
//         box_AddMessage.put(userId, dataGet);
//       } else {
//         dataSave['idmessage'] = 0;
//         dataSave['title'] = title;
//         dataSave['body'] = body;
//         dataSave['time'] = timeMessage.millisecondsSinceEpoch;
//         dataSave['data'] = data;
//         dataSave['messageOpen'] = false;
//         print("dataSave2");
//         print(dataSave);
//         box_AddMessage.put(userId, [dataSave]);
//       }
//     } else {
//       dataSave['idmessage'] = 0;
//       dataSave['title'] = title;
//       dataSave['body'] = body;
//       dataSave['time'] = timeMessage.millisecondsSinceEpoch;
//       dataSave['data'] = data;
//       dataSave['messageOpen'] = false;
//       print("dataSave3");
//       print(dataSave);
//       box_AddMessage.put(userId, [dataSave]);
//     }
//   }
//
//   if (Hive.isBoxOpen("box_listMessages")) {
//     await Hive.box("box_listMessages").close();
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  var dir = await getApplicationDocumentsDirectory();
  // print('dir main');
  print(dir);
  Hive.init(dir.path);
  //TODO:names of box
  await Hive.openBox("box_dashboard");
  await Hive.openBox("box_listPekerjaan"); //multi
  await Hive.openBox("box_historyPekerjaan"); //multi
  // await Hive.openBox("box_triggerTimer_Worksheet"); //multi
  await Hive.openBox("box_trigger_ListUpload"); //multi
  await Hive.openBox("box_TimerWorksheet"); //multi
  await Hive.openBox("box_TimerTemporary");
  await Hive.openBox("box_MarkedPage");
  await Hive.openBox("box_detailPekerjaan"); //multi
  await Hive.openBox("box_worksheetform");
  await Hive.openBox("box_valworksheet"); //multi
  // await Hive.openBox("box_listMaster"); //no multi
  await Hive.openBox("box_masterProduct"); //no multi
  await Hive.openBox("box_masterGaransi"); //no multi
  await Hive.openBox("box_workSheetSetting");
  await Hive.openBox("box_listTimesheet");
  await Hive.openBox("box_listUploadWorksheet");
  await Hive.openBox("box_listMessages");
  await Hive.openBox("box_usertoken");
  await Hive.openBox("box_setLoginCredential");
  await Hive.openBox("box_locengNotif");
  await Hive.openBox("box_showNotif");

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationApi.init();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Preferences objPreferences = Preferences();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    // String strToken = await boxdata.getLoginCredential(param: "token") ?? "";
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'PIT elektronik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.putihTheme,
      home: FutureBuilder<String?>(
        future: boxdata.getLoginCredential(param: "userId"),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          bool bolLoginValid = false;

          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data != "") {
                bolLoginValid = true;
              }

              if (bolLoginValid) {
                return const HomeScreen(0);
              } else {
                return const LoginPhone();
              }
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppTheme.warnaHijau,
              ));
            }
          }

          // print("circular");
          return const Center(
              child: CircularProgressIndicator(
            color: AppTheme.warnaHijau,
          ));
        },
      ),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   description:
//       'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
