//16:26  13/04/2022

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/network/task.dart';
import 'package:pit/network/worksheet.dart';
import 'package:pit/pages/scanBarcode.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/notificationApi.dart';
import 'package:pit/utils/popUpError.dart';
import 'package:pit/view/listTimeSheet.dart';

// import 'package:pit/view/select_item.dart';
import 'package:pit/pages/selectItem.dart';
// import 'package:pit/view/signature.dart';
import 'package:pit/pages/signature.dart';
import 'package:pit/view/task_detail.dart';
import 'package:provider/provider.dart';

import '../network/CheckDataConnection.dart';
import '../notifier/tabNotifier.dart';
import '../notifier/worksheetFormNotifier.dart';
import '../pages/information.dart';
import '../utils/boxData.dart';
import 'homescreen.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class MenuDrawerWidget extends StatelessWidget {
  dynamic taskid;
  MenuDrawerWidget({Key? key, this.taskid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 5,
        child: Column(
          children: [
            Container(
                height: MySize.getScaledSizeHeight(90),
                color: AppTheme.warnaUngu),
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                _drawerItem(
                    icon: Icons.info_outline,
                    text: 'Informasi',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => informationPage()),
                      );
                    }),
                _drawerItem(
                  icon: Icons.view_list,

                  text: 'List Timesheet',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => listTimesheet(
                                taskId: taskid,
                                timeRecord: "",
                                statusTask: "",
                                timeServer: 0,
                              )),
                    );
                    //             // setState(() {});
                  },
                  //           icon: Icon(
                  //             Icons.list,
                  //             color: Colors.white,
                ),
                _drawerItem(
                  icon: Icons.file_download,
                  text: 'Download LPU',
                  aktif: false,
                  onTap: () async {
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => listTimesheet(
                    //             taskId: taskid,
                    //             timeRecord: "",
                    //             statusTask: "",
                    //             timeServer: 0,
                    //           )),
                    // );
                    //             // setState(() {});
                  },
                )
              ]),
            ),
          ],
        ));
  }
}

