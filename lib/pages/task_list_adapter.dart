import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:pit/model/mNetwork.dart';
import 'package:pit/network/CheckDataConnection.dart';
import 'package:pit/network/task.dart';
import 'package:pit/utils/popUpError.dart';

import 'package:pit/view/task_detail.dart';

import '../themes/AppTheme.dart';
import '../utils/SizeConfig.dart';
import '../utils/boxData.dart';
import '../utils/getLocation.dart';
import '../view/homescreen.dart';

import '../pages/selectItem.dart';

class TaskListAdapter extends StatefulWidget {
  String Status;
  double Lat;
  double Lng;

  TaskListAdapter(
      {super.key, required this.Status, required this.Lat, required this.Lng});

  @override
  State<TaskListAdapter> createState() => _TaskListAdapterState();
}

class _TaskListAdapterState extends State<TaskListAdapter> {
//statusTask menandakan apakah pekerjaan itu dalam kondisi sedang dikerjakan/onGoing, Handed Off, History(sudah finish)
  String urutkan = "Jarak";
  Map latLong = {};
  List<dynamic> kategori = [];
  List statusTask = [];
  List<dynamic> resultData = [];
  bool updateItem = false;
  // List<dynamic> resultDefault = [];

  List<dynamic> dataStsWrkShtServer = [];
  Timer? _debounce;
  String keyword = "";
  TextEditingController keywordController = TextEditingController();
  Future<dynamic> getDataTask({String? urutkan, String? keyword}) async {
    markedPage();
    List<dynamic> lstResult = [];
    List<dynamic> resultFilter = [];
    List<dynamic> dataResult = [];
    var updateDasboard = boxData(nameBox: 'box_dashboard');

    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");

    TaskNetwork objTaskNetwork = TaskNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
//cek lokasi
    //TODO cek lokasi di dalam "ambil pekerjaan"

    //init box
    var boxAdddetail = Hive.box("box_detailPekerjaan");

    var boxAddlist = Hive.box("box_listPekerjaan");
    var boxOpenlistpekerjaan = await Hive.openBox("box_listPekerjaan");
    var boxOpenhistorypekerjaan = await Hive.openBox("box_historyPekerjaan");

    if (widget.Status == "Pending") {
      updateDasboard.addDataDashboard(
          param: 'taskPendingKirim', tambah: false, reset: true);

      List<dynamic> dataPendingShow = [];
      var listUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
      if (boxOpenlistpekerjaan.isNotEmpty) {
        List<dynamic> datalistPekerjaan =
            List.from(boxOpenlistpekerjaan.get(userid) ?? []);
        if (datalistPekerjaan.isNotEmpty) {
          if (listUploadWorksheet.isNotEmpty) {
            List<dynamic> datalistUpload = listUploadWorksheet.get(userid);
            if (datalistUpload.isNotEmpty) {
              for (var valLP in datalistPekerjaan) {
                for (var valUW in datalistUpload) {
                  if (valLP['data']['id'].toString() ==
                          valUW['taskid'].toString() ||
                      valLP['data']['task_status'] == "Completed") {
                    dataPendingShow.insert(0, valLP['data']);
                    statusTask.add("Pending");
                    dataStsWrkShtServer.add(valLP['data']['status_worksheet']);

                    updateDasboard.addDataDashboard(
                        param: 'taskPendingKirim', tambah: true);
                    break;
                  }
                }
              }
            } else {
              for (var valLP in datalistPekerjaan) {
                if (valLP['data']['task_status'] == "Completed") {
                  dataPendingShow.insert(0, valLP['data']);
                  statusTask.add("Pending");
                  dataStsWrkShtServer.add(valLP['data']['status_worksheet']);
                }
              }
            }
          } else {
            for (var valLP in datalistPekerjaan) {
              if (valLP['data']['task_status'] == "Completed") {
                dataPendingShow.insert(0, valLP['data']);
                statusTask.add("Pending");
                dataStsWrkShtServer.add(valLP['data']['status_worksheet']);
              }
            }
          }
        }
      }

      return dataPendingShow;
    }
    if (cekKoneksi.Status && widget.Status == "Open") {
      print("cek koneksi lewat");

      //TODO cek lokasi di dalam "ambil pekerjaan"
      // if (widget.Status != "Open") {
      bool checkloc = await checkLoc();
      if (!checkloc) {
        return null;
      }
      // }

      //close tag

      if (widget.Status == "Open" && resultData.isNotEmpty) {
        if (keyword != "") {
          for (var data in resultData) {
            if (data['customer'] != null && data['name'] != null) {
              if (data['customer'].toLowerCase().contains(keyword) ||
                  data['name'].toLowerCase().contains(keyword)) {
                lstResult.add(data);
              }
            }
          }
        } else {
          lstResult = List.from(resultData);
        }
        if (urutkan == "" && keyword == "") {
          lstResult = List.from(resultData);
        }
        if ((urutkan ?? "").toLowerCase() == "z-a") {
          lstResult.sort((b, a) {
            return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
          });
        }
        //ini sortir A-Z by name

        if ((urutkan ?? "").toLowerCase() == "a-z") {
          lstResult.sort((b, a) {
            return b['name'].toLowerCase().compareTo(a['name'].toLowerCase());
          });
        }
        //ini sortir dengan jarak

        if ((urutkan ?? "").toLowerCase() == "jarak") {
          lstResult.sort((a, b) {
            return (a['distance']).compareTo(b['distance']);
          });
        }
        //ini sortir by waktu

        if ((urutkan ?? "").toLowerCase() == "waktu") {
          for (var element in lstResult) {
            if (element['pending_time'].contains(" Hari lalu")) {
              element["compare_time"] = double.parse(
                      element['pending_time'].replaceAll(" Hari lalu", "")) *
                  24;
            } else if (element['pending_time'].contains("Jam lalu")) {
              element["compare_time"] = double.parse(
                      element['pending_time'].replaceAll(" Jam lalu", "")) *
                  1;
            }
          }

          lstResult.sort((a, b) {
            return (a['compare_time']).compareTo(b['compare_time']);
          });
        }
        return lstResult;
      }
      if (widget.Status == "Open") {
        Network objNetwork = await objTaskNetwork.getTaskList(
            strUserId: userid,
            Status: widget.Status,
            Lat: latLong['lat'] ?? 0,
            Lng: latLong['long'] ?? 0);

        lstResult = objNetwork.Data;
        //TODO ini sortir dengan jarak (default)

        lstResult.sort((a, b) {
          return (a['distance']).compareTo(b['distance']);
        });

        resultData = lstResult;

        return lstResult;
      }
    } else {
      final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, false, mounted);
      //TODO ongoing
      if (widget.Status == "OnGoing") {
        bool checkloc = await checkLoc();
        if (!checkloc) {
          return null;
        }
        if (boxOpenlistpekerjaan.isNotEmpty) {
          dataStsWrkShtServer = [];
          statusTask = [];
          var viewData = List.from(boxOpenlistpekerjaan.get(userid) ?? []);
          print("viewDataaa ${viewData}");
          if (viewData.isNotEmpty) {
            for (var value in viewData) {
              if (value['StatusTask'] == 'OnGoing' &&
                  value['data']['task_status'] != 'Completed') {
                lstResult.add(value['data']);
                statusTask.add(value['StatusTask']);
                dataStsWrkShtServer.add(value['data']['status_worksheet']);
              }
            }
          } else {
            lstResult = [];
          }
          //TODO update if received direct task

          //close tag
//TODO:update
          if (!updateItem) {
            syncValue(widget.Status, userid, "syncvalue ongoing");
          }
          //
          return lstResult;
        } else {
          Network objNetwork = await objTaskNetwork.getTaskList(
              strUserId: userid,
              Status: widget.Status,
              Lat: latLong['lat'] ?? 0,
              Lng: latLong['long'] ?? 0);
          if (!objNetwork.Status) {
            //if untuk ngakalin agar tidak get api dengan param status history
            return [];
          } else {
            dataResult = objNetwork.Data;

            //TODO:reset datadasboard pekerjaan diambil

            var addList = boxData(nameBox: 'box_listPekerjaan');
            if (widget.Status == "OnGoing") {
              final updateList = boxData(nameBox: 'box_listPekerjaan');

              await addList.refreshListTask(
                  userid: userid,
                  statusTask: widget.Status,
                  values: dataResult);
              dataStsWrkShtServer = [];
              statusTask = [];
              var viewData = List.from(boxOpenlistpekerjaan.get(userid) ?? []);
              for (var value in viewData) {
                if (value['StatusTask'] == 'OnGoing' &&
                    value['data']['task_status'] != 'Completed') {
                  lstResult.add(value['data']);
                  statusTask.add(value['StatusTask']);
                  dataStsWrkShtServer.add(value['data']['status_worksheet']);
                }
              }
              return lstResult;
            }
          }
        }
      }
      //TODO history
      if (widget.Status == "History") {
        bool checkloc = await checkLoc();
        if (!checkloc) {
          return null;
        }
        if (boxOpenhistorypekerjaan.isNotEmpty) {
          // alert("Online");
          statusTask = [];
          dataStsWrkShtServer = [];
          var viewData = List.from(boxOpenhistorypekerjaan.get(userid) ?? []);
          if (viewData.isNotEmpty) {
            for (var value in viewData) {
              if (value['StatusTask'] == 'Handed Off' ||
                  value['StatusTask'] == 'Pending Upload' ||
                  value['StatusTask'] == 'Completed' ||
                  value['StatusTask'] == 'On Going' ||
                  value['statusTask'] == 'History') {
                if (value['StatusTask'] == 'On Going') {
                  value['StatusTask'] = 'Berjalan';
                }
                lstResult.add(value['data']);
                statusTask.add(value['StatusTask']);
                dataStsWrkShtServer.add(value['data']['status_worksheet']);
              }
            }
          } else {
            lstResult = [];
          }
          //TODO:update
          if (!updateItem) {
            syncValue(widget.Status, userid, "syncvalue history");
          }
          //
          return lstResult;
        } else {
          Network objNetwork = await objTaskNetwork.getTaskList(
              strUserId: userid,
              Status: widget.Status,
              Lat: latLong['lat'] ?? 0,
              Lng: latLong['long'] ?? 0);
          if (!objNetwork.Status) {
            //if untuk ngakalin agar tidak get api dengan param status history
            return [];
          } else {
            dataResult = objNetwork.Data;

            //TODO:reset datadasboard pekerjaan diambil

            if (widget.Status == "History") {
              final updateHistory = boxData(nameBox: 'box_historyPekerjaan');

              await updateHistory.refreshHistoryTask(
                  userid: userid,
                  statusTask: widget.Status,
                  values: dataResult);
              dataStsWrkShtServer = [];
              statusTask = [];
              // isi list ke view mode online

              //status= history
              if (widget.Status == 'History') {
                // alert("Online");
                statusTask = [];
                dataStsWrkShtServer = [];
                var viewData =
                    List.from(boxOpenhistorypekerjaan.get(userid) ?? []);

                for (var value in viewData) {
                  if (value['StatusTask'] == 'Handed Off' ||
                      value['StatusTask'] == 'Pending Upload' ||
                      value['StatusTask'] == 'Completed' ||
                      value['StatusTask'] == 'On Going' ||
                      value['statusTask'] == 'History') {
                    if (value['StatusTask'] == 'On Going') {
                      value['StatusTask'] = 'Berjalan';
                    }
                    lstResult.add(value['data']);
                    statusTask.add(value['StatusTask']);
                    dataStsWrkShtServer.add(value['data']['status_worksheet']);
                  }
                }
                return lstResult;
              }
            }
          }
        }
      }

      //tag close
    }

