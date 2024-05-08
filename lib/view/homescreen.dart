import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pit/helpers/Preferences.dart';

import 'package:pit/utils/getLocation.dart';
import 'package:pit/utils/popUpError.dart';
import 'package:pit/view/akun.dart';
import 'package:pit/view/homepage.dart';
import 'package:pit/view/login_phone.dart';

import 'package:pit/view/task_detail.dart';
import 'package:pit/view/task_report.dart';
import 'package:pit/view/task_worksheet.dart';
import 'package:provider/provider.dart';

import '../model/mNetwork.dart';
import '../model/mNotification.dart';
import '../network/CheckDataConnection.dart';
import '../network/master.dart';
import '../network/task.dart';
import '../network/user.dart';
import '../network/worksheet.dart';
import '../notifier/UserNotifier.dart';
import '../notifier/tabNotifier.dart';
import '../themes/AppTheme.dart';
import '../utils/SizeConfig.dart';
import '../utils/boxData.dart';
import '../utils/notificationApi.dart';

// Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

class HomeScreen extends StatefulWidget {
  final int _currentIndex;

  HomeScreen(this._currentIndex);

  @override
  State<StatefulWidget> createState() {
    return _HomeState(_currentIndex);
  }
}

class _HomeState extends State<HomeScreen> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  dynamic dataDashboard = {};
  int _currentIndex;
  Timer? AutoSaveTask;
  Timer? AutoSendGeolocate;
  Timer? autoCekUserActive;
  Timer? autoShowNotif;
  Timer? ResetAutoSaveTask;
  bool responseData = true;
  bool trigger_notif = false;
  callback(newValue) {
    // setState(() {
    trigger_notif = newValue;
    // print('values 213');
    // print(values);
    // });
  }

  dynamic dataNotif = null;
  _HomeState(this._currentIndex);

  //firebase
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  int countMessageReceived = 0;
  PushNotification? _notificationInfo;
  checkForInitialMessage() async {
    print("check for initial message");
    // await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      print('ini dari get init');

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("${message}")));
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("${message!.data['click_action']}")));

      //TODO test message background
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${message.data}")));
        // await redirectNotifFromInit(message.data);

        // final AddMessage = boxData(nameBox: "box_listMessages");
        // await AddMessage.addMessage(
        //     title: "${message.data['name']}",
        //     body: "${message.data['customer']}  ${message.data['jarak']}",
        //     data: message.data);
        final updateNotif = boxData(nameBox: "box_loncengNotif");
        updateNotif.updateTriggerNotif(param: true);
        // if (message.data.isNotEmpty) {
        //   if (message.data['name'] != null &&
        //       message.data['customer'] != null) {
        //   }
        // }
      } else {
        print("message empty");
      }
    });

    // if (initialMessage != null) {
    //   PushNotification notification = PushNotification(
    //     title: initialMessage.notification?.title,
    //     body: initialMessage.notification?.body,
    //   );
    //   setState(() {
    //     _notificationInfo = notification;
    //     _totalNotifications++;
    //   });
    // }
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) async {
    if (payload != "" && payload != null) {
      print(payload);
      print('onclicked notification');
      // print(dataNotif);
      // if (dataNotif != null) {
      final getUserid = boxData(nameBox: "box_setLoginCredential");
      String userid = await getUserid.getLoginCredential(param: "userId");
      await Hive.openBox("box_listMessages");
      if (Hive.isBoxOpen("box_listMessages")) {
        print('ini ke run get data notif');
        Hive.box("box_listMessages").close();
      }
      await Hive.openBox("box_listMessages");
      var OpenNotif = await Hive.openBox("box_listMessages");
      if (OpenNotif.isOpen) {
        // print('11');
        var getNotif = OpenNotif.get(userid);
        if (getNotif != null) {
          // print('22');
          for (var value in getNotif) {
            // print("value['id']");
            // print(value);
            if (value['taskid'] == payload) {
              dataNotif = value;
              break;
              // }
            }
          }
        }
      }
      // print("dataNotif");
      // print(dataNotif['data']['direct']);
      // print(dataNotif['data']['direct'].runtimeType);
      if (mounted) {
        String data = "";
        if (dataNotif['data']['direct'].runtimeType == bool) {
          if (dataNotif['data']['direct'] == true) {
            data = "true";
          } else {
            data = "false";
          }
        } else if (dataNotif['data']['direct'].runtimeType == String) {
          data = dataNotif['data']['direct'];
        }
        if (data == "true") {
          print("mounted ke trigger");
          await redirectNotif_Task_Accepted(userId: userid, message: dataNotif);
        } else if (data == "false") {
          await redirectNotif(dataNotif);
        }
      }

      //nanti klo sempet tambah data buat offine lonceng

      // final AddMessage = boxData(nameBox: "box_listMessages");
      // await AddMessage.addMessage(
      //     title: "${dataNotif.data['name']}",
      //     body: "${dataNotif.data['customer']}  ${dataNotif.data['jarak']}",
      //     data: dataNotif.data,
      //     onclick: true);
    }
  }

  Future<void> redirectNotif_Task_Accepted(
      {String? userId, dynamic message}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // final notifApi = NotificationApi();
            // await notifApi.drainStream();
            // Navigator.pop(context);
            return false;
          },
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: AppTheme.warnaUngu,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .07,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        // backgroundColor: Colors.transparent,
                        color: AppTheme.warnaHijau,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    TaskNetwork objTaskNetwork = TaskNetwork();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position _locationData = await Geolocator.getCurrentPosition(
          // forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.high);
      var lat = _locationData.latitude;
      var long = _locationData.longitude;
      Map<String, dynamic> Task = {};
      Map<String, dynamic> detailTask = {};
      final notifApi = NotificationApi();
      //TODO fungsi untuk auto close popup jika popup nge freeze
      bool autoClose = false;
      Future.delayed(const Duration(seconds: 15), () async {
        if (!autoClose) {
          print("autoclose is active");
          bool cekDrain = await notifApi.drainStream(
              "from home screen redirect task direct with tic auto close because loading more than 15 seconds ");
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Pekerjaan gagal di ambil, harap periksa notifikasi untuk mengambil kembali")));
          }
        } else {
          print("autoclose is not active");
        }
      });

      //close tag
      Network objNetwork = await objTaskNetwork.getTaskList(
          strUserId: userId, Status: "OnGoing", Lat: lat, Lng: long);

      if (objNetwork.Status) {
        autoClose = true;
        final result = objNetwork.Data;
        print("result redirect with tic");
        print(result);
        print(message['taskid'].runtimeType);
        if (result != null) {
          for (var val in result) {
            print(val['id'].runtimeType);
            if (val['id'].toString() == message['taskid']) {
              await notifApi
                  .drainStream("from home screen redirect task with tic ");
              print("val id dan taskid is the same");
              print(val);
              Task = val;
              //TODO save task to listtask
              final BoxData = boxData(nameBox: "box_listPekerjaan");
              await BoxData.addTaskToListTask(
                  dataTask: val, handoff: val['handoff']);

              var box_DetailList = await Hive.openBox("box_detailPekerjaan");
              if (box_DetailList.isNotEmpty) {
                detailTask = Map<String, dynamic>.from(
                    box_DetailList.get(Task['id'].toString()));
                Navigator.pop(context);

                // ModalRoute.of(context)!.settings.name;
                print("routs");
                String markedPage = "";
                final BoxData = boxData(nameBox: "box_MarkedPage");
                markedPage = await BoxData.getMarkedPage();
                print(markedPage);
                if (markedPage == "task_worksheet" ||
                    markedPage == "select_item_urutkan") {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _currentIndex = 1;

                  // setState(() {});
                } else if (markedPage == "task_detail" ||
                    markedPage == "task_list_adapter_open" ||
                    markedPage == "profile" ||
                    markedPage == "notification") {
                  Navigator.pop(context);

                  _currentIndex = 1;
                  // setState(() {});
                } else if (markedPage == "listTimeSheet" ||
                    markedPage == "information" ||
                    markedPage == "select_item") {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  _currentIndex = 1;
                  // setState(() {});
                } else {
                  if (markedPage == "task_list_adapter") {
                    _currentIndex = 1;
                    // setState(() {});
                  }
                }

                setState(() {});
              }
              break;
            }
          }
        } else {
          // print("kesini nih");
        }
      } else {}
      //get taskdetail

      //close tag
      //
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => HomeScreen(1),
      //     ),
      //     (route) => false);

      if (Task.isNotEmpty) {
        print('message dari redirect');
        print(message);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetail(Task, "OnGoing",
                Task['status_worksheet'], message['idmessage']),
          ),
        );
        String btnname = "";
        if (Task["status_worksheet"] == '2') {
          btnname = 'Fixing';
        }
        int tabBar = 1;

        final fillData = {
          "tabBar": tabBar,
          "pause": "aktif",
          "btnname": btnname,
          "page2": int.parse(Task["status_worksheet"])
        };

        final objBox = boxData(nameBox: 'box_workSheetSetting');
        var data = await objBox.getValueSettingFormWorksheet(
            userid: userId, taskid: Task["id"].toString());
        print("data");
        print(data);
        // print(data['result']);
        if (data == null) {
          objBox.addDataSettingFormWorksheet(
              userId, Task["id"].toString(), fillData);
        } else {
          tabBar = data!['tabBar'];
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<TabNotifier>(
                create: (context) => TabNotifier(Task),
                child: Builder(builder: (BuildContext context) {
                  return TaskWorksheetMenu(
                      Task, detailTask, 1, "OnGoing", Task['status_worksheet']);
                })),
          ),
        );
      }
      //ngurangin total notif ketika pekerjaan langsung di ambil
      // final updateNotif = boxData(nameBox: 'box_loncengNotif');
      // await updateNotif.updateTriggerNotif(param: false);
    } else {
      showAlertDialog(context, serviceEnabled);
    }
  }

  showAlertDialog(BuildContext context, bool cekLocation) {
    String Info = "";
    var HowtoActivLoc = RichText(text: TextSpan(children: []));

    if (!cekLocation) {
      Info = "Harap izinkan permission lokasi di device anda";

      HowtoActivLoc = RichText(
        text: const TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: '\n\n\nCara aktifkan Location Permission :\n\n'),
            TextSpan(text: '1. pilih '),
            TextSpan(
                text: 'Allow', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' pada pop up Permission, atau\n\n'),
            //cara 2
            TextSpan(text: '2. pilih '),
            TextSpan(
                text: 'Setting/Pengaturan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            // TextSpan(text: '  atau '),
            // TextSpan(
            //     text: 'Pengaturan',
            //     style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' pada Handphone anda, kemudian'),
            TextSpan(text: ' pilih '),
            TextSpan(
                text: 'Aplikasi/Application',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ', pilih '),
            TextSpan(
                text: 'Permission',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ', lalu geser tombol pada '),
            TextSpan(
                text: 'Lokasi/Location',
                style: TextStyle(fontWeight: FontWeight.bold)),
            // TextSpan(text: ' atau '),
            // TextSpan(
            //     text: 'Location',
            //     style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    Widget continueButton = TextButton(
      child: Text("kembali ke Beranda"),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(0),
            ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 130, horizontal: 30),

      // actionsPadding: EdgeInsets.only(top: 10),
      title: const Text(
        "Informasi",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              Info,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            HowtoActivLoc,
          ],
        ),
      ),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> redirectNotif(dynamic message) async {
    print("message");
    print(message);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // final notifApi = NotificationApi();
            // await notifApi.drainStream();
            // Navigator.pop(context);
            return false;
          },
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: AppTheme.warnaUngu,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .10,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        // backgroundColor: Colors.transparent,
                        color: AppTheme.warnaHijau,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    TaskNetwork objTaskNetwork = TaskNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();

    if (cekKoneksi.Status) {
      final getloc = Location();
      var dataLat = getloc.lat;
      var dataLong = getloc.long;
      var dataLoc = await getloc.getLocation();
      // return dataLocal;
      //delete return diatas klo data sudah real di cek dari api task/list
      final notifApi = NotificationApi();
      //TODO fungsi untuk auto close popup jika popup nge freeze
      bool autoClose = false;
      Future.delayed(const Duration(seconds: 15), () async {
        if (!autoClose) {
          bool cekDrain = await notifApi.drainStream(
              "from home screen redirect task open auto close because loading more than 15 seconds ");
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Pekerjaan gagal di ambil, harap periksa notifikasi untuk mengambil kembali")));
          }
        } else {
          print("autoclose is not active");
        }
      });

      //close tag
      Network objNetwork = await objTaskNetwork.getTaskList(
          strUserId: userId,
          Status: "Open",
          Lat: getloc.lat ?? 0,
          Lng: getloc.long ?? 0);

      if (objNetwork.Status) {
        autoClose = true;
        bool closePopup = false;
        bool backpage = false;
        for (var value in objNetwork.Data) {
          if (value['id'].toString() == message['data']['id']) {
            await notifApi.drainStream("from home screen redirect task open ");

            Navigator.of(context).pop();
            backpage = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TaskDetail(value, "Open",
                        value['status_worksheet'], message['idmessage']))) ??
                true;
            // final BoxData = boxData(nameBox: "box_MarkedPage");
            // await BoxData.markedPage(namePage: "homepage");

            closePopup = false;
            break;
          } else {
            closePopup = true;
          }
        }
        print("close popup");
        print(closePopup);
        final BoxData = boxData(nameBox: "box_MarkedPage");
        await BoxData.markedPage(namePage: "homepage");
        if (backpage) {
          Navigator.pop(context);
        }
        if (closePopup) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Pekerjaan sudah diambil teknisi lain")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(objNetwork.Message ?? "")));
      }
    } else {
      final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, true, mounted);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("anda tidak terhubung ke jaringan internet")));
    }
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    // await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission onmessage');

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        bool dismissPopUp = true;
//TODO show dialog
//         print("onmessage active 0");
//         print(message != null);
//         print(message.data['id']);
//         print(message.data['name']);
//         print(message.data['customer']);
        if (message != null) {
          // int messageid = int.parse(message.data['id']);
          // print("onmessage active 1");
          if (message.data['name'] != null &&
              message.data['customer'] != null) {
            dataNotif = message;

            // print("onmessage active 2");
            //disabled 30082022
            //     var rng = Random();
            //   NotificationApi.showNotification(
            //       id: rng.nextInt(100),
            //       title: "${message.data['name']}",
            //       body: "${message.data['customer']}  ${message.data['jarak']}",
            //       payload: message.data['id']);
            //close tag
            final box = boxData(nameBox: "box_showNotif");
            Map data = {"data": message.data};
            if (message.data['id'] != null) {
              box.addDataShowNotif(message.data['id'], Map.from(message.data));
            }
          }
          //disabled 30082022
          // final addMessage = boxData(nameBox: "box_listMessages");
          // await addMessage.addMessage(
          //     title: "${message.data['name']}",
          //     body: "${message.data['customer']}  ${message.data['jarak']}",
          //     data: message.data);
          // //TODO: nambah hitungan total pesan
          // final updateNotif = boxData(nameBox: 'box_loncengNotif');
          // await updateNotif.updateTriggerNotif(param: true);

          //close tag

        }
        // setState(() {});
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AutoSaveTask!.cancel();
    AutoSendGeolocate!.cancel();
    autoCekUserActive!.cancel();
    super.dispose();
  }

  void _runWhileAppIsTerminated() async {
    var details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if (details!.didNotificationLaunchApp) {
      if (details.payload != null) {
        // if (dataNotif != null) {
        final getUserid = boxData(nameBox: "box_setLoginCredential");
        String userid = await getUserid.getLoginCredential(param: "userId");
        await Hive.openBox("box_listMessages");
        if (Hive.isBoxOpen("box_listMessages")) {
          print('ini ke run get data notif');
          Hive.box("box_listMessages").close();
        }
        await Hive.openBox("box_listMessages");
        var OpenNotif = await Hive.openBox("box_listMessages");
        if (OpenNotif.isOpen) {
          var getNotif = OpenNotif.get(userid);
          if (getNotif != null) {
            for (var value in getNotif) {
              print(value);
              if (value['taskid'] == details.payload) {
                dataNotif = value;
                break;
                // }
              }
            }
          }
        }
        // print(dataNotif.data);

        await redirectNotif(dataNotif);
      }
    }
  }

  alertUserActive(BuildContext context, int userid, String phone) {
    Widget continueButton = TextButton(
        child: const Text("Logout"),
        onPressed: () async {
          Preferences pref = Preferences();
          await pref.SetUserActive(0);
          final boxdata = boxData(nameBox: "box_setLoginCredential");
          boxdata.setLoginCredential(
              secretKey: "", token: "", Phone: "", UserId: "", Otp: "");

          final notifApi = NotificationApi();
          await notifApi
              .drainStream("force logout if another user access this account");
          // Navigator.pop(context);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPhone(),
          //     ));
          await FirebaseMessaging.instance.deleteToken().then((value) {
            print("token from firebase has deleted");
          });

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPhone(),
              ),
              (route) => false);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPhone(),
          //     ));
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 130, horizontal: 30),

      // actionsPadding: EdgeInsets.only(top: 10),
      title: const Text(
        "Peringatan",
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Akun anda sedang aktif di device lain, anda harus logout terlebih dahulu",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert);
      },
    );
  }

  sessionExpired(BuildContext context) async {
    Widget continueButton = TextButton(
        child: const Text("Logout"),
        onPressed: () async {
          Preferences pref = Preferences();
          await pref.SetUserActive(0);
          // final boxdata = boxData(nameBox: "box_setLoginCredential");
          // boxdata.setLoginCredential(
          //     secretKey: "", token: "", Phone: "", UserId: "", Otp: "");

          final notifApi = NotificationApi();
          await notifApi.drainStream("force logout because session expired");
          // Navigator.pop(context);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPhone(),
          //     ));
          await FirebaseMessaging.instance.deleteToken().then((value) {
            print("token from firebase has deleted");
          });

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPhone(),
              ),
              (route) => false);
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPhone(),
          //     ));
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),

      // actionsPadding: EdgeInsets.only(top: 10),
      title: const Text(
        "Peringatan",
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Odoo session expired, anda harus login ulang kembali.",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert);
      },
    );
  }

  cekUserActive() async {
    autoCekUserActive =
        Timer.periodic(const Duration(seconds: 9), (Timer t) async {
      final getUserid = boxData(nameBox: "box_setLoginCredential");
      final userid = await getUserid.getLoginCredential(param: "userId");
      final token = await getUserid.getLoginCredential(param: "token");
      final secretKey = await getUserid.getLoginCredential(param: "secretKey");
      final phone = await getUserid.getLoginCredential(param: "phone");
      final OpenUserToken = await Hive.openBox("box_usertoken");
      final user_token = OpenUserToken.get(phone);
      if (userid != "" && token != "" && secretKey != "") {
        masterNetwork objMasterProd = masterNetwork();
        var result = await objMasterProd.cekUserActive(int.parse(userid));
        // print("result.Data");
        // print(result.Data);

        if (result.Data != null) {
          // print("user_token");
          // print(user_token);
          // print(result.Data);
          // print(result.Data['token']);
          if (user_token != result.Data['token']) {
            alertUserActive(context, int.parse(userid), phone);
            autoCekUserActive!.cancel();
          }
        }
      } else {
        //TODO edited 16092022
        Preferences pref = Preferences();
        bool checkLoginManual = await pref.getLogoutManual();
        print("checkLoginManual");
        print(checkLoginManual);
        if (!checkLoginManual) {
          sessionExpired(context);
        }
        autoCekUserActive!.cancel();
      }
    });
  }

  cekShowNotif() async {
    final box = boxData(nameBox: "box_showNotif");
    autoShowNotif =
        Timer.periodic(const Duration(milliseconds: 1500), (Timer t) async {
      // print("cekshownotif");
      var message = await box.getDataShowNotif();
      // print("messagej from cekShowNotif");
      // print(message);
      if (message != 0) {
        var rng = Random();
        NotificationApi.showNotification(
            id: rng.nextInt(100),
            title: "${message['name']}",
            body: "${message['customer']}   Jarak ${message['distance']} KM",
            payload: message['id']);
        final addMessage = boxData(nameBox: "box_listMessages");
        if (message['id'] != null) {
          await addMessage.addMessage(
              title: "${message['name']}",
              body: "${message['customer']}  Jarak ${message['distance']} KM",
              data: message);
        }
        await box.deleteDataShowNotif(message['id']);
        //TODO: nambah hitungan total pesan
        final updateNotif = boxData(nameBox: 'box_loncengNotif');
        await updateNotif.updateTriggerNotif(param: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cekUserActive();
    cekShowNotif();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationApi.init();
    // checkForInitialMessage();

    _totalNotifications = 0;
    registerNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // dataNotif = message;
      int _totalNotifications = 0;
      //TODO process messages
      if (message != null && message.data.isNotEmpty) {
        if (message.data['name'] != null && message.data['customer'] != null) {
          await redirectNotif(message);
        }
      }

      print(
          "message.notification nambilin data di background ketika app di hide");

      setState(() {});
    });
    listenNotifications();

    _runWhileAppIsTerminated();
    //TODO:Firebase

    autoSavedTask();
    autoSendGeolocate();
  }

  autoSendGeolocate() async {
    AutoSendGeolocate =
        Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      Preferences pref = Preferences();
      int user_active = await pref.getUserActive();
      Connection objCekConnection = Connection();
//mattin ketika user active false
      Network cekKoneksi = await objCekConnection.CheckConnection();
      if (cekKoneksi.Status && user_active == 1) {
        // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        // print("service location status");
        // print(permission != LocationPermission.denied);

        if (permission != LocationPermission.denied) {
          Position _locationData = await Geolocator.getCurrentPosition(
              // forceAndroidLocationManager: true,
              // timeLimit: Duration(seconds: 1),
              desiredAccuracy: LocationAccuracy.best);
          var lat = _locationData.latitude;
          var long = _locationData.longitude;
          if (lat != null && long != null) {
            UserNetwork objUserNetwork = UserNetwork();
            // print("lat long");
            // print("${lat}, ${long}");
            // print("${_locationData.latitude}, ${_locationData.longitude}");
            Network objNetwork =
                await objUserNetwork.sendGeolocate(lat: lat, long: long);
            if (objNetwork.Status) {
              // print("geolocate keterima");
            }
          }
        }
      }
    });
  }

  cekTrigger_listUpload() async {}
  autoSavedTask() async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    AutoSaveTask =
        Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
      Connection objCekConnection = Connection();
      String strUserId = await boxdata.getLoginCredential(param: "userId");
      Network cekKoneksi = await objCekConnection.CheckConnection();

      if (cekKoneksi.Status) {
        // responseData = true;

        if (strUserId != "" && strUserId != null && responseData) {
          int count = 1;

          // isi box upload status worksheet
          var listUploadWorksheet =
              await Hive.openBox("box_listUploadWorksheet");

          if (listUploadWorksheet.isNotEmpty) {
            var datalistUpload =
                List.from(listUploadWorksheet.get(strUserId) ?? []);

            // if (datalistUpload.length >= 2) {
            //   datalistUpload.sort((a, b) {
            //     return (a['id']).compareTo(b['id']);
            //   });
            // }

            if (datalistUpload.isNotEmpty) {
              print("responseData");
              print(responseData);
              print("ini ada kali");
              print(datalistUpload);
              responseData = false;
              for (int i = 0; datalistUpload.length > i; i++) {
                if (count == 2) {
                  break;
                }
                if (!cekKoneksi.Status) {
                  break;
                }
                // if (datalistUpload[i]['upload'] == 0) {
                //nanti tes 3 data
                if (count < 2) {
                  print(datalistUpload[i]);
                  if (datalistUpload[i]['status'] == "1") {
                    await savetoServer(
                      Id: datalistUpload[i]['id'],
                      userId: strUserId,
                      taskId: datalistUpload[i]['taskid'],
                      Status: datalistUpload[i]['status'],
                      Date: datalistUpload[i]['timesheet_date'],
                      duration: datalistUpload[i]['timesheet_duration'],
                      Desc: datalistUpload[i]['timesheet_description'],
                      open: datalistUpload[i]['open'],
                    );
                  } else {
                    await savetoServer(
                      Id: datalistUpload[i]['id'],
                      userId: strUserId,
                      taskId: datalistUpload[i]['taskid'],
                      Status: datalistUpload[i]['status'],
                      Date: datalistUpload[i]['timesheet_date'],
                      duration: datalistUpload[i]['timesheet_duration'],
                      Desc: datalistUpload[i]['timesheet_description'],
                      open: datalistUpload[i]['open'],
                    );
                  }

                  // if (!manualSave && Id != 0) {

                  count++;
                }
                // }
              }
            }
          } else {
            // print('kosong list auto upload');
          }
        } else {
          // print("userid is empty");
        }
      }
    });
  }

  Future<bool> savetoServer({
    int? Id,
    String? userId,
    dynamic taskId,
    String? Status,
    String? Date,
    int? duration,
    String? Desc,
    int? open,
  }) async {
    // responseData = false;
    var WorksheetForm = await Hive.openBox("box_valworksheet");

    if (WorksheetForm.isNotEmpty) {
      // var data = WorksheetForm.get(userId);
      print("taskId.toString()");
      print(taskId.toString());
      final objBox = boxData(nameBox: 'box_valworksheet');
      Map<String, dynamic> dataValue = await objBox.getValueWorksheet(
          taskid: taskId.toString(), userid: userId);
      Map<String, dynamic> dataFilter = {};
      dataValue.forEach((i, value) {
        // print('index=$i, value=$value');
        // print(value.runtimeType);
        if (value != false && value != null && value != "") {
          dataFilter[i] = value;
        }
      });
      final boxdata = boxData(nameBox: "box_setLoginCredential");

      String userid = await boxdata.getLoginCredential(param: "userId");
      var dataBox = boxData(nameBox: "box_listUploadWorksheet");
      // await dataBox.replaceUploadListTask(
      //   id: Id ?? 0,
      //   upload: 1,
      //   userId: userid,
      //   taskId: taskId.toString(),
      // );
      WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
      Network objNetwork = await objWorksheetNetwork.saveWorksheetForm(
        Id: Id,
        manualSave: false,
        userId: int.parse(userId ?? "0"),
        taskId: int.parse(taskId),
        worksheet: dataFilter,
        status: Status ?? "1",
        timesheetDate: Date ?? "",
        timesheetDesc: Desc ?? "",
        timesheetDuration: duration ?? 0,
      );
      // await dataBox.replaceUploadListTask(
      //   id: Id ?? 0,
      //   upload: 1,
      //   userId: userid,
      //   taskId: taskId.toString(),
      // );
      if (objNetwork.Status) {
        responseData = true;
      } else {
        print("gagal kirim dari autoupload");
        responseData = false;
        // await dataBox.replaceUploadListTask(
        //   id: Id ?? 0,
        //   upload: 0,
        //   userId: userid,
        //   taskId: taskId.toString(),
        // );
        // if (objNetwork.Error != "" && objNetwork.Error != null) {
        //   if (mounted) {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         duration: Duration(seconds: 5),
        //         content: Text(objNetwork.Error!)));
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         duration: Duration(seconds: 10),
        //         content: Text(
        //             "Server sedang gangguan,harap melapor ke admin dan gunakan pada mode offline sampai server sudah dapat digunakan kembali")));
        //   }
        //   Future.delayed(new Duration(seconds: 300), () async {
        //     print("timer for waiting reset cause error from server");
        //
        //     responseData = true;
        //   });
        // } else {
        Future.delayed(new Duration(seconds: 5), () async {
          print("timer for waiting reset ");

          responseData = true;
        });
      }
    } else {
      //
    }
    return true;
  }

  Future<void> getData() async {
    masterNetwork objMasterProd = masterNetwork();
    Network objMasterNetwork = await objMasterProd.getMasterProduct();
  }

  final List<Widget> _children = [
    HomePage(),
    TaskReport(),
    ChangeNotifierProvider<UserNotifier>(
      create: (context) => UserNotifier(),
      child: Builder(builder: (BuildContext context) {
        return Account();
      }),
    )
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          _currentIndex = 0;
          setState(() {});
          return false;
        } else {
          SystemNavigator.pop();
          // Navigator.pop(context);
          return true;
        }

        // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppTheme.warnaHijau,
            unselectedItemColor: Color(0xFF060606),
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded), label: "")
            ],
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