Widget _drawerItem(
    {IconData? icon,
    String? text,
    GestureTapCallback? onTap,
    bool? aktif = true}) {
  Color? warna;

  if (aktif!) {
    warna = Colors.black87;
  } else {
    warna = Colors.grey;
  }

  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: warna,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            text ?? "",
            style: TextStyle(
              color: warna,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}

class TaskWorksheetMenu extends StatelessWidget {
  //Task dari task list
  dynamic Task;
  dynamic tabBar;
  //statusTask dari widget.Status (OnGoing,Open,History dll)
  dynamic statusTask;
  //task detail
  dynamic objDataTask;
  //status_worksheet dari param task respon api tasklist
  String dataStsWrkShtServer;
  TaskWorksheetMenu(this.Task, this.objDataTask, this.tabBar, this.statusTask,
      this.dataStsWrkShtServer,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.warnaUngu,
            actions: [
              // // SizedBox(
              // //   width: 5,
              // // ),
              // statusTask != 'Open'
              //     ? IconButton(
              //         splashColor: Colors.transparent,
              //         // iconSize: 20,
              //         onPressed: () async {
              //           await Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => informationPage()),
              //           );
              //         },
              //         icon: const Icon(
              //           Icons.info_outline,
              //           color: Colors.white,
              //         ),
              //       )
              //     : Container(),
              // // SizedBox(
              // //   width: 5,
              // // ),
              // statusTask != 'Open'
              //     ? IconButton(
              //         splashColor: Colors.transparent,
              //         onPressed: () async {
              //           var taskid;
              //           if (Task['id'].runtimeType == String) {
              //             taskid = int.parse(Task['id']);
              //           } else {
              //             taskid = Task['id'];
              //           }
              //           await Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => listTimesheet(
              //                       taskId: taskid,
              //                       timeRecord: "",
              //                       statusTask: "",
              //                       timeServer: 0,
              //                     )),
              //           );
              //           // setState(() {});
              //         },
              //         icon: Icon(
              //           Icons.list,
              //           color: Colors.white,
              //         ),
              //       )
              //     : Container()
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.list, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            leading: IconButton(
              splashColor: Colors.transparent,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.keyboard_arrow_left, size: 40),
            ),
            centerTitle: true,
            title: Text(
              Task["name"],
              // "task name",
              // "LPU",
              style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          endDrawer: MenuDrawerWidget(
              taskid: Task['id'].runtimeType == String
                  ? int.parse(Task['id'])
                  : Task['id']),
          body: SafeArea(
            child: Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: EdgeInsets.fromLTRB(17, 12, 17, 12),
              child: DefaultTabController(
                initialIndex: statusTask == 'Pending'
                    ? 0
                    : tabBar, // mengatur tab dari sini
                length: 2,
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Column(children: [
                    statusTask == 'OnGoing'
                        ? Container(
                            width: 323,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.all(
                                  const Radius.circular(
                                      40.0) //                 <--- border radius here
                                  ),
                            ),
                            child: IgnorePointer(
                              child: TabBar(
                                unselectedLabelColor: const Color(0xFF333333),
                                labelColor: Colors.white,
                                labelStyle:
                                    AppTheme.OpenSans600(18, Colors.white),
                                unselectedLabelStyle: AppTheme.OpenSans400(
                                    18, const Color(0xFF333333)),
                                indicator: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    color: AppTheme.warnaHijau),
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(
                                      child: Center(
                                    child: Text("On Progress",
                                        style: AppTheme.tabBarTheme()),
                                  )),
                                  Tab(
                                      child: Container(
                                    child: Center(
                                        child: Text("Stop",
                                            style: AppTheme.tabBarTheme())),
                                  )),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    // Container(),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(), //disable swipe
                        children: [
                          TaskWorksheet(Task, objDataTask, statusTask,
                              dataStsWrkShtServer),
                          worksheetStop(Task, dataStsWrkShtServer),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

box_workSheetSetting(
    {String? taskid,
    int? tabbar,
    String? btnname,
    int? page2,
    String? pause}) async {
  //fungsi buka box, mengecek, mengedit, mengisi
  //set tabbar to 1
  // dynamic valueBox = [];

  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userid = await boxdata.getLoginCredential(param: "userId");
  final objBox = boxData(nameBox: "box_workSheetSetting");
  Map<String, dynamic> data = {
    "tabBar": tabbar,
    "btnname": btnname,
    "page2": page2,
    "pause": pause
  };

  objBox.settingFormWorksheet(userid, taskid, data);
}

class worksheetStop extends StatefulWidget {
  dynamic Task;
  String page2;
  worksheetStop(this.Task, this.page2, {super.key});
  @override
  _worksheetStopState createState() => _worksheetStopState();
}

class _worksheetStopState extends State<worksheetStop> {
  String pauseCek = "aktif";
  String btnContinue = "";
  String btnNext = "";
  String stress = "";
  int page2 = 0;
  Timer? handOff;
  Timer? sendWrksht;
  Connection objCekConnection = Connection();
  bool checkMandatory = true;
  @override
  void initState() {
    super.initState();
    initBtns();
    _checkMandatoryField();
    markedPage();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "task_worksheet");
  }

  //TODO:check mandatory field
  _checkMandatoryField() async {
    int page2Checkmandatory = 0;
    print("checkMandatory from self function");
    print(checkMandatory);
    print(widget.page2);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    final objBox = boxData(nameBox: 'box_valworksheet');
    var data = await objBox.getValueWorksheet(
        taskid: widget.Task['id'].toString(), userid: userId);
    bool result = true;
    final getboxWorksheetsetting = boxData(nameBox: 'box_workSheetSetting');
    dynamic dataWorksheetsetting =
        await getboxWorksheetsetting.getValueSettingFormWorksheet(
                userid: userId, taskid: widget.Task['id'].toString()) ??
            {};
    if (dataWorksheetsetting != {}) {
      page2Checkmandatory = dataWorksheetsetting['page2'];
      print("page2_checkMandatory");
      print(page2Checkmandatory);
    } else {
      page2Checkmandatory = int.parse(widget.page2);
    }
    data.forEach((key, value) {
      if (page2Checkmandatory == 2) {
        if (key == 'x_studio_pic_' && (value == '' || value == false)) {
          print('return false 2');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_after' && (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_sekitar_cold_storage_1_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_sekitar_cold_storage_2_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_anteroom_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_genset_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_1_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_2_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_3_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_mesin_after' &&
            (value == '' || value == false)) {
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
      } else {
        if (key == 'x_studio_tegangan' && (value == '' || value == false)) {
          print('return false 1');

          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          setState(() {});
          return false;
        }

        if (key == 'x_studio_before' && (value == '' || value == false)) {
          print('return false 3');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }

        ///24092022
        if (key == 'x_studio_tipe_kompresor_1' &&
            (value == '' || value == false)) {
          print('tipe kompressor');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }

        ///
        if (key == 'x_studio_kerusakan' && (value == '' || value == false)) {
          print('return false 4');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_unit_1' && (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_hasil_akhir_analisa_' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        //Unit besar
        if (key == 'x_studio_foto_sekitar_cold_storage_1' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_sekitar_cold_storage_2' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_anteroom' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_genset' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_1' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_2' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_lorong_freezer_3' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }
        if (key == 'x_studio_foto_ruang_mesin' &&
            (value == '' || value == false)) {
          print('return false 5');
          checkMandatory = false;
          setState(() {});
          return checkMandatory;
          return false;
        }

        // x_studio_foto_sekitar_cold_storage_1
        // x_studio_foto_sekitar_cold_storage_2
        // x_studio_foto_ruang_anteroom
        // x_studio_foto_ruang_genset
        // x_studio_foto_lorong_freezer_1
        // x_studio_foto_lorong_freezer_2
        // x_studio_foto_lorong_freezer_3
        // x_studio_foto_ruang_mesin
        // x_studio_foto_sekitar_cold_storage_1_after
        // x_studio_foto_sekitar_cold_storage_2_after
        // x_studio_foto_ruang_anteroom_after
        // x_studio_foto_ruang_genset_after
        // x_studio_foto_lorong_freezer_1_after
        // x_studio_foto_lorong_freezer_2_after
        // x_studio_foto_lorong_freezer_3_after
        // x_studio_foto_ruang_mesin_after
        //
      }
    });
    setState(() {});
    return checkMandatory;
  }

  //
  initBtns() async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userID = await boxdata.getLoginCredential(param: "userId");

    var WorksheetForm = await Hive.openBox("box_valworksheet");
    var ppp = json.encode(WorksheetForm.get(userID)).toString();
    // print("ppp ${ppp}")
    stress = ppp;
    if (widget.page2 == 2) {
      btnNext = 'Kirim';
      btnContinue = 'Perbaikan';
    } else {
      final boxdata = boxData(nameBox: "box_setLoginCredential");

      String userid = await boxdata.getLoginCredential(param: "userId");
      final getcommonSetting = await Hive.openBox("box_workSheetSetting");
      if (getcommonSetting.isNotEmpty) {
        var data = getcommonSetting.get(userid);
        for (var val in data) {
          if (val['taskid'] == widget.Task['id'].toString()) {
            var valData = val['data'];
            if (valData['page2'] == 2) {
              btnNext = 'Kirim';
              btnContinue = 'Perbaikan';
            } else {
              btnContinue = 'Pengecekan';
              btnNext = 'Perbaikan';
            }
            break;
          }
        }
        setState(() {});
        // print("data['btnnameeeee]");
        // print(data['btnname']);
        // btnContinue = data['btnname'];
      } else {}
    }

    resetListUpload(bool ceck) async {}
    // final boxdata = boxData(nameBox: "box_setLoginCredential");
    //
    // String userid = await boxdata.getLoginCredential(param: "userId");
    // final getcommonSetting = await Hive.openBox("box_workSheetSetting");
    // if (getcommonSetting.isNotEmpty) {
    //   var data = getcommonSetting.get(userid);
    //   for (var val in data) {
    //     if (val['taskid'] == widget.Task['id'].toString()) {
    //       var valData = val['data'];
    //       if (valData['page2'] == 2) {
    //         btnNext = 'Kirim';
    //         btnContinue = 'Fixing';
    //       } else {
    //         btnContinue = 'Checking';
    //         btnNext = 'Fixing';
    //         btnNext = 'Fixing';
    //       }
    //       break;
    //     }
    //   }
    //   setState(() {});
    //   // print("data['btnnameeeee]");
    //   // print(data['btnname']);
    //   // btnContinue = data['btnname'];
    //
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(
                    height: MySize.getScaledSizeHeight(150),
                  ),
                  Image(
                    width: MySize.getScaledSizeWidth(65),
                    height: MySize.getScaledSizeHeight(65), //160
                    image: AssetImage('assets/images/no.png'),
                  ),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(11),
                  ),
                  const Text(
                    "Proses Dihentikan",
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        color: Color(0xFF9e9e9e),
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(100),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   iconSize: 50,
                  //   icon: Icon(
                  //     Icons.help,
                  //     color: Colors.black45,
                  //   ),
                  // ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(259, 63),
                      padding: EdgeInsets.only(left: 43, right: 43),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: AppTheme.warnaHijau,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(72.5)),
                      ),
                    ),
                    onPressed: () async {
                      // saveWorksheet(values, Task);
                      //cek status btnname
                      await btnAction(
                          widget.Task['id'].toString(), pauseCek, false);
                      DefaultTabController.of(context).animateTo(0);
                    },
                    child: Text("Lanjut $btnContinue",
                        style: AppTheme.OpenSans600LS(
                            16, AppTheme.warnaHijau, -0.41)),
                  ),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(16),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          checkMandatory ? AppTheme.warnaHijau : Colors.grey,
                      minimumSize: Size(259, 63),
                      padding: EdgeInsets.only(left: 43, right: 43),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(72.5)),
                      ),
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: Center(
                              child: Container(
                                width: 300 * MySize.scaleFactorWidth,
                                height: 200 * MySize.scaleFactorHeight,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      // backgroundColor: Colors.transparent,
                                      color: AppTheme.warnaHijau,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: AppTheme.warnaHijau,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      //lakukan aksi
                      bool dataUpload = false;
                      bool sendData = false;
                      bool result = false;
                      final boxdata =
                          boxData(nameBox: "box_listUploadWorksheet");
                      Network cekKoneksi =
                          await objCekConnection.CheckConnection();
                      // _checkMandatoryField();
                      if (btnNext == 'Perbaikan' && checkMandatory) {
                        print("save checking");
                        //di disable 08022022
                        // box_workSheetSetting(
                        //     taskid: widget.Task["id"].toString(),
                        //     tabbar: 1,
                        //     btnname: "Fixing",
                        //     page2: 2,
                        //     pause: "aktif");
                        //close tag
                        //cek data di list, klo ada tunggu kosong, klo ga ada loading ilang

                        if (cekKoneksi.Status) {
                          sendWrksht = Timer.periodic(
                              Duration(milliseconds: 1800), (Timer t) async {
                            Network cekKoneksiloop =
                                await objCekConnection.CheckConnection();
                            if (cekKoneksiloop.Status) {
                              dataUpload = await boxdata.cekDataOnListUpload(
                                  widget.Task['id'].toString());
                              print("dataupload");
                              print(dataUpload);
                              if (dataUpload && !sendData) {
                                sendData = true;
                                //TODO Timeout

                                //TODO fungsi untuk auto close popup jika popup nge freeze
                                // bool autoClose = false;
                                // Future.delayed(new Duration(seconds: 7),
                                //     () async {
                                //   if (!autoClose) {
                                //     print("autoclose is active");
                                //
                                //     final boxdata = boxData(
                                //         nameBox: "box_setLoginCredential");
                                //
                                //     String userId = await boxdata
                                //         .getLoginCredential(param: "userId");
                                //     final box_OpenDataUpload = await Hive.openBox(
                                //         "box_listUploadWorksheet");
                                //     final box_AddnDataUpload =
                                //         Hive.box("box_listUploadWorksheet");
                                //
                                //     bool checkdata = false;
                                //     List deleteData = [];
                                //     if (box_OpenDataUpload.isNotEmpty) {
                                //       if (userId != null) {
                                //         final data = List.from(
                                //             box_OpenDataUpload.get(userId) ?? []);
                                //         if (data.isNotEmpty) {
                                //           for (var val in data) {
                                //             val['upload'] = 0;
                                //             if (val['taskid'] ==
                                //                 widget.Task['id'].toString()) {
                                //               deleteData.add(val);
                                //               print(val);
                                //             }
                                //           }
                                //           for (var val in deleteData) {
                                //             data.remove(val);
                                //           }
                                //           box_AddnDataUpload.delete(userId);
                                //           box_AddnDataUpload.put(userId, data);
                                //
                                //           print(data);
                                //         }
                                //       }
                                //       sendData = false;
                                //     }
                                //   } else {
                                //     print("autoclose is not active");
                                //   }
                                // });

                                //close tag
                                //                              //
                                result = await saveWorksheet(widget.Task, "1");
                                if (!result) {
                                  sendData = false;

                                  ///close popup if failed send data to server
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "gagal mengirim data ke server")));
                                    Navigator.of(context).pop();
                                  }

                                  ///
                                } else {
                                  // autoClose = true;
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                  DefaultTabController.of(context).animateTo(0);
                                  sendWrksht!.cancel();
                                }
                              }
                            } else {
                              //add 25072022 part 2 saat timesheet fix
                              if (!sendData) {
                                sendData = true;

                                result = await saveWorksheet(widget.Task, "1");
                              }
                              //closetag
                              if (!result) {
                                final downMessage = PopupError();

                                if (mounted) {
                                  downMessage.showError(
                                      context, cekKoneksi, false, mounted);
                                  Navigator.of(context).pop();
                                }
                                DefaultTabController.of(context).animateTo(0);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        " anda tidak terhubung ke jaringan internet,data tersimpan di memori device")));
                                sendWrksht!.cancel();
                              }
                            }
                          });

                          //TODO timeout

                          //
                        } else {
                          await saveWorksheet(widget.Task, "1");
                          final downMessage = PopupError();

                          if (mounted) {
                            downMessage.showError(
                                context, cekKoneksi, false, mounted);
                            Navigator.of(context).pop();
                          }
                          DefaultTabController.of(context).animateTo(0);
                        }

                        // calculateTimer(page2.toString());
                      } else {
                        //TODO btnnext kirim
                        if (checkMandatory) {
                          if (cekKoneksi.Status) {
                            sendWrksht = Timer.periodic(
                                Duration(milliseconds: 1300), (Timer t) async {
                              Network cekKoneksiloop =
                                  await objCekConnection.CheckConnection();
                              if (cekKoneksiloop.Status) {
                                dataUpload = await boxdata.cekDataOnListUpload(
                                    widget.Task['id'].toString());
                                print("datauploadcek di button save kirim");
                                print(dataUpload);
                                if (dataUpload && !sendData) {
                                  print("save fixing");
                                  sendData = true;
                                  // //TODO Timeout
                                  //
                                  // //TODO fungsi untuk auto close popup jika popup nge freeze
                                  // bool autoClose = false;
                                  // Future.delayed(new Duration(seconds: 10),
                                  //     () async {
                                  //   if (!autoClose) {
                                  //     print("autoclose is active");
                                  //     if (mounted) {
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(SnackBar(
                                  //               content: Text(
                                  //                   "send data gagal harap coba lagi")));
                                  //       Navigator.of(context).pop();
                                  //     }
                                  //     sendWrksht!.cancel();
                                  //     sendData = false;
                                  //   } else {
                                  //     print("autoclose is not active");
                                  //   }
                                  // });

                                  // close tag
                                  result =
                                      await saveWorksheet(widget.Task, "3");

                                  if (!result) {
                                    sendData = false;

                                    ///close popup if failed send data to server
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "gagal mengirim data ke server, harap mencoba kembali dan pastikan anda memiliki jaringan internet")));
                                      Navigator.of(context).pop();
                                    }

                                    ///
                                  } else {
                                    final snackBarSuccess = SnackBar(
                                      content: Text('Berhasil mengirim data ke server'),
                                      backgroundColor: AppTheme.warnaHijau,
                                            behavior: SnackBarBehavior.floating,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBarSuccess);
                                    sendWrksht!.cancel();

                                    await Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(0),
                                            ),
                                            (route) => false);
                                  }
                                  // Navigator.pop(context);
                                }
                              } else {
                                if (!result) {
                                  final downMessage = PopupError();

                                  if (mounted) {
                                    downMessage.showError(
                                        context, cekKoneksi, false, mounted);
                                    Navigator.of(context).pop();
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              " Pastikan anda memiliki jaringan internet pada tahap kirim data")));
                                  //
                                  sendWrksht!.cancel();
                                }
                              }
                            });
                          } else {
                            final downMessage = PopupError();

                            // await saveWorksheet(widget.Task, "3");
                            if (mounted) {
                              downMessage.showError(
                                  context, cekKoneksi, false, mounted);
                              Navigator.of(context).pop();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Anda sedang offline, tidak dapat mengirimkan data."),
                              backgroundColor: Colors.red,
                            ));
                            // Navigator.of(context).pop();
                            // await ubahStatusTask(
                            //     widget.Task['id'].toString(), "Pending Upload");
                          }
                        } else {
                          // await saveWorksheet(widget.Task, "3");// edited 20072022
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Lengkapi data yang bertanda bintang (*) pada form LPU")));
                        }
                      }
                      await btnAction(
                          widget.Task['id'].toString(), pauseCek, false);
                    },
                    child: Text("Lanjut $btnNext",
                        style: AppTheme.OpenSans600LS(16, Colors.white, -0.41)),
                  ),
                  SizedBox(
                    height: MySize.getScaledSizeHeight(16),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(259, 63),
                      padding: const EdgeInsets.only(left: 43, right: 43),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: AppTheme.warnaDongker,
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(72.5)),
                      ),
                    ),
                    onPressed: () async {
                      final notifApi = NotificationApi();
                      await notifApi
                          .drainStream('from page task_worksheet handoff');
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: Center(
                              child: Container(
                                width: 300 * MySize.scaleFactorWidth,
                                height: 200 * MySize.scaleFactorHeight,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(
                                      // backgroundColor: Colors.transparent,
                                      color: AppTheme.warnaHijau,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: AppTheme.warnaHijau,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      Network cekKoneksi =
                          await objCekConnection.CheckConnection();
                      if (cekKoneksi.Status) {
                        var listUploadWorksheet =
                            await Hive.openBox("box_listUploadWorksheet");
                        bool sendData = false;
                        bool dataUpload = false;
                        bool result = false;

                        final boxdata =
                            boxData(nameBox: "box_listUploadWorksheet");
                        handOff = Timer.periodic(Duration(milliseconds: 1800),
                            (Timer t) async {
                          Network cekKoneksiloop =
                              await objCekConnection.CheckConnection();
                          if (cekKoneksiloop.Status) {
                            dataUpload = await boxdata.cekDataOnListUpload(
                                widget.Task['id'].toString());
                            // print("dataupload di serahterima kerjaan");
                            print(dataUpload);
                            if (dataUpload && !sendData) {
                              var updateDasboard =
                                  boxData(nameBox: 'box_dashboard');
                              print("pauseCek dari serahterima page");
                              print(pauseCek);
                              await btnAction(
                                  widget.Task['id'].toString(), pauseCek, true);
                              // //TODO Timeout
                              //
                              // //TODO fungsi untuk auto close popup jika popup nge freeze
                              // bool autoClose = false;
                              // Future.delayed(new Duration(seconds: 10), () async {
                              //   if (!autoClose) {
                              //     print("autoclose is active");
                              //     if (mounted) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //               content: Text(
                              //                   "send data gagal harap coba lagi")));
                              //       Navigator.of(context).pop();
                              //     }
                              //     handOff!.cancel();
                              //     sendData = false;
                              //   } else {
                              //     print("autoclose is not active");
                              //   }
                              // });

                              // close tag

                              if (btnContinue == "Pengecekan") {
                                sendData = true;
                                result = await handedOff(widget.Task, "1");
                                if (!result) {
                                  sendData = false;

                                  ///close popup if failed send data to server
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "gagal mengirim data ke server, harap mencoba kembali dan pastikan anda memiliki jaringan internet")));
                                    Navigator.of(context).pop();
                                  }

                                  ///
                                } else {
                                  // autoClose = true;
                                }
                              } else {
                                sendData = true;
                                result = await handedOff(widget.Task, "2");
                                if (!result) {
                                  sendData = false;

                                  ///close popup if failed send data to server
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "gagal mengirim data ke server, harap mencoba kembali dan pastikan anda memiliki jaringan internet")));
                                    Navigator.of(context).pop();
                                  }

                                  ///
                                } else {
                                  // autoClose = true;
                                }
                              }

                              // Navigator.of(context).pop();
                              if (result) {
                                // autoClose = true;
                                handOff!.cancel();

                                if (mounted) {
                                  await Navigator.of(context)
                                      .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(0),
                                          ),
                                          (route) => false);
                                }
                              }
                            }
                          } else {
                            if (!result) {
                              final downMessage = PopupError();
                              if (mounted) {
                                downMessage.showError(
                                    context, cekKoneksi, true, mounted);
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text(
                                //         "anda tidak terhubung ke jaringan internet")));
                                Navigator.of(context).pop();
                              }

                              handOff!.cancel();
                            }
                          }
                        });
                      } else {
                        final downMessage = PopupError();

                        if (mounted) {
                          Navigator.of(context).pop();
                          downMessage.showError(
                              context, cekKoneksi, true, mounted);
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     content: Text(
                          //         "anda tidak terhubung ke jaringan internet")));
                        }
                      }
                    },
                    child: Text("Serahkan ke orang lain",
                        style: AppTheme.OpenSans600LS(
                            16, AppTheme.warnaDongker, -0.41)),
                  ),
                  // Text(stress),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//button di tab stop
