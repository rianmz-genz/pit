import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/popUpError.dart';

import '../model/mNetwork.dart';
import '../network/CheckDataConnection.dart';
import '../network/worksheet.dart';
import '../utils/boxData.dart';

class listTimesheet extends StatefulWidget {
  int? taskId;
  String? timeRecord;
  int? timeServer;
  String? statusTask;
  listTimesheet(
      {this.taskId, this.timeRecord, this.statusTask, this.timeServer});
  @override
  _listTimesheetState createState() => _listTimesheetState();
}

class _listTimesheetState extends State<listTimesheet> {
  int taskId = 0;
  String timeRecord = "";
  int _state = 0;
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text("Simpan",
          style: AppTheme.OpenSans600LS(16, Colors.white, -0.41));
    } else if (_state == 1) {
      Future.delayed(const Duration(seconds: 15), () async {
        Connection objCekConnection = Connection();
        Network cekKoneksi = await objCekConnection.CheckConnection();
        // print("Cek Koneksi isnternet di setupbuttonchild");
        print('hasilnya: ${cekKoneksi.Status}');
        if (!cekKoneksi.Status && _state == 1) {
          if (mounted) {
            final downMessage = PopupError();
            downMessage.showError(context, cekKoneksi, false, mounted);
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       content: Text("anda tidak terhubung ke jaringan internet")));
          }
        }
        if (mounted) {
          setState(() {
            _state = 0;
          });
        }
      });
      return Container(
        height: 15 * MySize.scaleFactorHeight,
        width: 15 * MySize.scaleFactorWidth,
        margin: EdgeInsets.symmetric(horizontal: 16 * MySize.scaleFactorWidth),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return const Text(
        "Masuk",
        style: TextStyle(fontSize: 17),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    markedPage();
    super.initState();
    // getTimeRecord();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "listTimeSheet");
  }

  Future<bool> savetoServer(dynamic taskId, String Status, String Date,
      int Duration, String Desc) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");

    var WorksheetForm = await Hive.openBox("box_valworksheet");

    if (WorksheetForm.isNotEmpty) {
      List dataFill = [WorksheetForm.get(taskId.toString())];
      Map<String, dynamic> indexedData = {};
      final objBox = boxData(nameBox: 'box_valworksheet');
      Map<String, dynamic> data = await objBox.getValueWorksheet(
          taskid: taskId.toString(), userid: userid);
      Map<String, dynamic> dataFilter = {};
      // data.forEach((key, value) {
      //   print(key);
      //   print(value);
      //   print(value.runtimeType);
      // });
      data.forEach((i, value) {
        // print('index=$i, value=$value');
        // print(value.runtimeType);
        if (value != false && value != null && value != "") {
          dataFilter[i] = value;
        }
      });

      WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
      Network objNetwork = await objWorksheetNetwork.saveWorksheetForm(
          userId: int.parse(userid),
          taskId: taskId,
          worksheet: dataFilter,
          status: Status,
          timesheetDate: Date,
          timesheetDesc: Desc,
          timesheetDuration: Duration);
      return objNetwork.Status;
    } else {
      //
    }
    return false;
  }
  //
  // getTimeRecord() async {
  //   // var dataTimeRecord;
  //   // print("stop time executed");
  //
  //   var box_opentimeRecord = await Hive.openBox("box_timeRecord");
  //   if (box_opentimeRecord.isNotEmpty) {
  //     timeRecord = box_opentimeRecord.get('timeRecord');
  //     // print(timeRecord);
  //     setState(() {});
  //   }
  // }

  @override
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController deskripsiController = TextEditingController();
  Timer? sendTimSht;
  Connection objCekConnection = Connection();
  String tanggalforServer = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String tanggalforView = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Future<dynamic> getDataTask() async {
    dynamic catchData;
    dynamic viewData;
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");

    var box_openListTimesheet = await Hive.openBox("box_listTimesheet");

    if (box_openListTimesheet.isNotEmpty) {
      catchData = box_openListTimesheet.get(userid);
      print("catchData");
      print(catchData);

      for (var value in catchData) {
        if (value['taskid'] == widget.taskId.toString()) {
          viewData = await value['data'];
          break;
        }
      }
    }
    return viewData;
  }

  _onLoading(bool resultServer, bool resultLokal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
    if (resultServer && resultLokal) {
      Navigator.pop(context);
    } else {
      Future.delayed(const Duration(seconds: 10), () {
        Navigator.pop(context); //pop dialog
        // _login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 40),
          ),
          title: const Text("List Timesheet"),
          backgroundColor: AppTheme.warnaUngu,
          titleTextStyle: AppTheme.appBarTheme(),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              widget.timeRecord != ''
                  ? Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          // shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Tanggal"),
                                const SizedBox(
                                  width: 9,
                                ),
                                Text(": $tanggalforView"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text("Waktu"),
                                const SizedBox(
                                  width: 17,
                                ),
                                Text(
                                    ": ${(widget.timeRecord ?? "").length == 4 ? '0' + (widget.timeRecord ?? "") : (widget.timeRecord ?? "")}"),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text("Deskripsi : "),
                                const SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: deskripsiController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'harap lengkapi data ini';
                                      }
                                      return null;
                                    },
                                    // untuk disable field
                                    // onEditingComplete: () {
                                    //   print((valuess[entitlement.name]).text);
                                    //   FocusScope.of(context).unfocus();
                                    // },
                                    onChanged: (data) async {
                                      // await _onSearchChanged(data, entitlement.name, Task['id']);
                                      // var box_AddWorksheetForm = await Hive.box("box_valworksheet");
                                      // box_AddWorksheetForm.put(entitlement.name, data);
                                      // print(data);
                                    },
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'OpenSans',
                                        color: Color(0xFF2C2948)),
                                    maxLines: 1,
                                    // max baris

                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 29.0, right: 10.0),
                                      hintText: 'Masukan Deskripsi',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'OpenSans',
                                          fontSize: 15),
                                      focusColor: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.warnaHijau,
                                minimumSize: const Size(29, 33),
                                padding:
                                    const EdgeInsets.only(left: 43, right: 43),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              onPressed: () async {
                                final boxdata =
                                    boxData(nameBox: "box_setLoginCredential");

                                String userid = await boxdata
                                    .getLoginCredential(param: "userId");
                                // print("dari listtimesheeet");
                                // print(widget.statusTask);
                                // print(widget.timeServer);
                                FocusScope.of(context).unfocus();
                                final FormState? form = _formKey.currentState;
                                if (form!.validate() && _state == 0) {
                                  //TODO loading page
                                  _state = 0;
                                  if (_state == 0) {
                                    animateButton();
                                  }
                                  var dataTimesheet = [
                                    tanggalforView,
                                    widget.timeRecord,
                                    deskripsiController.text
                                  ];
                                  final objBox =
                                      boxData(nameBox: "box_listTimesheet");

                                  //NOTE:save data to server
                                  bool dataUpload = false;
                                  bool sendData = false;

                                  Network cekKoneksi =
                                      await objCekConnection.CheckConnection();
                                  final boxdata = boxData(
                                      nameBox: "box_listUploadWorksheet");

                                  if (cekKoneksi.Status) {
                                    {
                                      bool cekExistData_listUpload =
                                          await boxdata
                                              .cekExistDataOnListUpload();
                                      if (cekExistData_listUpload) {
                                        var dataBox = boxData(
                                            nameBox: "box_listUploadWorksheet");
                                        dataBox.addUploadListTask(
                                            userId: userid,
                                            taskId: widget.taskId.toString(),
                                            status: widget.statusTask ?? "",
                                            timesheetDate: tanggalforServer,
                                            timesheetDesc:
                                                deskripsiController.text,
                                            timesheetDuration:
                                                widget.timeServer ?? 0,
                                            open: 0);
                                        await objBox.addTimeSheet(
                                            userid: userid,
                                            taskid: widget.taskId.toString(),
                                            values: dataTimesheet);
                                        //   Navigator.pop(context);
                                        //

                                        Navigator.of(context).pop();
                                      } else {
                                        await savetoServer(
                                            widget.taskId,
                                            widget.statusTask ?? "",
                                            tanggalforServer,
                                            widget.timeServer ?? 0,
                                            deskripsiController.text);
                                        await objBox.addTimeSheet(
                                            userid: userid,
                                            taskid: widget.taskId.toString(),
                                            values: dataTimesheet);
                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  } else {
                                    var dataBox = boxData(
                                        nameBox: "box_listUploadWorksheet");
                                    dataBox.addUploadListTask(
                                        userId: userid,
                                        taskId: widget.taskId.toString(),
                                        status: widget.statusTask ?? "",
                                        timesheetDate: tanggalforServer,
                                        timesheetDesc: deskripsiController.text,
                                        timesheetDuration:
                                            widget.timeServer ?? 0,
                                        open: 0);
                                    await objBox.addTimeSheet(
                                        userid: userid,
                                        taskid: widget.taskId.toString(),
                                        values: dataTimesheet);
                                    //   Navigator.pop(context);
                                    //
                                    final downMessage = PopupError();
                                    if (mounted) {
                                      downMessage.showError(
                                          context, cekKoneksi, false, mounted);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                  // else {
                                  //   await objBox.addTimeSheet(
                                  //       userid: userid,
                                  //       taskid: widget.taskId.toString(),
                                  //       values: dataTimesheet);
                                  //   sendTimSht = Timer.periodic(
                                  //       Duration(milliseconds: 1000),
                                  //       (Timer t) async {
                                  //     bool cekKoneksiloop =
                                  //         await objCekConnection
                                  //             .CheckConnection();
                                  //     if (cekKoneksiloop) {
                                  //       dataUpload =
                                  //           await boxdata.cekDataOnListUpload(
                                  //               widget.taskId!.toString());
                                  //       if (dataUpload && !sendData) {
                                  //         sendData = true;
                                  //
                                  //         await savetoServer(
                                  //             widget.taskId,
                                  //             widget.statusTask ?? "",
                                  //             tanggalforServer,
                                  //             widget.timeServer ?? 0,
                                  //             deskripsiController.text);
                                  //       }
                                  //       if (sendData) {
                                  //         Navigator.pop(context);
                                  //         sendTimSht!.cancel();
                                  //       }
                                  //     } else {
                                  //       // Navigator.pop(context);
                                  //
                                  //       if (!sendData) {
                                  //         sendData = true;
                                  //         await savetoServer(
                                  //             widget.taskId,
                                  //             widget.statusTask ?? "",
                                  //             tanggalforServer,
                                  //             widget.timeServer ?? 0,
                                  //             deskripsiController.text);
                                  //       }
                                  //
                                  //       // Navigator.pop(context);
                                  //       Navigator.pop(context);
                                  //       sendTimSht!.cancel();
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(SnackBar(
                                  //               content: Text(
                                  //                   " anda tidak terhubung ke jaringan internet,data tersimpan di memori device")));
                                  //     }
                                  //   });
                                  // }
                                  // } else {

                                }
                              },
                              child: setUpButtonChild(),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                  child: FutureBuilder<dynamic>(
                future: getDataTask(),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    List<dynamic> lstBook = snapshot.data!;
                    int _length = snapshot.data!.length;

                    print("_length");
                    print(lstBook);
                    print(_length);

                    return ListView.builder(
                      itemCount: _length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Card(
                            elevation: 0,
                            child: Container(
                              color: Color(0xFFEEEEEE),
                              child: ListTile(
                                // trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () async {
                                  // await Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  // builder: (context) =>
                                  // // TaskDetail(lstBook[index], widget.Status),
                                  // // ),
                                  // );
                                  // setState(() {});
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
                                          Text(lstBook[index][0],
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontFamily: "OpenSans",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1F1F21),
                                                // overflow: TextOverflow.ellipsis
                                              )
                                              // AppTheme.OpenSans700(
                                              //     15, Color(0xFF1F1F21))
                                              ),
                                          Text(
                                            lstBook[index][2] != ""
                                                ? lstBook[index][2]
                                                : "-----",
                                            style: AppTheme.OpenSans400(
                                                14, const Color(0xFF777474)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Text(
                                        // widget.Status != "History"
                                        // ? (lstBook[index]["distance"] != null
                                        // ? (lstBook[index]["distance"]
                                        //     .toString() +
                                        // " KM")
                                        //     : "0 KM")
                                        //     : "Selesai",
                                        // style: TextStyle(
                                        // fontSize: 15,
                                        // fontFamily: 'OpenSans',
                                        // color: Colors.black),
                                        // ),
                                        Text(
                                          lstBook[index][1] != ""
                                              ? (lstBook[index][1].length == 4
                                                  ? '0' + lstBook[index][1]
                                                  : lstBook[index][1])
                                              : "-----",
                                          style: AppTheme.OpenSans400(
                                              12, const Color(0xFF9E9E9E)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Column(
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
                        Text(
                          "Data belum ada...",
                          style: TextStyle(
                              color: AppTheme.warnaAbuMuda, fontSize: 20),
                        ),
                      ],
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppTheme.warnaHijau,
                  ));
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