    return lstResult;
  }

  syncValue(String page, String userid, String from) async {
    print(from);
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    TaskNetwork objTaskNetwork = TaskNetwork();
    if (cekKoneksi.Status) {
      Network objNetwork = await objTaskNetwork.getTaskList(
          strUserId: userid,
          Status: widget.Status,
          Lat: latLong['lat'] ?? 0,
          Lng: latLong['long'] ?? 0);
      final dataResult = objNetwork.Data;

      var addList = boxData(nameBox: 'box_listPekerjaan');
      if (page == "OnGoing") {
        final updateList = boxData(nameBox: 'box_listPekerjaan');

        await addList.refreshListTask(
            userid: userid, statusTask: widget.Status, values: dataResult);
      }
      if (page == "History") {
        final updateHistory = boxData(nameBox: 'box_historyPekerjaan');

        await updateHistory.refreshHistoryTask(
            userid: userid, statusTask: widget.Status, values: dataResult);
      }
      setState(() {
        updateItem = true;
      });
    } else {
      final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, false, mounted);
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
                text: 'Allow', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' pada pop up Permission, atau\n\n'),
            //cara 2
            TextSpan(text: '2. pilih '),
            TextSpan(
                text: 'Setting/Pengaturan',
                style: TextStyle(fontWeight: FontWeight.bold)),
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

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");

    if (widget.Status == "Open") {
      await BoxData.markedPage(namePage: "task_list_adapter_open");
    } else {
      await BoxData.markedPage(namePage: "task_list_adapter");
    }
  }

  _onSearchChanged(String data) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      // do something with query
      keyword = data.toLowerCase();
      setState(() {});
    });
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.Status == 'Open'
              ? Column(
                  children: [
                    TextFormField(
                      controller: keywordController,

                      onChanged: (data) {
                        _onSearchChanged(data);
                      },
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                          color: Color(0xFF2C2948)),
                      maxLines: 1,
                      // max baris

                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 29.0, right: 10.0),
                        hintText: 'Cari Berdasarkan Judul / Customer',
                        hintStyle: TextStyle(
                            // fontStyle: FontStyle.italic,
                            fontFamily: 'OpenSans',
                            fontSize: 15),
                        focusColor: Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final dataUrutkan = [
                          '',
                          'A-Z',
                          'Z-A',
                          'Jarak',
                          'Waktu',
                        ];
                        urutkan = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectedItem(dataUrutkan, 'Urutkan'),
                              ),
                            ) ??
                            urutkan;
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 29.0, right: 10.0, top: 17, bottom: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Urutkan",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontSize: 15)),
                            urutkan != null
                                ? Text(urutkan,
                                    style: const TextStyle(
                                        color: AppTheme.warnaHijau,
                                        fontFamily: 'OpenSans',
                                        fontSize: 15))
                                : Container(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black45,
                              size: 15.0,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1.0,
                              color: const Color(0xFF27394E).withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(
                                  8.0) //                 <--- border radius here
                              ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppTheme.warnaHijau,
            notificationPredicate:
                widget.Status == "OnGoing" ? (_) => true : (_) => false,
            onRefresh: () async {
              Connection objCekConnection = Connection();
              Network cekKoneksi = await objCekConnection.CheckConnection();
              if (cekKoneksi.Status) {
                updateItem = false;

                print("refresh data");
                // getDataTask(urutkan: urutkan, kategori: kategori);
                setState(() {});
              } else {
                final downMessage = PopupError();
                downMessage.showError(context, cekKoneksi, true, mounted);
              }
            },
            child: FutureBuilder<dynamic>(
              future: getDataTask(urutkan: urutkan, keyword: keyword),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> lstBook = snapshot.data!;
                  int _length = snapshot.data!.length;
                  print("snapshot.hasData ${snapshot.data}");
                  if (snapshot.data!.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            width: MySize.getScaledSizeWidth(65),
                            height: MySize.getScaledSizeHeight(65), //160
                            image: const AssetImage('assets/images/no.png'),
                          ),
                          SizedBox(
                            height: MySize.size20,
                          ),
                          const Text(
                            "Tidak ada data",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          )
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          // reverse: true,
                          itemCount: _length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Card(
                                elevation: 0,
                                child: Container(
                                  color: const Color(0xFFEEEEEE),
                                  child: ListTile(
                                    // trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () async {
                                      String stsWrkShtServerDummy = "1";
                                      String statusTaskDummy = "Open";
                                      if (dataStsWrkShtServer.isNotEmpty) {
                                        if (dataStsWrkShtServer[index] !=
                                            null) {
                                          stsWrkShtServerDummy =
                                              dataStsWrkShtServer[index];
                                        }
                                      }
                                      if (statusTask.isNotEmpty &&
                                          (statusTask != "Completed" ||
                                              statusTask != "Pending Upload")) {
                                        statusTaskDummy = statusTask[index];
                                      }
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TaskDetail(
                                              lstBook[index],
                                              statusTaskDummy,
                                              stsWrkShtServerDummy,
                                              0),
                                        ),
                                      );
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(lstBook[index]["name"],
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1F1F21),
                                                  )),
                                              Text(
                                                lstBook[index]["customer"] ??
                                                    "",
                                                style: AppTheme.OpenSans400(14,
                                                    const Color(0xFF777474)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            if (widget.Status == "Pending")
                                              const Text("Pending",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.black)),
                                            if (widget.Status == "Open")
                                              Text(
                                                (lstBook[index]["distance"] !=
                                                        null
                                                    ? (lstBook[index]
                                                                ["distance"]
                                                            .toString() +
                                                        " KM")
                                                    : "0 KM"),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'OpenSans',
                                                    color: Colors.black),
                                              ),
                                            if (widget.Status == "OnGoing")
                                              Text(
                                                  (lstBook[index]["distance"] !=
                                                          null
                                                      ? (lstBook[index]
                                                                  ["distance"]
                                                              .toString() +
                                                          " KM")
                                                      : "0 KM"),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.black)),
                                            if (widget.Status == "History")
                                              Text(statusTask[index].toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'OpenSans',
                                                      color: Colors.black)),
                                            Text(
                                              lstBook[index]["pending_time"] ??
                                                  "",
                                              style: AppTheme.OpenSans400(
                                                  12, const Color(0xFF9E9E9E)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const Center(
                    child: CircularProgressIndicator(
                  color: AppTheme.warnaHijau,
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