// box_workSheetSetting(
// id: widget.Task["id"].toString(),
// tabbar: 2,
// btnname: "",
// page2: 0,
// pause: "",
// progress: true);

btnAction(String taskid, String pauseCek, bool handedoff) async {
  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userid = await boxdata.getLoginCredential(param: "userId");
  dynamic data = {};
  int page2 = 0;
  final objBox = boxData(nameBox: "box_workSheetSetting");

  data =
      await objBox.getValueSettingFormWorksheet(userid: userid, taskid: taskid);
  print('datanyaaa ${data}');
  if (data != null) {
    if (data['pause'] != null && data['pause'] != "") {
      pauseCek = data['pause'];
    }
    if (data['btnname'] != null) {
      if (data['btnname'] == "Fixing" || data['btnname'] == "Kirim") {
        page2 = 2;
      }
      print(data);
    }
  }

  if (!handedoff) {
  } else {
    //handedoff
    box_workSheetSetting(
      taskid: taskid,
      tabbar: 0,
      btnname: data['btnname'],
      page2: page2,
      pause: "deaktif",
    );
  }
}

//ubah param statusTask di box_listPekerjaan
// ubahStatusTask(String taskid, String status) async {
//   Preferences pref = Preferences();
//   String userId = await pref.getUserId();
//   // var box_AddList = Hive.box("box_listPekerjaan");
//   // //open box list pekerjaan
//   // var box_openListPekerjaan = await Hive.openBox("box_listPekerjaan");
//   //
//   // final data = box_openListPekerjaan.get(taskid);
//   // data['statusTask'] = status;
//   // box_AddList.put(taskid, data);
//   // print(data);
//
//   var updateList = boxData(nameBox: 'box_listPekerjaan');
//
//   updateList.UpdateListTask(userid: userId, statusTask: status, taskid: taskid);
//   if (status == "Pending Upload") {
//     print("pending upload");
//     var updateDasboard = boxData(nameBox: 'box_dashboard');
//     updateDasboard.addDataDashboard(param: 'taskPendingKirim', tambah: true);
//   }
// }

Future<bool> handedOff(dynamic Task, String Status) async {
  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userID = await boxdata.getLoginCredential(param: "userId");
  var WorksheetForm = await Hive.openBox("box_valworksheet");
  print("status dari handoff");
  print(Status);
  if (WorksheetForm.isNotEmpty) {
    // List dataFill = [WorksheetForm.get(Task["id"].toString())];
    // Map<String, dynamic> indexedData = {};

    // List dataFill = [WorksheetForm.get(userID)];
    // Map<String, dynamic> indexedData = {};
    final objBox = boxData(nameBox: 'box_valworksheet');
    var data = await objBox.getValueWorksheet(
        taskid: Task['id'].toString(), userid: userID);
    Map<String, dynamic> dataFilter = {};
    data.forEach((i, value) {
      if (value != false && value != null && value != "") {
        dataFilter[i] = value;
      }
    });
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    int taskid;
    if (Task['id'].runtimeType == String) {
      taskid = int.parse(Task['id']);
    } else {
      taskid = Task['id'];
    }
    String userid = await boxdata.getLoginCredential(param: "userId");
    WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
    Network objNetwork = await objWorksheetNetwork.saveWorksheetForm(
        userId: int.parse(userid),
        taskId: taskid,
        worksheet: dataFilter,
        status: Status,
        open: 1); // klo udah bisa aktifkan ini
    if (objNetwork.Status) {
      final boxdata = boxData(nameBox: "box_listPekerjaan");
      await boxdata.deleteTask(
          userid: userid, taskid: taskid, from: "Handed Off");
      //Todo Delete Notif
      final boxlistNotif = boxData(nameBox: "box_listMessages");
      boxlistNotif.deleteNotif(taskid: taskid.toString(), userid: userid);
      //
      return true;
    } else {
      return false;
    }
  }
  return false;
}

class TaskWorksheet extends StatefulWidget {
  dynamic Task;
  dynamic statusTask;
  dynamic objDataTask;
  String dataStsWrkShtServer;
  // dynamic Tabbar
  TaskWorksheet(
      this.Task, this.objDataTask, this.statusTask, this.dataStsWrkShtServer,
      {super.key});

  @override
  State<TaskWorksheet> createState() => _TaskWorksheetState(Task);
}

class _TaskWorksheetState extends State<TaskWorksheet> {
  dynamic Task;

  int page1 = 1;
  int page2 = 0;

  Map<String, dynamic> values = {};

  callback(newValue) {
    // setState(() {
    values = newValue;
    // print('values 213');
    // print(values);
    // });
  }

  @override
  initState() {
    super.initState();
    if (widget.dataStsWrkShtServer == '2') {
      page2 = 2;
      print("page2 dari init");
      print(page2);
      markedPage();
    }
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "task_worksheet");
  }

  _TaskWorksheetState(this.Task);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: ChangeNotifierProvider<workSheetFormNotifier?>(
                    create: (context) =>
                        workSheetFormNotifier(Task, widget.statusTask),
                    child: Builder(builder: (BuildContext context) {
                      return TaskWorksheeyWidget(
                        widget.Task,
                        widget.objDataTask,
                        widget.statusTask,
                        callback,
                        page1,
                        page2,
                      );
                    }))),
            // Container(
            //   child: Center(
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor:  AppTheme.warnaHijau,
            //         minimumSize: Size(289, 63),
            //         padding: EdgeInsets.only(left: 43, right: 43),
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(20)),
            //         ),
            //       ),
            //       onPressed: () {
            //         if (page == 1) {
            //           page = 2;
            //           setState(() {});
            //         } else if (page == 2) {
            //           saveWorksheet(values, Task);
            //         }
            //       },
            //       child: Text(page == 1 ? "Checking" : "Terima",
            //           style: AppTheme.OpenSans600LS(16, Colors.white, -0.41)),
            //     ),
            //   ),
            // )
          ],
        )),
      ),
    );
  }
}

Future<bool> saveWorksheet(dynamic Task, String Status) async {
  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userID = await boxdata.getLoginCredential(param: "userId");

  var WorksheetForm = await Hive.openBox("box_valworksheet");
  // return WorksheetForm.get(userID);
  if (WorksheetForm.isNotEmpty) {
    List dataFill = [WorksheetForm.get(userID)];
    Map<String, dynamic> indexedData = {};
    final objBox = boxData(nameBox: 'box_valworksheet');
    var data = await objBox.getValueWorksheet(
        taskid: Task['id'].toString(), userid: userID);
    Map<String, dynamic> dataFilter = {};
    data.forEach((i, value) {
      // print('index=$i, value=$value');
      // print(value.runtimeType);
      if (value != false && value != null && value != "") {
        dataFilter[i] = value;
      }
    });

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    var taskid;
    if (Task['id'].runtimeType == String) {
      taskid = int.parse(Task['id']);
    } else {
      taskid = Task['id'];
    }
    String userid = await boxdata.getLoginCredential(param: "userId");
    WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
    Network objNetwork = await objWorksheetNetwork.saveWorksheetForm(
        userId: int.parse(userid),
        taskId: taskid,
        worksheet: dataFilter,
        status: Status);
    if (objNetwork.Status) {
      if (Status == "3") {
        // final boxdata = boxData(nameBox: "box_listPekerjaan");
        // await boxdata.deleteTask(
        //     userid: userid, taskid: taskid, from: "Completed");
        box_workSheetSetting(
            taskid: Task["id"].toString(),
            tabbar: 0,
            btnname: "Kirim",
            page2: 2,
            // page2: int.parse(widget.page2),
            pause: "aktif");
        //Todo Delete Notif
        final boxlistNotif = boxData(nameBox: "box_listMessages");

        boxlistNotif.deleteNotif(taskid: Task["id"].toString(), userid: userid);
        //
      } else if (Status == "1") {
        box_workSheetSetting(
            taskid: Task["id"].toString(),
            tabbar: 1,
            btnname: "Fixing",
            page2: 2,
            pause: "aktif");
      }
      return true;
    } else {
      print('send data from fucntion saveworksheet');
      if (Status == "1") {
        box_workSheetSetting(
            taskid: Task["id"].toString(),
            tabbar: 1,
            btnname: "Fixing",
            page2: 2,
            pause: "aktif");
      }
    }
  }
  return false;
}

class TaskWorksheeyWidget extends StatefulWidget {
  dynamic Task;
  int page1;
  int page2;
  dynamic statusTask;
  dynamic objDataTask;

  Map<String, dynamic> valuess = {};
  Function(Map<String, dynamic>) callback;
  TaskWorksheeyWidget(this.Task, this.objDataTask, this.statusTask,
      this.callback, this.page1, this.page2,
      {super.key});
  late dynamic objData;
  @override
  State<TaskWorksheeyWidget> createState() =>
      _TaskWorksheeyWidgetState(Task, callback, page1, page2);
}

class _TaskWorksheeyWidgetState extends State<TaskWorksheeyWidget> {
  //variabel timer, atau pewaktu task
  Duration duration = Duration();
  int detik = 0;
  int menit = 0;
  int jam = 0;
  bool lastSavedUser = false;
  Timer? timer;

