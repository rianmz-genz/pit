import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mUser.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/popUpError.dart';

import 'package:pit/view/task_list.dart';
import 'package:provider/provider.dart';

import 'package:pit/view/notification.dart';

import '../model/mNetwork.dart';
import '../network/CheckDataConnection.dart';
import '../network/task.dart';
import '../notifier/UserNotifier.dart';
import '../themes/AppTheme.dart';
import '../utils/boxData.dart';
import '../utils/getLocation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // bool? trigger_notif;
  // Function(bool)? callback;
  // HomePage({this.trigger_notif, this.callback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool triggerNotif = false;
  bool updateNotifDashboard = true;
  bool active = false;
  Timer? autoUpdateNotif;
  Preferences pref = Preferences();
  final tanggal = DateFormat('dd').format(DateTime.now());
  late var dir;
  Map dataDasboard = {};
  @override
  void initState() {
    // TODO: implement initState
    startDashBoard();

    markedPage();
    updateNotif();
    FautoUpdateNotif();
    super.initState();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "homepage");
  }
  // trigger_Notif() {
  //   if (widget.trigger_notif) {
  //     widget.callback(false);
  //     print('data update');
  //     setState(() {});
  //   }
  // }

  startDashBoard() async {
    late var dir;

    await Hive.openBox("box_dashboard");
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    var openboxDashboard = await Hive.openBox("box_dashboard");

    if (openboxDashboard.isOpen) {
      var insertboxDashboard = Hive.box("box_dashboard");
      if (openboxDashboard.isNotEmpty) {
        var dataDasboardDB = openboxDashboard.get(userId);

        if (dataDasboardDB != null) {
          dataDasboard = dataDasboardDB;
        }
      }
    }

    setState(() {});
  }

  //fungsi untuk memperbaru lonceng notif
  FautoUpdateNotif() async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");
    autoUpdateNotif =
        Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // if (updateNotifDashboard) {

      // print(dir);
      // Hive.init(dir.path);
      if (Hive.isBoxOpen("box_loncengNotif")) {
        await Hive.box("box_loncengNotif").close();
      }
      await Hive.openBox("box_loncengNotif");
      var openboxLoncengnotif = await Hive.openBox("box_loncengNotif");

      if (openboxLoncengnotif.isOpen) {
        final update = Hive.box("box_loncengNotif");

        if (openboxLoncengnotif.isNotEmpty) {
          var data = openboxLoncengnotif.get(userid);
          if (data != null) {
            if (data['loncengNotif'] && updateNotifDashboard) {
              triggerNotif = true;
              updateNotifDashboard = false;
              if (mounted) {
                setState(() {});
              }
            } else if (!data['loncengNotif']) {
              updateNotifDashboard = true;
              if (mounted) {
                // print("matiin lonceng  dari auto run");
                // setState(() {});
              }
            }
          } else {
            final getUserid = boxData(nameBox: "box_setLoginCredential");
            userid = await getUserid.getLoginCredential(param: "userId");
            var updateLocengnotif = Hive.box("box_loncengNotif");
            Map data = {"loncengNotif": false};
            update.put(userid, data);
            setState(() {});
          }
        } else {
          final getUserid = boxData(nameBox: "box_setLoginCredential");
          userid = await getUserid.getLoginCredential(param: "userId");
          var updateLocengnotif = Hive.box("box_loncengNotif");
          Map data = {"loncengNotif": false};
          update.put(userid, data);
          setState(() {});
        }
      }
      // } else {
      //   //updateNotifDashboard
      // }

      //disable 11/08/2022
      // if (Hive.isBoxOpen("box_loncengNotif")) {
      //   await Hive.box("box_loncengNotif").close();
      // }
    });
  }

  updateNotif() async {
    dir = await getApplicationDocumentsDirectory();
    var GetTriggerNotif = boxData(nameBox: 'box_loncengNotif');
    triggerNotif = await GetTriggerNotif.getTriggerNotif(param: "loncengNotif");
    print("loncengNotif");
    print(triggerNotif);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    autoUpdateNotif!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    MySize().init(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.warnaUngu,
          centerTitle: true,
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              color: Colors.white,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notif(),
                  ),
                );

                if (mounted) {
                  setState(() {
                    updateNotif();
                  });
                }
              },
              icon: triggerNotif == true
                  ? Container(
                      child: Stack(children: [
                      const Icon(Icons.notifications, size: 30),
                      Positioned(
                        right: MySize.getScaledSizeWidth(4),
                        top: MySize.getScaledSizeHeight(4),
                        child: Container(
                          height: MySize.getScaledSizeHeight(9),
                          width: MySize.getScaledSizeWidth(9),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            // border: Border.all(
                            //   color: Colors.white70,
                            //   width: 2.0,
                            //   style: BorderStyle.solid,
                            // )
                          ),
                        ),
                      )
                    ]))
                  : const Icon(Icons.notifications, size: 30),
            ),
          ],
          title: const Text(
            'PIT Elektronik',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                ChangeNotifierProvider<UserNotifier>(
                  create: (context) => UserNotifier(),
                  child: Builder(builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: AppTheme.warnaUngu,
                      ),
                      child: Center(
                        child: Consumer<UserNotifier>(builder: (_, value, __) {
                          User _User = value.getUser();
                          int userActive = value.getuser_active();

                          if (userActive == 1) {
                            active = true;
                          } else {
                            active = false;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      // margin: EdgeInsets.all(MySize.size4!),
                                      width: MySize.getScaledSizeWidth(40),
                                      height: MySize.getScaledSizeHeight(40),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: (_User.Picture ?? "")
                                                    .toString() ==
                                                ""
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/default_gambar.png"),
                                                fit: BoxFit.fill)
                                            : DecorationImage(
                                                image: FileImage(File(
                                                    _User.Picture.toString())),
                                                fit: BoxFit.fill),
                                      ),
                                    ),
                                    Positioned(
                                      right: MySize.getScaledSizeWidth(1),
                                      top: MySize.getScaledSizeHeight(27),
                                      child: Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: active
                                                ? Colors.green
                                                : Colors.red,
                                            border: Border.all(
                                              color: Colors.white70,
                                              width: 2.0,
                                              style: BorderStyle.solid,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _User.Name ?? "Pengguna",
                                  style: const TextStyle(
                                      backgroundColor: Colors.transparent,
                                      fontSize: 17,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
                Expanded(child: dashboard(dataDasboard)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class dashboard extends StatefulWidget {
  Map dataDasboard;
  dashboard(this.dataDasboard, {super.key});

  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  Timer? reloadDashboard;
  String testfirebase = "test firebase";
  final tanggal = DateFormat('dd').format(DateTime.now());
  // late dynamic dataDasboard = {
  //   "Date": "${tanggal}",
  //   "getPekerjaan": 0,
  //   "selesaiAll": 0,
  //   "selesaiPerDay": 0,
  //   "taskDikirim": 0,
  //   "taskPendingKirim": 0,
  //   "Point": 0,
  //   // "triggerNotif": false,
  //   "triggerRefresh": false
  // };
  @override
  initState() {
    super.initState();
    //TODO:Firebase

    ReloadDashboard();
    getlistTask();
  }

  getlistTask() async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    print("userId di homepage");
    print(userId);
    TaskNetwork objTaskNetwork = TaskNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    if (cekKoneksi.Status) {
      final getloc = Location();
      var dataLat = getloc.lat;
      var dataLong = getloc.long;
      var dataLoc = await getloc.getLocation();
      var dataResult = [];
      List<dynamic> dataResultHistory = [];
      // var box_AddDetail = Hive.box("box_detailPekerjaan");
      //
      // var box_AddList = Hive.box("box_listPekerjaan");
      // var box_OpenListPekerjaan = await Hive.openBox("box_listPekerjaan");
//TODO: count Pekerjaan diambil dari ongoing/berjalan

      Network objNetwork =
          await objTaskNetwork.getTaskCount(userid: int.parse(userId));
      if (objNetwork.Status) {
        //open box list pekerjaan

        //simpan data ke dblokal
        var updateDasboard = boxData(nameBox: 'box_dashboard');
        var addList = boxData(nameBox: 'box_listPekerjaan');
        // updateDasboard.addDataDashboard(
        //     param: 'getPekerjaan', tambah: false, reset: true);
        updateDasboard.addDataDashboard(
            param: 'taskDikirim', tambah: false, reset: true);
        await addList.countListTaskOnHome(
            getpekerjaan: objNetwork.Data['CurrentTask'],
            point: objNetwork.Data['point'],
            FinishTask: objNetwork.Data['FinishTask']);
        if (mounted) {
          setState(() {});
        }
      }
      //TODO: count Pekerjaan diambil dari history

      Network objNetworkHistory = await objTaskNetwork.getTaskList(
          strUserId: userId,
          Status: "History",
          Lat: getloc.lat ?? 0,
          Lng: getloc.long ?? 0);
      if (objNetwork.Status) {
        dataResultHistory = await objNetworkHistory.Data;

        //open box list pekerjaan

        //simpan data ke dblokal
        var updateDasboard = boxData(nameBox: 'box_dashboard');
        var addHistory = boxData(nameBox: 'box_historyPekerjaan');

        updateDasboard.addDataDashboard(
            param: 'selesaiAll', tambah: false, reset: true);
        updateDasboard.addDataDashboard(
            param: 'selesaiPerDay', tambah: false, reset: true);
        // print("dataResultHistory.length");
        // print(dataResultHistory.length);
        await addHistory.countHistoryTaskOnHome(values: dataResultHistory);
      }
    } else {
     if(mounted) {
       final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, false, mounted);
     }
      // print("anda tidak terhubung ke jaringan internet");
    }
  }

  @override
  dispose() {
    reloadDashboard!.cancel();
    super.dispose();
  }

  Future<void> ReloadDashboard() async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");
    var openboxDashboard = await Hive.openBox("box_dashboard");
    if (openboxDashboard.isOpen) {
      var insertboxDashboard = Hive.box("box_dashboard");

      if (openboxDashboard.isNotEmpty) {
        var dataDasboardDB = openboxDashboard.get(userid);

        if (dataDasboardDB != null) {
          widget.dataDasboard = dataDasboardDB;
          if (dataDasboardDB['Date'] != tanggal) {
            setState(() {});
          }
          if (dataDasboardDB['triggerRefresh'] == true) {
            dataDasboardDB['triggerRefresh'] = false;
            insertboxDashboard.put(userid, dataDasboardDB);
            setState(() {});
          }
        }
      }
    }
    reloadDashboard =
        Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      // isi box upload status worksheet
      // var openbox_dashboard = await Hive.openBox("box_dashboard");
      if (openboxDashboard.isOpen) {
        var insertboxDashboardd = Hive.box("box_dashboard");

        if (openboxDashboard.isNotEmpty) {
          var dataDasboardDB = openboxDashboard.get(userid);

          if (dataDasboardDB != null) {
            widget.dataDasboard = dataDasboardDB;
            // if (dataDasboardDB['Date'] != tanggal) {
            //   setState(() {});
            // }
            if (dataDasboardDB['triggerRefresh'] == true) {
              dataDasboardDB['triggerRefresh'] = false;
              insertboxDashboardd.put(userid, dataDasboardDB);
              setState(() {});
            }
          }
          // else {
          //   insertBox_dashboard.put(userid, dataDasboard);
          //   setState(() {});
          // }
        }
        // else {
        //   insertBox_dashboard.put(userid, dataDasboard);
        //   setState(() {});
        // }

        //}
      }
    });
  }

  showAlertDialog(
      {BuildContext? context,
      bool? cekKoneksi = false,
      bool? cekLocation = false}) {
    String Info = "";
    var HowtoActivLoc = RichText(text: const TextSpan(children: []));

    // """
    // Cara aktifkan Location Permission :
    // 1. pilih **Allow** pada pop up Permission, atau
    // 2. Buka **Setting** atau **Pengaturan** pada Handphone anda kemudian
    //    Pilih **Aplikasi**, pilih **Permission**, lalu geser tombol pada **Lokasi** atau **Location**.
    // """;
    if (!cekKoneksi!) {
      Info =
          "anda tidak terhubung ke jaringan internet, harap mengaktifkan jaringan internet anda";
    }
    if (!cekLocation!) {
      if (Info != "") {
        Info += " dan harap izinkan permission lokasi di device anda";
      } else {
        Info = "Harap izinkan permission lokasi di device anda";
      }
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
    // set up the buttons
    // Widget cancelButton = TextButton(
    //   child: Text("Tutup"),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //     Navigator.of(context).pop([false, ""]);
    //   },
    // );
    Widget continueButton = TextButton(
      child: const Text("Tutup"),
      onPressed: () {
        Navigator.of(context!).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),

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
      context: context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.warnaUngu,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21.0),
                bottomRight: Radius.circular(21.0),
                topLeft: Radius.zero,
                topRight: Radius.zero,
              ),
            ),
            child: Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  children: [
                    Container(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.warnaHijau,
                        minimumSize: const Size(280, 50),
                        padding: const EdgeInsets.only(left: 37, right: 37),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () async {
                        // final Loc = Location();
                        // bool cekLoc = await Loc.getLocation();
                        Connection objCekConnection = Connection();
                        // bool cekKoneksi =
                        //     await objCekConnection.CheckConnection();

                        // if (cekKoneksi && cekLoc) {
                        String resultPOP = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TaskList(),
                              ),
                            ) ??
                            "";

                        if (resultPOP == "loc") {
                          showAlertDialog(
                              context: context,
                              cekKoneksi: true,
                              cekLocation: false);
                        }
                      },
                      child: const Text(
                        "Ambil Pekerjaan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Pekerjaan Diambil',
                              style: AppTheme.OpenSans400(17, Colors.white),
                            ),
                            Text(
                              widget.dataDasboard['getPekerjaan'] != null
                                  ? widget.dataDasboard['getPekerjaan']
                                      .toString()
                                  : "0",
                              style: AppTheme.OpenSans500(24, Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Selesai',
                              style: AppTheme.OpenSans400(17, Colors.white),
                            ),
                            Text(
                              widget.dataDasboard['selesaiAll'] != null
                                  ? widget.dataDasboard['selesaiAll'].toString()
                                  : "0",
                              style: AppTheme.OpenSans500(24, Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Pekerjaan Hari Ini',
                  style: AppTheme.OpenSans400(15, const Color(0xFF1F1F21)),
                ),
                const SizedBox(
                  height: 6,
                ),
                Card(
                  elevation: 0,
                  color: const Color(0xFFEEEEEE),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color(0xFFE7E7E7),
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.dataDasboard['taskPendingKirim'] != null
                                    ? widget.dataDasboard['taskPendingKirim']
                                        .toString()
                                    : "0",
                                style: AppTheme.OpenSans500(
                                    24, const Color(0xFF1F1F21)),
                              ),
                              Text(
                                'Pending',
                                style: AppTheme.OpenSans400(
                                    14, const Color(0xFF969696)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                widget.dataDasboard['taskDikirim'] != null
                                    ? widget.dataDasboard['taskDikirim']
                                        .toString()
                                    : "0",
                                style: AppTheme.OpenSans500(
                                    24, const Color(0xFF1F1F21)),
                              ),
                              Text(
                                'Completed',
                                style: AppTheme.OpenSans400(
                                    14, const Color(0xFF969696)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                widget.dataDasboard['selesaiPerDay'] != null
                                    ? widget.dataDasboard['selesaiPerDay']
                                        .toString()
                                    : "0",
                                style: AppTheme.OpenSans500(
                                    24, const Color(0xFF1F1F21)),
                              ),
                              Text('Selesai',
                                  style: AppTheme.OpenSans400(
                                      14, const Color(0xFF969696))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(21.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Perolehan Poin",
                            style: AppTheme.OpenSans400(
                                14, const Color(0xff1C3147))),
                        Text(
                          widget.dataDasboard['Point'] != null
                              ? widget.dataDasboard['Point'].toString()
                              : "0",
                          style:
                              AppTheme.OpenSans500(20, const Color(0xff1C3147)),
                        ),
                      ],
                    ),
                  ),
                  // VerticalDivider(
                  //   width: 60,
                  // ),
                  // Flexible(
                  //     child: Container(
                  //         height: 130, child: _getRadialGauge())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
