
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/model/mTask.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/popUpError.dart';

import 'package:pit/view/task_detail.dart';

import '../network/CheckDataConnection.dart';

import '../utils/boxData.dart';
import '../utils/getLocation.dart';
import 'homescreen.dart';

class Notif extends StatefulWidget {
  const Notif({Key? key}) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  Map latLong = {};

  // late dynamic getloc;
  late var dataLat;
  late var dataLong;
  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now) * (-1);

    var time = '';

    if (diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
      return time;
    } else if (diff.inSeconds >= 0 && diff.inMinutes == 0) {
      time = diff.inSeconds.toString() + ' Detik lalu';
      return time;
    } else if (diff.inMinutes > 0 && diff.inHours == 0) {
      time = diff.inMinutes.toString() + ' Menit lalu';
      return time;
    } else {
      if (diff.inDays >= 1) {
        time = diff.inDays.toString() + ' Hari lalu';
      }
      return time;
    }
  }

  closeBoxes() async {
    if (Hive.isBoxOpen("box_listMessages")) {
      print('ini ke run');
      Hive.box("box_listMessages").close();
    }
  }

  @override
  initState() {
    super.initState();
    closeBoxes();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "notification");
  }

  // Future<dynamic> initLoc() async {
  //   var get = Location();
  //   print(get.lat);
  //   return get;
  // }
  alertDelete(BuildContext context, dynamic idmessage) {
    String Info = "";

    // """
    // Cara aktifkan Location Permission :
    // 1. pilih **Allow** pada pop up Permission, atau
    // 2. Buka **Setting** atau **Pengaturan** pada Handphone anda kemudian
    //    Pilih **Aplikasi**, pilih **Permission**, lalu geser tombol pada **Lokasi** atau **Location**.
    // """;
    if (idmessage != "") {
      if (idmessage == "all") {
        Info =
            Info = "Apakah anda yakin ingin menghapus seluruh data notifikasi?";
      } else {
        Info = Info = "Apakah anda yakin ingin menghapus data notifikasi ini?";
      }
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
      child: const Text("Ya"),
      onPressed: () async {
        //TODO delete message
        print('clicked trash');
        print(idmessage);
        await Hive.openBox("box_listMessages");
        final boxOpenlistmessage = await Hive.openBox("box_listMessages");
        // final box_AddMessage = Hive.box("box_listMessages");
        final saveListNotif = boxData(nameBox: "box_listMessages");
        if (boxOpenlistmessage.isOpen) {
          final boxdata = boxData(nameBox: "box_setLoginCredential");

          String userId = await boxdata.getLoginCredential(param: "userId");
          var dataLocal = boxOpenlistmessage.get(userId);
          if (dataLocal.isNotEmpty) {
            if (idmessage == "all") {
              final cekdata = await saveListNotif.UpdateListNotif([]);
              if (cekdata) {
                Navigator.of(context).pop();
                setState(() {});
              } else {
                print("hapus data gagal");
              }
            } else {
              for (var val in dataLocal) {
                if (val['idmessage'] == idmessage) {
                  print("daata has deleted");
                  dataLocal.remove(val);
                  break;
                }
              }
              final cekdata = await saveListNotif.UpdateListNotif(dataLocal);
              if (cekdata) {
                Navigator.of(context).pop();
                setState(() {});
              } else {
                print("hapus data gagal");
              }
            }
          }
        }
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),

      // actionsPadding: EdgeInsets.only(top: 10),
      title: const Text(
        "Peringatan",
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
          ],
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool triggerDelete = false;
  Future<dynamic> getDataNotif() async {
    markedPage();
    List<dynamic> dataShow = [];
    List<dynamic> dataDelete = [];
    List<dynamic> result = [];
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    DateTime timeMessage = DateTime.now();
    try {
      if (Hive.isBoxOpen("box_listMessages")) {
        print('ini ke run get data notif');
        Hive.box("box_listMessages").close();
      }
    } catch (e) {}
    await Hive.openBox("box_listMessages");
    final boxOpenlistmessage = await Hive.openBox("box_listMessages");

    if (boxOpenlistmessage.isOpen) {
      print("box notif is open");
      final boxAddmessage = Hive.box("box_listMessages");

      if (boxOpenlistmessage.isNotEmpty) {
        var dataLocal = List.from(boxOpenlistmessage.get(userId) ?? []);

        print("dataLocal");
        print(dataLocal);
        if (dataLocal.isNotEmpty) {
          // TaskNetwork objTaskNetwork = TaskNetwork();
          Connection objCekConnection = Connection();
          Network cekKoneksi = await objCekConnection.CheckConnection();

          if (cekKoneksi.Status) {
            final getloc = Location();
            var dataLat = getloc.lat;
            var dataLong = getloc.long;
            var dataLoc = await getloc.getLocation();

            // for (var data in dataLocal) {
            //   // if (value['id'].toString() == data['data']['id'].toString()) {
            //   // print('datadaeta');
            //   // print(data);
            //   // data['data']['status_worksheet'] =
            //   //     value['status_worksheet'];
            //   // print("data");
            //   // print(data);
            //   dataShow.insert(0, data);
            //   // break;
            //   // }
            // }

            //TODO remove ketika menyimpan task id null
            var remove = [];
            String taskidTemp = "0";
            int idmessageTemp = 0;
            for (var del in dataLocal) {
              // print(del['taskid']);
              // print(del['taskid'].runtimeType);
              // print(del['idmessage']);
              // print(del['idmessage'].runtimeType);
              if (del['taskid'] == null) {
                remove.add(del);
              } else if (del['taskid'] != taskidTemp) {
                taskidTemp = del['taskid'];
              } else if (del['taskid'] == taskidTemp) {
                remove.add(del);
              }
              if (del['idmessage'] != idmessageTemp) {
                idmessageTemp = del['idmessage'];
              } else if (del['idmessage'] == idmessageTemp) {
                remove.add(del);
              }
            }
            dataLocal.removeWhere((element) => remove.contains(element));
//close tag
            dataLocal.sort((b, a) {
              return (a['time']).compareTo(b['time']);
            });
            dataShow = List.from(dataLocal);
            // }
            // for (var data in dataLocal) {
            //   if (data['data']['direct'] == "true") {
            //     print('lewat sini nih');
            //     print(data);
            //     // data['data']['status_worksheet'] = "1";
            //
            //     dataShow.insert(0, data);
            //     // print("data");
            //     // print(data);
            //     // dataShow.add(data);
            //     // break;
            //   }
            // }

            //data show to list popup
            // final saveListNotif = boxData(nameBox: "box_listMessages");
            // saveListNotif.deleteMessage(dataShow);
            // print("dataShow");
            // print(dataShow.length);

            final updateNotif = boxData(nameBox: "box_loncengNotif");

            print(dataShow);
            print(dataShow.length);
            final saveListNotif = boxData(nameBox: "box_listMessages");
            saveListNotif.UpdateListNotif(dataShow);

            await Hive.openBox("box_listMessages");

            for (var check in dataShow) {
              print("messageOpen");

              print(check['messageOpen']);
              if (check['messageOpen'] == false) {
                await updateNotif.updateTriggerNotif(param: true);
                break;
              } else {
                await updateNotif.updateTriggerNotif(param: false);
              }
            }

            //
            // print('ini ke run abis update trigger');
            // try {
            //   if (Hive.isBoxOpen("box_listMessages")) {
            //     Hive.box("box_listMessages").close();
            //   }
            // } catch (e) {
            //   print(e);
            // }

            return dataShow;
            // } else {
            //   return dataLocal;
            // }
            // } else {
            //   //push failed
            // }
          } else {
            //TODO remove ketika menyimpan task id null
            dataLocal.sort((b, a) {
              return (a['idmessage']).compareTo(b['idmessage']);
            });
            var remove = [];
            for (var del in dataLocal) {
              if (del['taskid'] == null) {
                remove.add(del);
              }
            }
            dataLocal.removeWhere((element) => remove.contains(element));
            //close tag
            return dataLocal;
          }
          //
          // for (var data in dataLocal) {
          //   // print('datadaeta');
          //   // data['task_status'] = false;
          //   print(data);
          //   dataShow.add(data);
          //   // break;
          //
          //   //delete message belum
          //
          // }
          // return dataShow;
          // //

        } else {
          print("notif box from userid is empty");
          return dataShow;
        }
      } else {
        print("notif box is empty");
        return dataShow;
      }
    } else {
      return dataShow;
    }
  }

  showAlertDialog(BuildContext context, bool cekLocation) {
    String Info = "";
    var HowtoActivLoc = RichText(text: const TextSpan(children: []));

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
                text: 'Allow',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
      child: const Text("kembali ke Beranda"),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(0),
            ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 130, horizontal: 30),

      // actionsPadding: EdgeInsets.only(top: 10),
      title: const Text(
        "Peringatan",
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

  Future<dynamic> checkLoc() async {
    final getloc = Location();

    bool cek = await getloc.getLocation();
    var dataLat = getloc.lat;
    var dataLong = getloc.long;
    if (cek == false) {
      showAlertDialog(context, false);
      return false;
    }

    latLong = {"lat": dataLat, "long": dataLong};
    return true;
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () async {
                  alertDelete(context, "all");
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: AppTheme.warnaUngu,
            leading: IconButton(
              splashColor: AppTheme.warnaUngu,
              onPressed: () => Navigator.of(context).pop(false),
              // onPressed: () => Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HomeScreen(0),
              //     )),
              icon: const Icon(Icons.keyboard_arrow_left, size: 40),
            ),
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text(
              'Notifikasi',
              style: AppTheme.appBarTheme(),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<dynamic>(
              future: getDataNotif(),
              builder: (context, snapshot) {
                print("snapshot.data notification");
                // print(snapshot.data);
                // for (var vak in snapshot.data) {
                //   print(vak);
                //   print(vak['idmessage']);
                //   print(vak['idmessage'].runtimeType);
                // }

                if (snapshot.hasData) {
                  List<dynamic> lstMsg = snapshot.data!;
                  int _length = snapshot.data!.length;
                  if (snapshot.data!.length == 0) {
                    final updateNotif = boxData(nameBox: "box_loncengNotif");
                    updateNotif.updateTriggerNotif(param: false);
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: MySize.getScaledSizeWidth(100),
                            height: MySize.getScaledSizeHeight(100), //160
                            image: const AssetImage('assets/images/no.png'),
                          ),
                          SizedBox(
                            height: MySize.getScaledSizeHeight(11),
                          ),
                          const Text(
                            "Data tidak ada",
                            style: TextStyle(
                                color: AppTheme.warnaAbuMuda, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }

                  // onTap: () async {
                  //   print("sebelum klik");
                  //   print(lstMsg[index]['data']);
                  //   print(lstMsg[index]['data']
                  //   ['status_worksheet']);
                  //   bool result = false;
                  //   result = await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => TaskDetail(
                  //           lstMsg[index]['data'],
                  //           "Open",
                  //           (lstMsg[index]['data']
                  //           ['status_worksheet']),
                  //           lstMsg[index]['idmessage']),
                  //     ),
                  //   ) ??
                  //       true;
                  //   if (!result) {
                  //     print('result pesan sudah di read');
                  //     final updateNotif = boxData(
                  //         nameBox: 'box_loncengNotif');
                  //     await updateNotif.updateTriggerNotif(
                  //         param: false);
                  //     setState(() {});
                  //   }
                  // },

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                        itemCount: _length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () async {
                                        Connection objCekConnection =
                                            Connection();

                                        print("sebelum klik");

                                        print(lstMsg[index]['data']);
                                        print(lstMsg[index]['data']['direct']
                                            .runtimeType);
                                        bool handoff = false;
                                        dynamic taskStatus;
                                        bool fsmDone = false;
                                        if (lstMsg[index]['data']['direct'] ==
                                            true) {
                                          taskStatus = "On Going";
                                        } else {
                                          taskStatus = "false";
                                        }
                                        if (lstMsg[index]['data']['handoff']
                                                .runtimeType ==
                                            String) {
                                          if (lstMsg[index]['data']
                                                  ['handoff'] ==
                                              "true") {
                                            handoff = true;
                                          } else {
                                            handoff = false;
                                          }
                                        }
                                        if (lstMsg[index]['data']['fsm_done']
                                                .runtimeType ==
                                            String) {
                                          if (lstMsg[index]['data']
                                                  ['handoff'] ==
                                              "true") {
                                            fsmDone = true;
                                          } else {
                                            fsmDone = false;
                                          }
                                        }

                                        final taskModel = TaskModel(
                                            id: int.parse(
                                                lstMsg[index]['data']['id']),
                                            name: lstMsg[index]['data']['name'],
                                            fsm_done: fsmDone,
                                            distance: int.parse(lstMsg[index]
                                                ['data']['distance']),
                                            status_worksheet: lstMsg[index]
                                                ['data']['status_worksheet'],
                                            description: lstMsg[index]['data']
                                                ['description'],
                                            handoff: handoff,
                                            customer: lstMsg[index]['data']
                                                ['customer'],
                                            pending_time: lstMsg[index]['data']
                                                ['pending_time'],
                                            task_status: taskStatus);

                                        dynamic Task =
                                            Map.from(taskModel.getTask());
                                        print("taskModel.handoff");
                                        print(Task);
                                        bool result = false;
                                        if (lstMsg[index]['data']['direct'] !=
                                            "true") {
                                          Network cekKoneksi =
                                              await objCekConnection
                                                  .CheckConnection();
                                          if (cekKoneksi.Status) {
                                            result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetail(
                                                            Task,
                                                            "Open",
                                                            (lstMsg[index]
                                                                    ['data'][
                                                                'status_worksheet']),
                                                            lstMsg[index]
                                                                ['idmessage']),
                                                  ),
                                                ) ??
                                                true;
                                          } else {
                                            final downMessage = PopupError();
                                            downMessage.showError(context,
                                                cekKoneksi, true, mounted);
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //         content: MediaQuery(
                                            //   data: MediaQuery.of(context)
                                            //       .copyWith(
                                            //           textScaleFactor: 1.0),
                                            //   child: Text(
                                            //       "anda tidak terhubung ke jaringan internet"),
                                            // )));
                                          }
                                        } else {
                                          result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TaskDetail(
                                                      lstMsg[index]['data'],
                                                      "OnGoing",
                                                      (lstMsg[index]['data']
                                                          ['status_worksheet']),
                                                      lstMsg[index]
                                                          ['idmessage']),
                                                ),
                                              ) ??
                                              true;
                                        }
                                        if (!result) {
                                          print('result pesan sudah di read');
                                          final updateNotif = boxData(
                                              nameBox: 'box_loncengNotif');
                                          await updateNotif.updateTriggerNotif(
                                              param: false);
                                          setState(() {});
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: lstMsg[index]
                                                        ['messageOpen'] ==
                                                    false
                                                ? Row(
                                                    children: [
                                                      lstMsg[index]['data'][
                                                                      'handoff'] ==
                                                                  true ||
                                                              lstMsg[index][
                                                                          'data']
                                                                      [
                                                                      'handoff'] ==
                                                                  "true"
                                                          ? const Text(
                                                              "[HAND OFF]",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Color(
                                                                      0xFF1F1F21),
                                                                  fontFamily:
                                                                      'OpenSans'),
                                                            )
                                                          : Container(),
                                                      lstMsg[index]['data'][
                                                                      'handoff'] ==
                                                                  "true" ||
                                                              lstMsg[index][
                                                                          'data']
                                                                      [
                                                                      'handoff'] ==
                                                                  true
                                                          ? const SizedBox(
                                                              width: 10,
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                        child: Text(
                                                          lstMsg[index]['title']
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // maxLines: 1,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF1F1F21),
                                                              fontFamily:
                                                                  'OpenSans'),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      lstMsg[index]['data'][
                                                                      'handoff'] ==
                                                                  true ||
                                                              lstMsg[index][
                                                                          'data']
                                                                      [
                                                                      'handoff'] ==
                                                                  "true"
                                                          ? Text(
                                                              "[HAND OFF]",
                                                              style: AppTheme
                                                                  .OpenSans500(
                                                                      14,
                                                                      const Color(
                                                                          0xFF1F1F21)),
                                                            )
                                                          : Container(),
                                                      lstMsg[index]['data'][
                                                                      'handoff'] ==
                                                                  true ||
                                                              lstMsg[index][
                                                                          'data']
                                                                      [
                                                                      'handoff'] ==
                                                                  "true"
                                                          ? const SizedBox(
                                                              width: 10,
                                                            )
                                                          : Container(),
                                                      Expanded(
                                                        child: Text(
                                                          lstMsg[index]['title']
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: AppTheme
                                                              .OpenSans500(
                                                                  14,
                                                                  const Color(
                                                                      0xFF1F1F21)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          SizedBox(
                                            height:
                                                5 * MySize.scaleFactorHeight,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              lstMsg[index]['data']['customer']
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: AppTheme.OpenSans400(
                                                  14, const Color(0xFF808080)),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                5 * MySize.scaleFactorHeight,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "Jarak " +
                                                  lstMsg[index]['data']
                                                      ['distance'] +
                                                  " KM",
                                              style: AppTheme.OpenSans400(
                                                  14, const Color(0xFF808080)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            alertDelete(context,
                                                lstMsg[index]['idmessage']);
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                // width: double.infinity,
                                                height: 20,
                                                width: 25,
                                                margin: const EdgeInsets.only(
                                                    right: 5, left: 20, top: 5),
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 25,
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10 *
                                                    MySize.scaleFactorHeight,
                                              ),
                                              SizedBox(
                                                height: 10 *
                                                    MySize.scaleFactorHeight,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            readTimestamp(
                                                lstMsg[index]['time']),
                                            style: AppTheme.OpenSans400(
                                                14, const Color(0xFF808080)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              const Divider(color: Colors.grey),
                              // Text(
                              //   "Tipe Perkerjaan : Unit Besar",
                              //   textAlign: TextAlign.start,
                              //   style: AppTheme.OpenSans400(14, Color(0xFF808080)),
                              // ),
                              // // SizedBox(
                              // //   height: 5,
                              // // ),
                              // Text(
                              //   "Poin yang diperoleh,",
                              //   textAlign: TextAlign.start,
                              //   style: AppTheme.OpenSans400(14, Color(0xFF808080)),
                              // ),
                              // Text(
                              //   "Pengecekan : 1 poin",
                              //   textAlign: TextAlign.start,
                              //   style: AppTheme.OpenSans400(14, Color(0xFF808080)),
                              // ),
                              // Text(
                              //   "Perbaikan : 2 poin",
                              //   textAlign: TextAlign.start,
                              //   style: AppTheme.OpenSans400(14, Color(0xFF808080)),
                              // ),
                              // SizedBox(
                              //   height: 5 * MySize.scaleFactorHeight,
                              // ),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: Text(
                              //     "2 Hours ago",
                              //     textAlign: TextAlign.end,
                              //     style: AppTheme.OpenSans300(14, Color(0xFF808080)),
                              //   ),
                              // ),
                            ],
                          );
                        }),
                  );
                }

                return const Center(
                    child: CircularProgressIndicator(
                  color: AppTheme.warnaHijau,
                ));
              },
            ),

            // ListView(
            //   children: [
            //     Padding(
            //       // padding: const EdgeInsets.all(8.0),
            //       padding: EdgeInsets.fromLTRB(9, 7.5, 15, 0),
            //       child: InkWell(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => Notif_detail(),
            //               // builder: (context) =>
            //               //     SelectedItem(['Pensil', 'Penghapus']),
            //             ),
            //           );
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "Selamat !",
            //               style: AppTheme.OpenSans500(14, Color(0xFF1F1F21)),
            //             ),
            //             SizedBox(
            //               height: 5 * MySize.scaleFactorHeight,
            //             ),
            //             Text(
            //               "Lorem ipsum dolor sit amet, consectetur adipiscing elit.In consequat venenatis turpis…",
            //               textAlign: TextAlign.start,
            //               style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //             ),
            //             SizedBox(
            //               height: 5 * MySize.scaleFactorHeight,
            //             ),
            //             Text(
            //               "Tipe Perkerjaan : Unit Besar",
            //               textAlign: TextAlign.start,
            //               style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //             ),
            //             // SizedBox(
            //             //   height: 5,
            //             // ),
            //             Text(
            //               "Poin yang diperoleh,",
            //               textAlign: TextAlign.start,
            //               style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //             ),
            //             Text(
            //               "Pengecekan : 1 poin",
            //               textAlign: TextAlign.start,
            //               style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //             ),
            //             Text(
            //               "Perbaikan : 2 poin",
            //               textAlign: TextAlign.start,
            //               style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //             ),
            //             SizedBox(
            //               height: 5 * MySize.scaleFactorHeight,
            //             ),
            //             Align(
            //               alignment: Alignment.centerRight,
            //               child: Text(
            //                 "2 Hours ago",
            //                 textAlign: TextAlign.end,
            //                 style: AppTheme.OpenSans300(14, Color(0xFF808080)),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Divider(color: Colors.grey),
            //     Padding(
            //       // padding: const EdgeInsets.all(8.0),
            //       padding: EdgeInsets.fromLTRB(9, 7.5, 15, 0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Peraturan Baru",
            //             style: AppTheme.OpenSans500(14, Color(0xFF1F1F21)),
            //           ),
            //           SizedBox(
            //             height: 5 * MySize.scaleFactorHeight,
            //           ),
            //           Text(
            //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit.In consequat venenatis turpis…",
            //             textAlign: TextAlign.start,
            //             style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //           ),
            //           SizedBox(
            //             height: 5 * MySize.scaleFactorHeight,
            //           ),
            //           Text(
            //             "Tipe Perkerjaan : Unit Kecil",
            //             textAlign: TextAlign.start,
            //             style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //           ),
            //           // SizedBox(
            //           //   height: 5,
            //           // ),
            //           Text(
            //             "Poin yang diperoleh,",
            //             textAlign: TextAlign.start,
            //             style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //           ),
            //           Text(
            //             "Pengecekan : 1 poin",
            //             textAlign: TextAlign.start,
            //             style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //           ),
            //           Text(
            //             "Perbaikan : 2 poin",
            //             textAlign: TextAlign.start,
            //             style: AppTheme.OpenSans400(14, Color(0xFF808080)),
            //           ),
            //           SizedBox(
            //             height: 5 * MySize.scaleFactorHeight,
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: Text(
            //               "5 Hours ago",
            //               textAlign: TextAlign.end,
            //               style: AppTheme.OpenSans300(14, Color(0xFF808080)),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Divider(color: Colors.grey),
            //   ],
            // ),
          )),
    );
  }
}

// class Notif extends StatelessWidget {
//   const Notif({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     MySize().init(context);
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//       child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppTheme.warnaUngu,
//             leading: IconButton(
//               splashColor: AppTheme.warnaUngu,
//               onPressed: () => Navigator.of(context).pop(),
//               icon: Icon(Icons.keyboard_arrow_left, size: 40),
//             ),
//             automaticallyImplyLeading: true,
//             centerTitle: true,
//             title: Text(
//               'Notifikasi',
//               style: AppTheme.appBarTheme(),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           body: SafeArea(
//             child: ListView(
//               children: [
//                 Padding(
//                   // padding: const EdgeInsets.all(8.0),
//                   padding: EdgeInsets.fromLTRB(9, 7.5, 15, 0),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Notif_detail(),
//                           // builder: (context) =>
//                           //     SelectedItem(['Pensil', 'Penghapus']),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Selamat !",
//                           style: AppTheme.OpenSans500(14, Color(0xFF1F1F21)),
//                         ),
//                         SizedBox(
//                           height: 5 * MySize.scaleFactorHeight,
//                         ),
//                         Text(
//                           "Lorem ipsum dolor sit amet, consectetur adipiscing elit.In consequat venenatis turpis…",
//                           textAlign: TextAlign.start,
//                           style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                         ),
//                         SizedBox(
//                           height: 5 * MySize.scaleFactorHeight,
//                         ),
//                         Text(
//                           "Tipe Perkerjaan : Unit Besar",
//                           textAlign: TextAlign.start,
//                           style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                         ),
//                         // SizedBox(
//                         //   height: 5,
//                         // ),
//                         Text(
//                           "Poin yang diperoleh,",
//                           textAlign: TextAlign.start,
//                           style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                         ),
//                         Text(
//                           "Pengecekan : 1 poin",
//                           textAlign: TextAlign.start,
//                           style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                         ),
//                         Text(
//                           "Perbaikan : 2 poin",
//                           textAlign: TextAlign.start,
//                           style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                         ),
//                         SizedBox(
//                           height: 5 * MySize.scaleFactorHeight,
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Text(
//                             "2 Hours ago",
//                             textAlign: TextAlign.end,
//                             style: AppTheme.OpenSans300(14, Color(0xFF808080)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(color: Colors.grey),
//                 Padding(
//                   // padding: const EdgeInsets.all(8.0),
//                   padding: EdgeInsets.fromLTRB(9, 7.5, 15, 0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Peraturan Baru",
//                         style: AppTheme.OpenSans500(14, Color(0xFF1F1F21)),
//                       ),
//                       SizedBox(
//                         height: 5 * MySize.scaleFactorHeight,
//                       ),
//                       Text(
//                         "Lorem ipsum dolor sit amet, consectetur adipiscing elit.In consequat venenatis turpis…",
//                         textAlign: TextAlign.start,
//                         style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                       ),
//                       SizedBox(
//                         height: 5 * MySize.scaleFactorHeight,
//                       ),
//                       Text(
//                         "Tipe Perkerjaan : Unit Kecil",
//                         textAlign: TextAlign.start,
//                         style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                       ),
//                       // SizedBox(
//                       //   height: 5,
//                       // ),
//                       Text(
//                         "Poin yang diperoleh,",
//                         textAlign: TextAlign.start,
//                         style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                       ),
//                       Text(
//                         "Pengecekan : 1 poin",
//                         textAlign: TextAlign.start,
//                         style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                       ),
//                       Text(
//                         "Perbaikan : 2 poin",
//                         textAlign: TextAlign.start,
//                         style: AppTheme.OpenSans400(14, Color(0xFF808080)),
//                       ),
//                       SizedBox(
//                         height: 5 * MySize.scaleFactorHeight,
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           "5 Hours ago",
//                           textAlign: TextAlign.end,
//                           style: AppTheme.OpenSans300(14, Color(0xFF808080)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey),
//               ],
//             ),
//           )),
//     );
//   }
// }