  runTimer() async {
    const addSeconds = 1;
    final boxtimerTemporary = boxData(nameBox: "box_TimerTemporary");

    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: seconds);
        final dataList = [
          duration.inHours.remainder(99),
          duration.inMinutes.remainder(60),
          duration.inSeconds.remainder(60)
        ];
        boxtimerTemporary.savingTimer_temporary(
            Taskid: widget.Task['id'].toString(), Timer: dataList);
      });
    }
  }

  stopTimer() async {
    //TODO initial trigger timer false, for inactive
    final getTriggerTimer = await Hive.openBox('box_triggerTimer_Worksheet');
    final changeTimer = Hive.box('box_triggerTimer_Worksheet');
    if (getTriggerTimer.isNotEmpty) {
      changeTimer.put('triggerTimer', false);
    } else {
      changeTimer.put('triggerTimer', false);
    }
    //close tag
    duration = Duration();
    timer?.cancel();
  }

  calculateTimer(String page) {
    // twoDigits(duration.inMinutes);
    fillField = false;
    String data = '00:00';
    int dataToServer = 0;
    if (duration.inHours < 10) {
      data =
          '0${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
    } else {
      data =
          '${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
    }
    dataToServer = duration.inSeconds;
    stopTimer();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => listTimesheet(
          taskId: widget.Task['id'].runtimeType != int
              ? int.parse(widget.Task['id'])
              : widget.Task['id'],
          timeRecord: data,
          statusTask: page,
          timeServer: dataToServer,
        ),
      ),
    );
    DefaultTabController.of(context).animateTo(1);
    setState(() {});
  }

  @override
  dispose() {
    saveTimer();
    stopTimer();
    replaceLastSavedWorksheet(lastSavedUser);
    super.dispose();
  }

  replaceLastSavedWorksheet(bool statusLastSaved) async {
    print("statusLastSaved");
    print(statusLastSaved);
    if (statusLastSaved) {
      saveWorksheet(widget.Task, widget.statusTask);
    }
  }

  Future<void> saveTimer() async {
    print('save timer from dispose');
    final boxtimerTemporary = boxData(nameBox: "box_TimerTemporary");
    final boxtimerWorksheet = boxData(nameBox: "box_TimerWorksheet");
    List getTimerTemporary = List.from(await boxtimerTemporary
            .getTimer_temporary(Taskid: Task['id'].toString()) ??
        []);
    if (getTimerTemporary.isNotEmpty) {
      print('saving process');
      print(getTimerTemporary);
      Map<String, dynamic> saveTimer = {};
      final formatTimer = ['jam', 'menit', 'detik'];
      saveTimer['taskid'] = widget.Task['id'].toString();
      for (int i = 0; i < getTimerTemporary.length; i++) {
        saveTimer[formatTimer[i]] = getTimerTemporary[i];
      }
      await boxtimerWorksheet.saveTimer(saveTimer);
      await boxtimerTemporary.deleteTimer_temporary(
          Taskid: widget.Task['id'].toString());
    }
  }

  startTimer() async {
    //TODO initial trigger timer true,for active
    final opentimerWorksheet = boxData(nameBox: 'box_TimerWorksheet');
    final gettimerWorksheet = Map.from(
        await opentimerWorksheet.getTimer(widget.Task['id'].toString()));
    print("getTimer_Worksheet");
    print(gettimerWorksheet);
    if (gettimerWorksheet.isNotEmpty) {
      duration = Duration(
          hours: gettimerWorksheet['jam'],
          minutes: gettimerWorksheet['menit'],
          seconds: gettimerWorksheet['detik']);
    }
    //close tag

    timer = Timer.periodic(Duration(seconds: 1), (_) async => runTimer());
    print("timerun");
    print(duration);
  } //

  // time untuk mengaktifkan field btnName untuk nama button action
  bool fillField = false;
  String btnName = "Checking";
  //on dan off tiap field
  bool timesheetStatus = false;
  String timesheet = "";
  //variabel nampung nilai dari tiap field
  Map<String, dynamic> valuess = {};
// pengatur tampilan checking atau fixing tab onprogress
  int page1 = 1;
  int page2 = 0;
  int _state = 0;
  // validasi field mandatory
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  dynamic Task;
  dynamic objData;

  File _image = File("");
  final String _conv = "";
  File _imageSelect = File("");
  final _picker = ImagePicker();
  Timer? _debounce;
  Function(Map<String, dynamic>) callback;
  _TaskWorksheeyWidgetState(this.Task, this.callback, this.page1, this.page2);

  dynamic dataValueBox;
  dynamic dataFormPure;
  int countPartDiganti = 1;
  int tresholdPartDiganti = 6;
  @override
  void initState() {
    super.initState();
    _loadpage(widget.Task['id']);
    markedPage();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "task_worksheet");
  }

  _checkMandatoryField(dynamic data, int page) {
    bool result = true;
    data.forEach((key, value) {
      if (key == 'x_studio_tegangan' && (value == '' || value == false)) {
        print('return false 1');
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_pic_' &&
          (value == '' || value == false)) {
        print('return false 2');
        result = false;
        return result;
      }
      if (key == 'x_studio_before' && (value == '' || value == false)) {
        print('return false 3');
        result = false;
        return result;
      }
      if (key == 'x_studio_kerusakan' && (value == '' || value == false)) {
        print('return false 4');
        result = false;
        return result;
      }
      if (key == 'x_studio_foto_unit_1' && (value == '' || value == false)) {
        print('return false 5');
        result = false;
        return result;
      }
      if (key == 'x_studio_hasil_akhir_analisa_' &&
          (value == '' || value == false)) {
        print('return false 7');
        result = false;
        return result;
      }

      ///24092022
      if (key == 'x_studio_tipe_kompresor_1' &&
          (value == '' || value == false)) {
        print('tipe kompressor');
        result = false;

        return result;
      }
      //Unit besar
      if (key == 'x_studio_foto_sekitar_cold_storage_1' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_sekitar_cold_storage_2' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_ruang_anteroom' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_ruang_genset' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_lorong_freezer_1' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_lorong_freezer_2' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_lorong_freezer_3' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }
      if (key == 'x_studio_foto_ruang_mesin' &&
          (value == '' || value == false)) {
        result = false;

        return result;
      }

      //
      ///

      if (page == 2 &&
          key == 'x_studio_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }

      if (page == 2 &&
          key == 'x_studio_foto_sekitar_cold_storage_1_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_sekitar_cold_storage_2_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_ruang_anteroom_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_ruang_genset_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_lorong_freezer_1_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_lorong_freezer_2_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_lorong_freezer_3_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
      if (page == 2 &&
          key == 'x_studio_foto_ruang_mesin_after' &&
          (value == '' || value == false)) {
        result = false;
        return result;
      }
    });
    return result;
  }

  _loadpage(dynamic taskid) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");
    print(" loadpage");
    final objBox = boxData(nameBox: "box_workSheetSetting");
    final data = await objBox.getValueSettingFormWorksheet(
        userid: userid, taskid: widget.Task['id'].toString());
    print("data  with $taskid is not empty line 831");
    print(data);
    if (data != null) {
      if (data['page2'] != null && page2 != 2) {
        page2 = data['page2'];
      }

      // print(data['page2']);
      if (data['btnname'] != null && data['btnname'] != "") {
        btnName = data['btnname'];
      }
      if (btnName == "Kirim") {
        fillField = false;
      }
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text("Terima",
          style: AppTheme.OpenSans600LS(16, AppTheme.warnaHijau, -0.41));
    } else if (_state == 1) {
      Future.delayed(Duration(seconds: 15), () async {
        Connection objCekConnection = Connection();
        Network cekKoneksi = await objCekConnection.CheckConnection();
        // print("Cek Koneksi isnternet di setupbuttonchild");
        print('hasilnya: ${cekKoneksi.Status}');
        if (!cekKoneksi.Status) {
          final downMessage = PopupError();
          if (mounted) {
            downMessage.showError(context, cekKoneksi, true, mounted);
          }

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text("anda tidak terhubung ke jaringan internet")));
        }
        if (mounted) {
          setState(() {
            _state = 0;
          });
        }
      });
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.warnaHijau),
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
  Widget build(BuildContext context) {
    return Consumer<workSheetFormNotifier>(builder: (_, value, __) {
      // value.listValue().forEach((element) {});
      objData = value.listValue();
      lastSavedUser = value.lastSaved();
      // print('consumer reload');
      // tresholdPartDiganti = value.getTresholdPart();
      valuess = value.listKey();
      widget.callback(valuess);
      dataValueBox = value.listDataLocal();

      dataFormPure = value.getDataFormPure();
      late int length;
      if (objData != null) {
        length = objData.length;
      } else {
        length = 0;
      }

      return MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 20, 8),
            child: (length != 0)
                ? Column(
                    children: [
                      (fillField && btnName != 'Kirim')
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.0, color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView.builder(
                            // key: _formKeys,
                            itemCount: length,
                            itemBuilder: (BuildContext context, int index) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    textScaler: TextScaler.linear(1.0)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //TODO generator widgets
                                    children: WorkSheetArray(objData[index])),
                              );
                              // return TextField(
                              //     // controller: myController,
                              //     );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (widget.statusTask == 'OnGoing')
                          ? Container(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    btnName != "Kirim"
                                        ? (ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: !fillField
                                                  ? AppTheme.warnaHijau
                                                  : Colors.red,
                                              minimumSize: Size(89, 63),
                                              padding: const EdgeInsets.only(
                                                  left: 43, right: 43),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (!fillField) {
                                                fillField = true;
                                                startTimer();

                                                setState(() {});
                                              } else {
                                                // FocusScope.of(context)
                                                //     .unfocus();
                                                //TODO empty Timer
                                                final boxTimerTemporary = boxData(
                                                    nameBox:
                                                        "box_TimerTemporary");
                                                final boxTimerWorksheet = boxData(
                                                    nameBox:
                                                        "box_TimerWorksheet");
                                                boxTimerTemporary
                                                    .deleteTimer_temporary(
                                                        Taskid: widget
                                                            .Task['id']
                                                            .toString());
                                                boxTimerWorksheet.deleteTimer(
                                                    Taskid: widget.Task['id']
                                                        .toString());

                                                //closetag

                                                var validateCheck = false;
                                                validateCheck =
                                                    _checkMandatoryField(
                                                        dataValueBox, page2);

                                                print(validateCheck);
                                                print("validate");

                                                //check validation dari button
                                                final FormState? form =
                                                    _formKey.currentState;

                                                if (form!.validate() &&
                                                    validateCheck &&
                                                    duration.inSeconds > 0) {
                                                  box_workSheetSetting(
                                                      taskid: widget.Task["id"]
                                                          .toString(),
                                                      tabbar: 1,
                                                      btnname: "",
                                                      page2: page2,
                                                      pause: "aktif");
                                                  if (page2 == 2) {
                                                    calculateTimer(
                                                        page2.toString());
                                                  } else {
                                                    calculateTimer("1");
                                                  }
                                                } else {
                                                  if (duration.inSeconds > 0) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: const Text(
                                                                "lengkapi data yang bertanda bintang (*)")));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "waktu record minimal 1 detik")));
                                                  }
                                                }
                                              }
                                            },
                                            child: !fillField
                                                ? Text("Start",
                                                    style:
                                                        AppTheme.OpenSans600LS(
                                                            16,
                                                            Colors.white,
                                                            -0.41))
                                                : Text("Stop",
                                                    style:
                                                        AppTheme.OpenSans600LS(
                                                            16,
                                                            Colors.white,
                                                            -0.41)),
                                          ))
                                        : (Container())
                                  ],
                                ),
                              ),
                            )
                          : (widget.statusTask == "Open"
                              ? Container(
                                  child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white70,
                                              minimumSize: Size(89, 63),
                                              padding: const EdgeInsets.only(
                                                  left: 43, right: 43),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                            ),
                                            onPressed: () async {
                                              _state = 0;
                                              if (_state == 0) {
                                                animateButton();
                                              }
                                              final boxdata = boxData(
                                                  nameBox:
                                                      "box_setLoginCredential");

                                              String userId = await boxdata
                                                  .getLoginCredential(
                                                      param: "userId");
                                              TaskNetwork objTaskNetwork =
                                                  TaskNetwork();
                                              Connection objCekConnection =
                                                  Connection();
                                              Network cekKoneksi =
                                                  await objCekConnection
                                                      .CheckConnection();
                                              if (cekKoneksi.Status) {
                                                late int dataTaskId;
                                                if (widget.Task["id"]
                                                        .runtimeType ==
                                                    String) {
                                                  print("data string");
                                                  dataTaskId = int.parse(
                                                      widget.Task["id"]);
                                                }
                                                if (widget.Task["id"]
                                                        .runtimeType ==
                                                    int) {
                                                  print("data integer 4");
                                                  dataTaskId =
                                                      widget.Task["id"];
                                                }

                                                Network objNetwork =
                                                    await objTaskNetwork
                                                        .getTaskAccept(
                                                            TaskId: dataTaskId);
                                                if (objNetwork.Status) {
                                                  //TODO: simpan data task, detail task, form worksheet, value worksheet edited 16092022

                                                  //add task
                                                  var addTask = boxData(
                                                      nameBox:
                                                          'box_listPekerjaan');
                                                  await addTask.addListTask(
                                                      userid: userId,
                                                      taskid: widget.Task['id']
                                                          .toString(),
                                                      statusTask: "OnGoing",
                                                      values: Map<String,
                                                              dynamic>.from(
                                                          widget.Task));

                                                  //add task detail
                                                  var boxAdddetail = Hive.box(
                                                      "box_detailPekerjaan");
                                                  await boxAdddetail.put(
                                                    widget.Task['id']
                                                        .toString(),
                                                    widget.objDataTask,
                                                  );
                                                  // add form
                                                  var boxAddform = Hive.box(
                                                      "box_worksheetform");
                                                  boxAddform.put(
                                                      widget.Task['id']
                                                          .toString(),
                                                      dataFormPure);
                                                  // add value form default
                                                  var addValueServer = boxData(
                                                      nameBox:
                                                          'box_valworksheet');
                                                  await addValueServer
                                                      .addValueWorksheet(
                                                          valServer:
                                                              dataValueBox,
                                                          userid: userId,
                                                          taskid: widget
                                                              .Task['id']
                                                              .toString(),
                                                          handoff: widget.Task[
                                                                  'handoff'] ??
                                                              false);

                                                  //close tag
                                                  //TODO:roots setelah terima task
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    HomeScreen(
                                                                        1),
                                                          ),
                                                          (route) => false);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskDetail(
                                                              widget.Task,
                                                              "OnGoing",
                                                              widget.Task[
                                                                  'status_worksheet'],
                                                              0),
                                                    ),
                                                  );
                                                  String btnname = "";
                                                  print(
                                                      "widget.Task['status_worksheet']");
                                                  print(widget.Task[
                                                      'status_worksheet']);
                                                  if (widget.Task[
                                                          'status_worksheet'] ==
                                                      '2') {
                                                    btnname = 'Fixing';
                                                  }
                                                  int tabBar = 1;

                                                  final fillData = {
                                                    "tabBar": tabBar,
                                                    "pause": "aktif",
                                                    "btnname": btnname,
                                                    "page2": int.parse(
                                                        widget.Task[
                                                            'status_worksheet'])
                                                  };

                                                  final objBox = boxData(
                                                      nameBox:
                                                          'box_workSheetSetting');

                                                  objBox
                                                      .addDataSettingFormWorksheet(
                                                          userId,
                                                          widget.Task["id"]
                                                              .toString(),
                                                          fillData);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangeNotifierProvider<
                                                                  TabNotifier>(
                                                              create: (context) =>
                                                                  TabNotifier(
                                                                      widget
                                                                          .Task),
                                                              child: Builder(builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return TaskWorksheetMenu(
                                                                    widget.Task,
                                                                    widget
                                                                        .objDataTask,
                                                                    1,
                                                                    "OnGoing",
                                                                    widget.Task[
                                                                        'status_worksheet']);
                                                              })),
                                                    ),
                                                  );

                                                  //TODO: akhir roots
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                } else {
                                                  //Todo Delete Notif
                                                  final boxlistNotif = boxData(
                                                      nameBox:
                                                          "box_listMessages");
                                                  boxlistNotif.deleteNotif(
                                                      taskid: widget.Task['id']
                                                          .toString(),
                                                      userid: userId);
                                                  //
                                                  final notifApi =
                                                      NotificationApi();
                                                  bool cekDrain = await notifApi
                                                      .drainStream(
                                                          "from worksheet page, condition task status Open and will be taken ");
                                                  if (cekDrain) {
                                                    _state = 0;
                                                    if (_state == 0) {
                                                      animateButton();
                                                    }
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      HomeScreen(
                                                                          0),
                                                            ),
                                                            (route) => false);
                                                    // Navigator.pushReplacement(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         HomeScreen(0),
                                                    //   ),
                                                    // );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                objNetwork
                                                                        .Message ??
                                                                    "")));
                                                  } else {
                                                    print("drain gagal");
                                                  }
                                                }

                                                //kalo pekerjaan udah di ambil

                                                //
                                              } else {}
                                            },
                                            child: setUpButtonChild()),
                                      ]),
                                ))
                              : Container())
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: AppTheme.warnaHijau,
                  ))),
      );
    });
  }

  Future _getStopTime() async {
    TaskNetwork objTaskNetwork = TaskNetwork();
    Network objNetwork =
        await objTaskNetwork.stopTimeSheet(TaskId: widget.Task["id"]);
  }

  Future<void> _imgFromCamera(
      dynamic data, String userid, String taskid) async {
    File image = File("");
    final pickedFile =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 20);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      valuess[data.name] = image;
      _image = image;
      _imageSelect = image;
      await _saveImageToDB(image, data.name);
    }
  }

  Future<void> _imgFromGallery(
      dynamic data, String userid, String taskid) async {
    try {
      print("pick");
      File image = File("");
      final pickedFile =
          await _picker.getImage(source: ImageSource.gallery, imageQuality: 20);
      print(pickedFile);
      if (pickedFile != null) {
        print("dapat");
        image = File(pickedFile.path);
        _image = image;
        _imageSelect = image;
        valuess[data.name] = image;
        await _saveImageToDB(image, data.name);
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak mendapatkan aksess file')));
      }
      print(image);
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  //TODO: Mengubah file dari base64 ke file image

  _showPicker(context, dynamic data, String taskid, String userid) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext bc) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    // ListTile(
                    //     leading: Icon(Icons.photo_library),
                    //     title: Text('Photo Library',
                    //         style: AppTheme.OpenSans400(14, Color(0xFF333333))),
                    //     onTap: () {
                    //       _imgFromGallery(data, userid, taskid);
                    //       Navigator.of(context).pop();
                    //     }),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Camera',
                          style: AppTheme.OpenSans400(14, Color(0xFF333333))),
                      onTap: () {
                        _imgFromCamera(data, userid, taskid);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _onSearchChanged(
      {String? query, int dataNumber = 0, String? label, int? taskid}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      // do something with query
      if (query != null) {
        dataValueBox[label] = query;
      }
      if (dataNumber != 0) {
        dataValueBox[label] = dataNumber;
      } else {
        // print("datanumber =0");
      }
      var objBox = boxData(nameBox: 'box_valworksheet');
      objBox.updateValueWorksheet(
          value: dataValueBox, taskid: taskid.toString());
    });
  }

  _saveImageToDB(File image, key) async {
    Uint8List bytes;
    String base64Encode = "";
    print("image view");
    print(image);
    if (image.path.toString() != "") {
      bytes = image.readAsBytesSync();
      base64Encode = base64.encode(bytes);
      dataValueBox[key] = base64Encode;
    } else {
      dataValueBox[key] = "";
    }

//save to db lokal
    var objBox = boxData(nameBox: 'box_valworksheet');
    objBox.updateValueWorksheet(
        value: dataValueBox, taskid: Task['id'].toString());

//
  }

  WorkSheetArray(dynamic entitlement) {
    // modified by adip

    List<Widget> lstWidget = [];

    if (entitlement is List<dynamic>) {
      List<Widget> tmpWidget = WorkSheetArray(entitlement);
      for (var objData in tmpWidget) {
        lstWidget.add(objData);
      }
    } else {
      if (entitlement.page == page1 || entitlement.page == page2) {
        if (entitlement.header == true) {
          lstWidget.add(Text(
            entitlement.text,
            style: AppTheme.OpenSans700(15, const Color(0xFF333333)),
          ));

          lstWidget.add(const SizedBox(
            height: 9,
          ));

          lstWidget.add(Text(valuess[entitlement.name].toString()));
          lstWidget.add(const SizedBox(
            height: 15,
          ));
          return lstWidget;
        } else {
          if (entitlement.type == "field") {
            if (entitlement.text != null &&
                entitlement.input != "many2one" &&
                entitlement.input != "boolean") {
              ///field mandatory
              if (entitlement.name == 'x_studio_before' ||
                  entitlement.name == 'x_studio_kerusakan' ||
                  entitlement.name == 'x_studio_after' ||
                  entitlement.name == 'x_studio_foto_unit_1' ||
                  entitlement.name == 'x_studio_tegangan' ||
                  entitlement.name == 'x_studio_pic_' ||
                  entitlement.name == 'x_studio_tipe_kompresor_1' ||
                  entitlement.name == 'x_studio_foto_sekitar_cold_storage_1' ||
                  entitlement.name == 'x_studio_foto_sekitar_cold_storage_2' ||
                  entitlement.name == 'x_studio_foto_ruang_anteroom' ||
                  entitlement.name == 'x_studio_foto_ruang_genset' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_1' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_2' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_3' ||
                  entitlement.name == 'x_studio_foto_ruang_mesin' ||
                  entitlement.name ==
                      'x_studio_foto_sekitar_cold_storage_1_after' ||
                  entitlement.name ==
                      'x_studio_foto_sekitar_cold_storage_2_after' ||
                  entitlement.name == 'x_studio_foto_ruang_anteroom_after' ||
                  entitlement.name == 'x_studio_foto_ruang_genset_after' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_1_after' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_2_after' ||
                  entitlement.name == 'x_studio_foto_lorong_freezer_3_after' ||
                  entitlement.name == 'x_studio_foto_ruang_mesin_after' ||
                  entitlement.name == 'x_studio_hasil_akhir_analisa_') {
                lstWidget.add(Row(
                  children: [
                    // Text(entitlement.text.replaceAll(':', '')),
                    //TODO label judul
                    Text(
                      entitlement.text,
                      style: AppTheme.OpenSans700(15, Color(0xFF333333)),
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                    // Text(
                    //   ' :',
                    //   style: TextStyle(),
                    // ),
                  ],
                ));
              } else {
                //TODO label judul
                lstWidget.add(Text(
                  entitlement.text,
                  style: AppTheme.OpenSans700(15, Color(0xFF333333)),
                ));
              }

              lstWidget.add(SizedBox(
                height: 9,
              ));

              if (entitlement.input == "char") {
                //TODO edited 15092022 UAT in PIT request scan barcode

                //
                if (entitlement.name == "x_studio_saran" ||
                    entitlement.name == "x_studio_alamat_" ||
                    entitlement.name == "x_studio_hasil_akhir_analisa_" ||
                    entitlement.text.toLowerCase() == "saran") {
                  lstWidget.add(TextFormField(
                    controller: valuess[entitlement.name],

                    enabled: fillField, // untuk disable field

                    onChanged: (data) async {
                      if (Task['id'].runtimeType == String) {
                        await _onSearchChanged(
                            query: data,
                            label: entitlement.name,
                            taskid: int.parse(Task['id']));
                      } else {
                        await _onSearchChanged(
                            query: data,
                            label: entitlement.name,
                            taskid: Task['id']);
                      }
                    },
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                        color: Color(0xFF2C2948)),
                    maxLines: 4,
                    // max baris

                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10),
                      hintText:
                          'Masukan ${entitlement.text}'.replaceAll(":", ""),
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'OpenSans',
                          color: fillField ? Colors.black : Colors.grey,
                          fontSize: 15),
                      focusColor: Colors.white70,
                    ),
                  ));
                  lstWidget.add(const SizedBox(
                    height: 17,
                  ));
                  return lstWidget;
                } else {
                  if (entitlement.name == "x_studio_tipe_kompresor_1") {
                    lstWidget.add(TextFormField(
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      textCapitalization: TextCapitalization.characters,

                      controller: valuess[entitlement.name],
                      validator: (value) {
                        if (entitlement.name == "x_studio_tegangan") {
                          if (value == null || value.isEmpty) {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //     content:
                            //         Text("lengkapi data ${entitlement.name}")));
                            return 'harap lengkapi data  ${entitlement.text}';
                          }
                          return null;
                        }
                        return null;
                      },
                      enabled: fillField,
                      // untuk disable field
                      // onEditingComplete: () {
                      //   print((valuess[entitlement.name]).text);
                      //   FocusScope.of(context).unfocus();
                      // },
                      onChanged: (data) async {
                        if (Task['id'].runtimeType == String) {
                          await _onSearchChanged(
                              query: data.toUpperCase(),
                              label: entitlement.name,
                              taskid: int.parse(Task['id']));
                        }
                        {
                          await _onSearchChanged(
                              query: data,
                              label: entitlement.name,
                              taskid: Task['id']);
                        }

                        // await _onSearchChanged(
                        //     data, entitlement.name, Task['id']);
                      },
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                          color: fillField ? Color(0xFF2C2948) : Colors.grey),
                      maxLines: 1,
                      // max baris

                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 20.0, right: 20.0),
                        hintText:
                            'Masukan ${entitlement.text}'.replaceAll(":", ""),
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'OpenSans',
                            color: fillField ? Colors.black : Colors.grey,
                            fontSize: 15),
                        focusColor: Colors.white70,
                      ),
                    ));
                    lstWidget.add(const SizedBox(
                      height: 17,
                    ));
                    return lstWidget;
                  } else if (entitlement.name ==
                          "x_studio_no_seri_pengganti_1" ||
                      entitlement.name == "x_studio_no_registrasi_sementara_") {
                    lstWidget.add(
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                              ],
                              textCapitalization: TextCapitalization.characters,

                              controller: valuess[entitlement.name],
                              // validator: (value) {
                              //   if (entitlement.name == "x_studio_tegangan") {
                              //     if (value == null || value.isEmpty) {
                              //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //       //     content:
                              //       //         Text("lengkapi data ${entitlement.name}")));
                              //       return 'harap lengkapi data  ${entitlement.text}';
                              //     }
                              //     return null;
                              //   }
                              // },
                              enabled: fillField,
                              // untuk disable field
                              // onEditingComplete: () {
                              //   print((valuess[entitlement.name]).text);
                              //   FocusScope.of(context).unfocus();
                              // },
                              onChanged: (data) async {
                                if (Task['id'].runtimeType == String) {
                                  await _onSearchChanged(
                                      query: data.toUpperCase(),
                                      label: entitlement.name,
                                      taskid: int.parse(Task['id']));
                                }
                                {
                                  await _onSearchChanged(
                                      query: data,
                                      label: entitlement.name,
                                      taskid: Task['id']);
                                }

                                // await _onSearchChanged(
                                //     data, entitlement.name, Task['id']);
                              },
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'OpenSans',
                                  color: fillField
                                      ? Color(0xFF2C2948)
                                      : Colors.grey),
                              maxLines: 1,
                              // max baris

                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                hintText: 'Masukan ${entitlement.text}'
                                    .replaceAll(":", ""),
                                hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'OpenSans',
                                    color:
                                        fillField ? Colors.black : Colors.grey,
                                    fontSize: 15),
                                focusColor: Colors.white70,
                              ),
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            onPressed: () async {
                              if (fillField) {
                                dynamic data = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const QRViewExample(),
                                ));
                                print("data dari qr");
                                print(data);
                                // valuess[entitlement.name] = data;
                                int taskid;
                                // if (widget.Task['id'].runtimeType == String) {
                                //   taskid = int.parse(widget.Task['id']);
                                // } else {
                                //   taskid = widget.Task['id'];
                                // }
                                if (data != null) {
                                  setState(() {
                                    valuess[entitlement.name] =
                                        TextEditingController(text: data);
                                    dataValueBox[entitlement.name] = data;
                                    var objBox =
                                        boxData(nameBox: 'box_valworksheet');
                                    objBox.updateValueWorksheet(
                                        value: dataValueBox,
                                        taskid: Task['id'].toString());
                                  });
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.flip,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                    lstWidget.add(const SizedBox(
                      height: 17,
                    ));
                    return lstWidget;
                  } else {
                    lstWidget.add(TextFormField(
                      // textCapitalization:
                      //     entitlement.name == "x_studio_no_seri_" ||
                      //             entitlement.name == "x_studio_tipe_kompresor_1"
                      //         ? TextCapitalization.characters
                      //         : TextCapitalization.none,
                      controller: valuess[entitlement.name],
                      validator: (value) {
                        if (entitlement.name == "x_studio_tegangan") {
                          if (value == null || value.isEmpty) {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //     content:
                            //         Text("lengkapi data ${entitlement.name}")));
                            return 'harap lengkapi data  ${entitlement.text}';
                          }
                          return null;
                        }
                        return null;
                      },
                      enabled: fillField,
                      // untuk disable field
                      // onEditingComplete: () {
                      //   print((valuess[entitlement.name]).text);
                      //   FocusScope.of(context).unfocus();
                      // },
                      onChanged: (data) async {
                        if (Task['id'].runtimeType == String) {
                          await _onSearchChanged(
                              query: data,
                              label: entitlement.name,
                              taskid: int.parse(Task['id']));
                        } else {
                          await _onSearchChanged(
                              query: data,
                              label: entitlement.name,
                              taskid: Task['id']);
                        }
                      },
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                          color: fillField ? Color(0xFF2C2948) : Colors.grey),
                      maxLines: 1,
                      // max baris

                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding:
                            EdgeInsets.only(left: 20.0, right: 20.0),
                        hintText:
                            'Masukan ${entitlement.text}'.replaceAll(":", ""),
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'OpenSans',
                            color: fillField ? Colors.black : Colors.grey,
                            fontSize: 15),
                        focusColor: Colors.white70,
                      ),
                    ));
                    lstWidget.add(const SizedBox(
                      height: 17,
                    ));
                    return lstWidget;
                  }

                  // lstWidget.add(SizedBox(
                  //   height: 17,
                  // ));
                  // return lstWidget;
                }

                // index++;
              } else if (entitlement.input == "float" ||
                  entitlement.input == "decimal" ||
                  entitlement.input == "integer") {
                lstWidget.add(TextFormField(
                  enabled: fillField,
                  controller: valuess[entitlement.name],
                  keyboardType: TextInputType.number,
                  onChanged: (data) async {
                    if (Task['id'].runtimeType == String) {
                      await _onSearchChanged(
                          dataNumber: int.parse(data),
                          label: entitlement.name,
                          taskid: int.parse(Task['id']));
                    } else {
                      await _onSearchChanged(
                          dataNumber: int.parse(data),
                          label: entitlement.name,
                          taskid: Task['id']);
                    }

                    // await _onSearchChanged(data, entitlement.name, Task['id']);
                    // var box_AddWorksheetForm = await Hive.box("box_valworksheet");
                    // box_AddWorksheetForm.put(entitlement.name, data);
                    // print(data);
                  },
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'OpenSans',
                      color: Color(0xFF2C2948)),
                  maxLines: 1,
                  // max baris

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    hintText: 'Masukan ${entitlement.text}'.replaceAll(":", ""),
                    hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'OpenSans',
                        fontSize: 15),
                    focusColor: Colors.white70,
                  ),

                  // validator: (value) {
                  //   return null;
                  // },
                ));
                lstWidget.add(SizedBox(
                  height: 17,
                ));
                return lstWidget;
                // index++;
              } else if (entitlement.input == "date") {
                lstWidget.add(MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(1.0)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * MySize.scaleFactorWidth,
                        vertical: 2 * MySize.scaleFactorHeight),
                    child: TextFormField(
                      style: TextStyle(
                          color: fillField ? Colors.black : Colors.grey),
                      enabled: fillField,
                      // controller: dataArr[entitlement.text],
                      controller: valuess[entitlement.name],
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        // hintStyle: TextStyle(
                        //     color: fillField ? Colors.black : Colors.grey),
                        // hintText:
                        //     DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Masukan data yang sesuai';
                      //   }
                      //   return null;
                      // },
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          // dataArr[entitlement.text].text =
                          valuess[entitlement.name].text =
                              DateFormat('dd/MM/yyyy').format(date);
                        }, onConfirm: (date) {
                          //saving data to db lokal
                          dataValueBox[entitlement.name] =
                              DateFormat('yyyy-MM-dd').format(date);
                          var objBox = boxData(nameBox: 'box_valworksheet');
                          objBox.updateValueWorksheet(
                              value: dataValueBox,
                              taskid: Task['id'].toString());

                          valuess[entitlement.name].text =
                              DateFormat('dd/MM/yyyy').format(date);
                        }, currentTime: DateTime.now(), locale: LocaleType.id);
                      },
                      onChanged: (value) {
                        // dataArr[entitlement.text].text = value;
                        valuess[entitlement.name].text = value;
                      },
                    ),
                  ),
                ));
                lstWidget.add(SizedBox(
                  height: 9,
                ));
                return lstWidget;
              } else if (entitlement.input == "datetime") {
                lstWidget.add(Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2 * MySize.scaleFactorWidth,
                      vertical: 2 * MySize.scaleFactorHeight),
                  child: TextFormField(
                    enabled: fillField,
                    // controller: dataArr[entitlement.text],
                    controller: valuess[entitlement.name],
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.2), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      // hintText: DateFormat('yyyy-MM-dd HH:mm:ss')
                      //     .format(DateTime.now()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Masukan data yang sesuai';
                    //   }
                    //   return null;
                    // },
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // DatePicker.showDateTimePicker(context,
                      //     showTitleActions: true,
                      //     theme: DatePickerTheme(
                      //       backgroundColor: Colors.white,
                      //       itemStyle: TextStyle(fontSize: 12),
                      //       cancelStyle: TextStyle(
                      //           fontSize: 14,
                      //           color: Color(0xFF008199).withOpacity(1.0)),
                      //       doneStyle: TextStyle(
                      //           fontSize: 14,
                      //           color: Color(0xFF008199).withOpacity(1.0)),
                      //     ), onChanged: (date) {
                      //   // dataArr[entitlement.text].text =
                      //   valuess[entitlement.name].text =
                      //       DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                      // }, onConfirm: (date) {
                      //   dataValueBox[entitlement.name] =
                      //       DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                      //
                      //   var objBox = boxData(nameBox: 'box_valworksheet');
                      //   objBox.updateValueWorksheet(
                      //       value: dataValueBox, taskid: Task['id'].toString());
                      //
                      //   valuess[entitlement.name].text =
                      //       DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                      // }, currentTime: DateTime.now(), locale: LocaleType.id);

                      // kalo viewnya mau tanggal aja dan waktunya waktu terkini, ini aktifkan
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        // dataArr[entitlement.text].text =
                        // valuess[entitlement.name].text =
                        //     DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                        valuess[entitlement.name].text =
                            DateFormat('dd-MM-yyyy').format(date);
                      }, onConfirm: (date) {
                        dataValueBox[entitlement.name] =
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

                        var objBox = boxData(nameBox: 'box_valworksheet');
                        objBox.updateValueWorksheet(
                            value: dataValueBox, taskid: Task['id'].toString());

                        valuess[entitlement.name].text =
                            DateFormat('dd-MM-yyyy').format(date);
                      }, currentTime: DateTime.now(), locale: LocaleType.id);
                    },
                    onChanged: (value) {
                      // dataArr[entitlement.text].text = value;
                      valuess[entitlement.name].text = value;
                    },
                  ),
                ));
                lstWidget.add(SizedBox(
                  height: 9,
                ));
                return lstWidget;
              }
              // else if (entitlement.input == "char" ||
              else if (entitlement.input == "text") {
                lstWidget.add(TextFormField(
                  enabled: fillField,
                  controller: valuess[entitlement.name],
                  onChanged: (data) async {
                    if (Task['id'].runtimeType == String) {
                      await _onSearchChanged(
                          query: data,
                          label: entitlement.name,
                          taskid: int.parse(Task['id']));
                    } else {
                      await _onSearchChanged(
                          query: data,
                          label: entitlement.name,
                          taskid: Task['id']);
                    }

                    // await _tesonSearchChanged(data, entitlement.name, Task['id']);
                  },
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'OpenSans',
                      color: Color(0xFF2C2948)),
                  maxLines: 3,
                  // max baris

                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.2), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 3.0),
                    hintText: 'Masukan ${entitlement.text}'.replaceAll(":", ""),
                    hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: 'OpenSans',
                        color: fillField ? Colors.black : Colors.grey,
                        fontSize: 15),
                    focusColor: Colors.white70,
                  ),

                  // validator: (value) {
                  //   return null;
                  // },
                ));
                lstWidget.add(SizedBox(
                  height: 20,
                ));
                return lstWidget;
              } else if (entitlement.input == "binary") {
                if (entitlement.page == 2) {
                  if (entitlement.name == "x_studio_after" ||
                      entitlement.name ==
                          "x_studio_foto_sekitar_cold_storage_1_after" ||
                      entitlement.name ==
                          "x_studio_foto_sekitar_cold_storage_2_after" ||
                      entitlement.name ==
                          "x_studio_foto_ruang_anteroom_after" ||
                      entitlement.name == "x_studio_foto_ruang_genset_after" ||
                      entitlement.name ==
                          "x_studio_foto_lorong_freezer_1_after" ||
                      entitlement.name ==
                          "x_studio_foto_lorong_freezer_2_after" ||
                      entitlement.name ==
                          "x_studio_foto_lorong_freezer_3_after" ||
                      entitlement.name == "x_studio_foto_ruang_mesin_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_1_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_2_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_3_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_4_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_5_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_6_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_7_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_8_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_9_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_10_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_11_after" ||
                      entitlement.name ==
                          "x_studio_foto_cold_storage_lainnya_12_after") {
                    lstWidget.add(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MySize.getScaledSizeWidth(79),
                          height: MySize.getScaledSizeHeight(79),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: dataValueBox[entitlement.name] != "" &&
                                    valuess[entitlement.name].path.toString() !=
                                        ""
                                ? DecorationImage(
                                    image: FileImage(valuess[entitlement.name]),
                                    fit: BoxFit.fill)
                                : DecorationImage(
                                    image: AssetImage(
                                        "./assets/images/add_photo.png"),
                                    fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        fillField
                            ? Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (fillField) {
                                          final boxdata = boxData(
                                              nameBox:
                                                  "box_setLoginCredential");
                                          var userid =
                                              await boxdata.getLoginCredential(
                                                  param: "userId");
                                          _showPicker(context, entitlement,
                                              Task['id'].toString(), userid);
                                        } else {
                                          // alert(entitlement.text);
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        color: AppTheme.warnaHijau,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final boxdata = boxData(
                                            nameBox: "box_setLoginCredential");
                                        var userid =
                                            await boxdata.getLoginCredential(
                                                param: "userId");
                                        try {
                                          String dir =
                                              (await getApplicationDocumentsDirectory())
                                                  .path;
                                          File file = File("$dir/" +
                                              userid +
                                              Task['id'].toString() +
                                              entitlement.text +
                                              ".png");
                                          // var hasil =
                                          //     await file.delete();
                                          // print(file.existsSync());
                                          file.deleteSync(recursive: true);
                                          print(" delete success");
                                          // print(hasil);
                                          print(valuess[entitlement.name]);
                                          valuess[entitlement.name] = File("");
                                          await _saveImageToDB(
                                              File(""), entitlement.name);
                                          //delete di db lokal

                                          // dataValueBox[entitlement.name] = "";
                                          // var box_AddWorksheetForm =
                                          //     await Hive.box(
                                          //         "box_valworksheet");
                                          //
                                          // // print(label);
                                          // // print(data);
                                          // // print(data[label]);
                                          // box_AddWorksheetForm.put(
                                          //     Task['id'].toString(),
                                          //     dataValueBox);

                                          //
                                          setState(() {});
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        color: Color(0xFFdc6a66),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ));
                    return lstWidget;
                  } else {
                    lstWidget.add(InkWell(
                        onTap: () async {
                          if (fillField) {
                            var data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignaturePage(),
                              ),
                            );
                            if (data != null) {
                              await _saveImageToDB(data, entitlement.name);
                              valuess[entitlement.name] = data;
                            }
                            setState(() {});
                          } else {
                            // alert(entitlement.text);
                          }
                        },
                        child:
                            // Image(image: FileImage(valuess[entitlement.name]))

                            (valuess[entitlement.name]).path == ""
                                ? Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    )),
                                    child: Center(
                                      child: Text("Signature"),
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        )),
                                    child: Image.file(
                                        valuess[entitlement.name]))));
                    lstWidget.add(SizedBox(
                      height: 15,
                    ));
                    return lstWidget;
                  }
                } else {
                  if (entitlement.name == "x_studio_teknisi_checking_1" ||
                      entitlement.name == "x_studio_teknisi_checking" ||
                      entitlement.name == "x_studio_teknisi" ||
                      entitlement.name == "x_studio_customer" ||
                      entitlement.name == "x_studio_customer_checking") {
                    lstWidget.add(InkWell(
                        onTap: () async {
                          if (fillField) {
                            var data = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignaturePage(),
                              ),
                            );
                            if (data != null) {
                              await _saveImageToDB(data, entitlement.name);
                              valuess[entitlement.name] = data;
                            }
                            setState(() {});
                          } else {
                            // alert(entitlement.text);
                          }
                        },
                        child:
                            // Image(image: FileImage(valuess[entitlement.name]))

                            (valuess[entitlement.name]).path == ""
                                ? Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    )),
                                    child: Center(
                                      child: Text("Signature"),
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        )),
                                    child: Image.file(
                                        valuess[entitlement.name]))));
                    lstWidget.add(SizedBox(
                      height: 15,
                    ));
                    return lstWidget;
                  } else {
                    lstWidget.add(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Container(
                            width: MySize.getScaledSizeWidth(79),
                            height: MySize.getScaledSizeHeight(79),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: (dataValueBox[entitlement.name] != "" &&
                                      valuess[entitlement.name]
                                              .path
                                              .toString() !=
                                          ""
                                  ? DecorationImage(
                                      image:
                                          FileImage(valuess[entitlement.name]),
                                      fit: BoxFit.fill)
                                  : DecorationImage(
                                      image: AssetImage(
                                          "./assets/images/add_photo.png"),
                                      fit: BoxFit.contain)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        fillField
                            ? Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (fillField) {
                                          final boxdata = boxData(
                                              nameBox:
                                                  "box_setLoginCredential");
                                          var userid =
                                              await boxdata.getLoginCredential(
                                                  param: "userId");
                                          _showPicker(context, entitlement,
                                              userid, Task['id'].toString());
                                        } else {
                                          // alert(entitlement.text);
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        color: AppTheme.warnaHijau,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          FileSystemEntity hasil =
                                              await valuess[entitlement.name]
                                                  .delete();
                                          print(" delete success");
                                          print(hasil);
                                          valuess[entitlement.name] = File("");
                                          await _saveImageToDB(
                                              File(""), entitlement.name);
                                          setState(() {});
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        color: Color(0xFFdc6a66),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ));
                    return lstWidget;
                  }
                }
              } else if (entitlement.input == "selection") {
                // String data = "";
                if (entitlement.name == "x_studio_lokasi_unit_") {
                  List<String> data = [
                    entitlement.data[0]['value'],
                    entitlement.data[1]['value']
                  ];
                  // print("lokasi unit");
                  // print(valuess[entitlement.name]);
                  if (dataValueBox[entitlement.name] == false) {
                    valuess[entitlement.name] = [
                      entitlement.data[0]['value'],
                      dataValueBox[entitlement.name]
                    ];
                    dataValueBox[entitlement.name] =
                        entitlement.data[0]['value'];
                  }

                  // lstWidget.add(Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: ListTile(
                  //         title: Text('${data[0]}'),
                  //         leading: Radio(
                  //           value: data[0],
                  //           groupValue: valuess[entitlement.name][0],
                  //           onChanged: (value) async {
                  //             valuess[entitlement.name] = [value, value];
                  //             dataValueBox[entitlement.name] = value;
                  //             setState(() {});
                  //
                  //             var objBox = boxData(nameBox: 'box_valworksheet');
                  //             objBox.updateValueWorksheet(
                  //                 value: dataValueBox,
                  //                 taskid: Task['id'].toString());
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListTile(
                  //         title: Text('${data[1]}'),
                  //         leading: Radio(
                  //           value: data[1],
                  //           groupValue: valuess[entitlement.name][1],
                  //           onChanged: (value) async {
                  //             valuess[entitlement.name] = [value, value];
                  //             dataValueBox[entitlement.name] = value;
                  //             setState(() {});
                  //             var objBox = boxData(nameBox: 'box_valworksheet');
                  //             objBox.updateValueWorksheet(
                  //                 value: dataValueBox,
                  //                 taskid: Task['id'].toString());
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ));
                  lstWidget.add(InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          gapPadding: 1.0,
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                              color: fillField
                                  ? const Color(0xFF27394E).withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              width: MySize.getScaledSizeWidth(1))),
                    ),
                    child: SizedBox(
                      height: MySize.getScaledSizeHeight(22),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: valuess[entitlement.name][0],
                          style: (fillField
                              ? AppTheme.OpenSans400(17, Color(0xFF333333))
                              : AppTheme.OpenSans400(17, Colors.grey)),
                          items: data
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    textScaler: TextScaler.linear(1.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    value == valuess[entitlement.name]
                                        ? SizedBox(
                                            width:
                                                MySize.getScaledSizeWidth(20),
                                            child: Icon(
                                              Icons.radio_button_checked,
                                              size: 20,
                                              color: Color(0xFF008199),
                                            ),
                                          )
                                        : SizedBox(
                                            width:
                                                MySize.getScaledSizeWidth(20),
                                            child: Icon(
                                              Icons.radio_button_off,
                                              size: 20,
                                              color: Color(0xFF008199),
                                            ),
                                          ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10 * MySize.scaleFactorWidth),
                                      child: Text(
                                        value,
                                        style: AppTheme.OpenSans400(
                                            17, Color(0xFF333333)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: fillField
                              ? ((String? value) {
                                  print(
                                      "value selected from dropdown lokasi unit");
                                  print(value);
                                  setState(() {
                                    valuess[entitlement.name] = [value, value];
                                    dataValueBox[entitlement.name] = value;
                                    var objBox =
                                        boxData(nameBox: 'box_valworksheet');
                                    objBox.updateValueWorksheet(
                                        value: dataValueBox,
                                        taskid: Task['id'].toString());
                                  });
                                })
                              : null,
                          selectedItemBuilder: (BuildContext context) {
                            return data.map<Widget>((String item) {
                              return FittedBox(
                                  child: Text(item,
                                      style: TextStyle(
                                          color: fillField
                                              ? Colors.black
                                              : Colors.grey,
                                          fontFamily: 'OpenSans',
                                          fontSize: 15)));
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ));

                  // lstWidget.add(IgnorePointer(
                  //                 ignoring: !fillField,
                  //                 child: FittedBox(
                  //                   child: CustomRadioButton(
                  //                     selectedBorderColor: AppTheme.warnaHijau,
                  //                     unSelectedBorderColor:
                  //                         Color(0xFF27394E).withOpacity(0.2),
                  //                     buttonLables: data,
                  //                     buttonValues: data,
                  //
                  //                     width: MySize.getScaledSizeWidth(150), //0.365
                  //                     height: MySize.getScaledSizeHeight(65),
                  //                     spacing: 8,
                  //                     padding: 2.1,
                  //                     margin: EdgeInsets.only(
                  //                         left: 0.1 * MySize.scaleFactorWidth,
                  //                         right: 0.1 * MySize.scaleFactorWidth,
                  //                         top: 10 * MySize.scaleFactorHeight,
                  //                         bottom: 10 * MySize.scaleFactorHeight),
                  //                     defaultSelected: valuess[entitlement.name][0],
                  //                     wrapAlignment: WrapAlignment.center,
                  //                     enableButtonWrap: true,
                  //                     radioButtonValue: (value) {
                  //                       // strType = value.toString();
                  //
                  //                       valuess[entitlement.name] = [value, value];
                  //                       dataValueBox[entitlement.name] = value;
                  //                       var objBox = boxData(nameBox: 'box_valworksheet');
                  //                       objBox.updateValueWorksheet(
                  //                           value: dataValueBox,
                  //                           taskid: Task['id'].toString());
                  //                     },
                  //                     enableShape: true,
                  //                     radius: 7,
                  //                     shapeRadius: 7,
                  //                     elevation: 0,
                  //                     buttonTextStyle: ButtonTextStyle(
                  //                       selectedColor: AppTheme.warnaHijau,
                  //                       unSelectedColor: Colors.black,
                  //                       textStyle:
                  //                           AppTheme.OpenSans400(17, AppTheme.warnaHijau),
                  //                     ),
                  //                     selectedColor: Colors.white,
                  //                     unSelectedColor: Colors.white,
                  //                   ),
                  //                 ),
                  //               ));
                } else {
                  lstWidget.add(InkWell(
                      onTap: () async {
                        if (fillField) {
                          var data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedItem(
                                  entitlement.data, entitlement.text),
                            ),
                          );
                          if (data != null) {
                            valuess[entitlement.name] = data;
                            dataValueBox[entitlement.name] = data[0];
                            var objBox = boxData(nameBox: 'box_valworksheet');
                            objBox.updateValueWorksheet(
                                value: dataValueBox,
                                taskid: Task['id'].toString());
                          }

                          setState(() {});
                        } else {
                          // alert(entitlement.text);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 29.0, right: 10.0, top: 17, bottom: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                valuess[entitlement.name].length != 0
                                    ? (valuess[entitlement.name][1]) ?? ""
                                    : "",
                                style: TextStyle(
                                    color:
                                        fillField ? Colors.black : Colors.grey,
                                    fontFamily: 'OpenSans',
                                    fontSize: 15)),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: fillField ? Colors.black : Colors.grey,
                              size: 15.0,
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Color(0xFF27394E).withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) //                 <--- border radius here
                              ),
                        ),
                      )));
                }

                lstWidget.add(SizedBox(
                  height: 17,
                ));
                return lstWidget;
                lstWidget.add(SizedBox(
                  height: 17,
                ));
                return lstWidget;
              }
            } else if (entitlement.input == "many2one" &&
                entitlement.text != null) {
              // val.add("ada");
              // String data = "";
              {
                // val.add("ada");
                // String data = "";
                print("entitleeee ${valuess[entitlement.name]}");
                if (entitlement.relation == 'product.product') {
                  // if (countPartDiganti < tresholdPartDiganti) {
                  // print("countPartDiganti");
                  // print(countPartDiganti);
                  lstWidget.add(InkWell(
                      onTap: () async {
                        if (fillField) {
                          var product = [];

                          var masterProduct =
                              await Hive.openBox("box_masterProduct");

                          if (entitlement.relation == 'product.product') {
                            if (masterProduct.isNotEmpty) {
                              product = masterProduct.get('product');
                            }
                          }
                          // use data

                          List<dynamic> data = [];

                          data = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectedItem(
                                      product, "Pilih part yang diganti"),
                                  // entitlement.text ?? "pilih part yang diganti"
                                ),
                              ) ??
                              [];

                          if (data.isNotEmpty) {
                            print('data product.product');
                            print(data);
                            valuess[entitlement.name] = data;
                            dataValueBox[entitlement.name] = data[0];
                            print(dataValueBox[entitlement.name]);

                            var objBox = boxData(nameBox: 'box_valworksheet');
                            objBox.updateValueWorksheet(
                                value: dataValueBox,
                                taskid: Task['id'].toString());
                          }

                          setState(() {});
                        } else {}
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 19.0, right: 10.0, top: 17, bottom: 17),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        valuess[entitlement.name].length != 0
                                            ? valuess[entitlement.name][1]
                                            : "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: fillField
                                                ? Colors.black
                                                : Colors.grey,
                                            fontFamily: 'OpenSans',
                                            fontSize: 15)),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color:
                                        fillField ? Colors.black : Colors.grey,
                                    size: 15.0,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: Color(0xFF27394E).withOpacity(0.2)),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        5.0) //                 <--- border radius here
                                    ),
                              ),
                            ),
                          ),
                        ],
                      )));
                  // if (countPartDiganti == tresholdPartDiganti - 1) {
                  //   lstWidget.add(SizedBox(
                  //     height: 5,
                  //   ));
                  //   lstWidget.add(Center(
                  //     child: IconButton(
                  //       icon: const Icon(
                  //         Icons.add_circle_outline,
                  //       ),
                  //       color: Colors.grey,
                  //       iconSize: 30,
                  //       onPressed: () async {
                  //         tresholdPartDiganti++;
                  //         await Provider.of<workSheetFormNotifier>(context,
                  //                 listen: false)
                  //             .updateList();
                  //         setState(() {});
                  //       },
                  //     ),
                  //   ));
                  //   lstWidget.add(SizedBox(
                  //     height: 5,
                  //   ));
                  // }
                  lstWidget.add(SizedBox(
                    height: 17,
                  ));

                  // countPartDiganti++;
                  return lstWidget;
                  // }
                } else {
                  // print("mampir la");
                  lstWidget.add(InkWell(
                      onTap: () async {
                        if (fillField) {
                          var garansi = [];

                          var masterGaransi =
                              await Hive.openBox("box_masterGaransi");
                          if (entitlement.relation == 'isd.warranty.term') {
                            if (masterGaransi.isNotEmpty) {
                              {
                                garansi = masterGaransi.get('garansi');
                              }
                            }
                          }
                          // use data
                          print("garansiiii ${garansi}");
                          List<dynamic> data = [];
                          if (entitlement.relation == 'isd.warranty.term') {
                            data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedItem(garansi, "Garansi"),
                                    // entitlement.text ?? "pilih part yang diganti"
                                  ),
                                ) ??
                                [];
                          }
                          // var data = await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         SelectedItem(option, "Pilih part yang diganti"),
                          //     // entitlement.text ?? "pilih part yang diganti"
                          //   ),
                          // );
                          if (data.isNotEmpty) {
                            print('data garansi');
                            print(data);
                            valuess[entitlement.name] = data;
                            dataValueBox[entitlement.name] = data[0];
                            print(dataValueBox[entitlement.name]);

                            var objBox = boxData(nameBox: 'box_valworksheet');
                            objBox.updateValueWorksheet(
                                value: dataValueBox,
                                taskid: Task['id'].toString());
                          }

                          setState(() {});
                        } else {
                          if (entitlement.relation == 'isd.warranty.term') {
                            // alert(entitlement.text);
                          } else {
                            // alert("Part");/
                          }
                        }
                      },
                      child: entitlement.name !=
                                  'x_studio_masa_garansi_servis' &&
                              entitlement.name !=
                                  'x_studio_masa_garansi_servis_'
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // ignore: prefer_const_constructors
                                    padding: EdgeInsets.only(
                                        left: 19.0,
                                        right: 10.0,
                                        top: 17,
                                        bottom: 17),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              valuess[entitlement.name]
                                                          .length !=
                                                      0
                                                  ? valuess[entitlement.name][1]
                                                  : "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: fillField
                                                      ? Colors.black
                                                      : Colors.grey,
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 15)),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: fillField
                                              ? Colors.black
                                              : Colors.grey,
                                          size: 15.0,
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: Color(0xFF27394E)
                                              .withOpacity(0.2)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      entitlement.text ?? "",
                                      style: AppTheme.OpenSans700(
                                          15, Color(0xFF333333)),
                                    ),
                                    // Text(
                                    //   '*',
                                    //   style: TextStyle(color: Colors.red),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 19.0,
                                      right: 10.0,
                                      top: 17,
                                      bottom: 17),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            valuess[entitlement.name] != null
                                                ? (valuess[entitlement.name]
                                                            .length !=
                                                        0
                                                    ? valuess[entitlement.name]
                                                        [1]
                                                    : "")
                                                : "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 15,
                                                color: fillField
                                                    ? Colors.black
                                                    : Colors.grey)),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: fillField
                                            ? Colors.black
                                            : Colors.grey,
                                        size: 15.0,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0,
                                        color:
                                            Color(0xFF27394E).withOpacity(0.2)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                  ),
                                ),
                              ],
                            )));
                  lstWidget.add(SizedBox(
                    height: 17,
                  ));
                  return lstWidget;
                }

                // lstWidget.add(SizedBox(
                //   height: 17,
                // ));
                // return lstWidget;
              }
            } else if (entitlement.input == "boolean") {
              // val.add("ada");
              lstWidget.add(Container(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    entitlement.text ?? "",
                    style: AppTheme.OpenSans700(15, Color(0xFF333333)),
                  ),
                  value: valuess[entitlement.name],
                  onChanged: fillField == true
                      ? (bool? value) {
                          dataValueBox[entitlement.name] = value;
                          var objBox = boxData(nameBox: 'box_valworksheet');
                          objBox.updateValueWorksheet(
                              value: dataValueBox,
                              taskid: Task['id'].toString());

                          valuess[entitlement.name] = value;
                          setState(() {});
                        }
                      : null,
                ),
              ));
              return lstWidget;
            }

            return lstWidget;
          } else if (entitlement.type == "group") {
            if (entitlement.text != null) {
              lstWidget.add(const SizedBox(
                height: 20,
              ));
              lstWidget.add(Text(
                entitlement.text,
                style: AppTheme.OpenSans700(17, const Color(0xFF333333)),
              ));
              lstWidget.add(const SizedBox(
                height: 10,
              ));
            }
            return lstWidget;
          } else {
            if (entitlement.type == "label") {
              lstWidget.add(Text(
                entitlement.text,
                style: AppTheme.OpenSans700(15, Color(0xFF333333)),
              ));
              lstWidget.add(SizedBox(
                height: 10,
              ));
            }

            return lstWidget;
          }
        }
      } else {
        return lstWidget;
      }
    }
    // }
    // );

    // return lstWidget;

    // TODO: implement build
    // return Container(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: lstWidget,
    //   ),
    // );
  }

// WorkSheetArrayData(dynamic objArray) {
//   List<clsWorkshop> lstClsWorkshop = [];
//
//   objArray.forEach((entitlement) {
//     // print("itung");
//     // itung++;
//     // print(itung);
//     // print(entitlement);
//     if (entitlement is List<dynamic>) {
//       print("list worksheet array");
//       List<clsWorkshop> tmpWidget = WorkSheetArrayData(entitlement);
//       tmpWidget.forEach((objData) {
//         lstClsWorkshop.add(objData);
//       });
//     } else if (entitlement.containsKey("child")) {
//       if (entitlement['child'] is List<dynamic>) {
//         List<clsWorkshop> tmpWidget =
//             WorkSheetArrayData(entitlement['child']);
//         tmpWidget.forEach((objData) {
//           lstClsWorkshop.add(objData);
//         });
//       }
//     } else {
//       clsWorkshop objClsWorkshop = clsWorkshop();
//
//       objClsWorkshop.type = entitlement["type"];
//       objClsWorkshop.name = entitlement["name"];
//       objClsWorkshop.text = entitlement["text"];
//       objClsWorkshop.input = entitlement["input"];
//       objClsWorkshop.data = entitlement["data"];
//       objClsWorkshop.relation = entitlement["relation"];
//       if (entitlement["text"] != null && dataArr.isEmpty) {
//         dataArr[entitlement["text"]] = TextEditingController();
//       }
//       lstClsWorkshop.add(objClsWorkshop);
//     }
//   });
//   // print("lstClsWorkshop.length");
//   // print(lstClsWorkshop.length);
//   return lstClsWorkshop;
// }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class clsWorkshop {
  dynamic type;
  dynamic name;
  dynamic text;
  dynamic input;
  List<dynamic> data = [];
  dynamic relation;
}

// class DetailWidget extends StatelessWidget {
//   String Title;
//   dynamic Value;
//
//   DetailWidget({required this.Title, required this.Value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             Title,
//             style: TextStyle(
//                 fontFamily: 'OpenSans', fontSize: 12, color: Colors.black),
//           ),
//           Text(
//             Value == false ? "" : Value.toString(),
//             style: TextStyle(
//                 fontFamily: 'OpenSans', fontSize: 15, color: Colors.black),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }
