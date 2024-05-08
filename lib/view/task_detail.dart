import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:pit/model/mNetwork.dart';

import 'package:pit/network/task.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/boxData.dart';
import 'package:pit/utils/notificationApi.dart';
import 'package:pit/utils/popUpError.dart';
import 'package:pit/view/homescreen.dart';

import 'package:pit/view/task_worksheet.dart';
import 'package:provider/provider.dart';

import '../network/CheckDataConnection.dart';
import '../network/worksheet.dart';
import '../notifier/tabNotifier.dart';

class TaskDetail extends StatelessWidget {
  dynamic Task; // task yg ada di listnya
  String statusTask;
  String dataStsWrkShtServer;
  int idMessage;

  TaskDetail(
      this.Task, this.statusTask, this.dataStsWrkShtServer, this.idMessage);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        onWillPop: () async {
          final BoxData = boxData(nameBox: "box_MarkedPage");
          if (statusTask != "Open") {
            await BoxData.markedPage(namePage: "task_list_adapter");
          } else {
            await BoxData.markedPage(namePage: "task_list_adapter_open");
            Navigator.of(context).pop(false);
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.warnaUngu,
            leading: IconButton(
              splashColor: Colors.transparent,
              onPressed: () async {
                print('status task');
                print(statusTask);
                final BoxData = boxData(nameBox: "box_MarkedPage");
                if (statusTask != "Open") {
                  await BoxData.markedPage(namePage: "task_list_adapter");
                } else {
                  await BoxData.markedPage(namePage: "task_list_adapter_open");
                }
                Navigator.of(context).pop(false);
              },
              icon: Icon(Icons.keyboard_arrow_left, size: 40),
            ),
            centerTitle: true,
            title: Text(
              Task["name"],
              style: AppTheme.appBarTheme(),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
            child: TaskDetailWidget(
                Task, statusTask, dataStsWrkShtServer, idMessage),
          ),
        ),
      ),
    );
  }
}

class TaskDetailWidget extends StatefulWidget {
  dynamic Task;
  String statusTask; //status seperti ongoing/handoff/uploaded
  String dataStsWrkShtServer;
  int idMessage;

  TaskDetailWidget(
      this.Task, this.statusTask, this.dataStsWrkShtServer, this.idMessage);

  @override
  State<TaskDetailWidget> createState() => _TaskDetailWidgetState();
}

class _TaskDetailWidgetState extends State<TaskDetailWidget> {
  int _state = 0;
  // kuranginTotalNotif() async {
  //   var updateDasboard = boxData(nameBox: 'box_dashboard');
  //   print("notif berkurang");
  //   await updateDasboard.addDataDashboard(param: 'totalNotif', tambah: false);
  // }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text("Terima",
          style: AppTheme.OpenSans600LS(16, Colors.white, -0.41));
    } else if (_state == 1) {
      Future.delayed(const Duration(seconds: 15), () async {
        Connection objCekConnection = Connection();
        Network cekKoneksi = await objCekConnection.CheckConnection();
        // print("Cek Koneksi isnternet di setupbuttonchild");
        print('hasilnya: ${cekKoneksi.Status}');
        if (!cekKoneksi.Status) {
          final downMessage = PopupError();
          downMessage.showError(context, cekKoneksi, true, mounted);
          // if (mounted) {
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //       content: Text("anda tidak terhubung ke jaringan internet")));
          // }
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

  btnLanjutkan(String userid, dynamic objDataTask) async {
    if (widget.Task.containsKey("direct")) {
      final box = boxData(nameBox: "box_worksheetform");
      var int_taskid;
      var String_taskid;
      if (widget.Task['id'].runtimeType == String) {
        int_taskid = int.parse(widget.Task['id']);
        String_taskid = widget.Task['id'];
      } else {
        int_taskid = widget.Task['id'];
        String_taskid = widget.Task['id'].toString();
      }
      if (widget.Task['direct'].runtimeType == String) {
        if (widget.Task['direct'] == 'true') {
          //get form and value lpu

          await box.getFormWorksheet(int_taskid);
          await box.getValueWork(
              int_taskid, int.parse(userid), widget.Task['handoff']);
        }
      } else if (widget.Task['direct'].runtimeType == bool) {
        if (widget.Task['direct']) {
          await box.getFormWorksheet(int_taskid);
          await box.getValueWork(
              int_taskid, int.parse(userid), widget.Task['handoff']);
        }
      }
    }
    print("line 131 page task_Detail");
    print(widget.statusTask);
    //panggil tabbar dari lokal
    String btnname = "";
    int page2init = 0;
    if (widget.dataStsWrkShtServer == '2') {
      page2init = 2;
    }
    int tabBar = 1;

    if (widget.statusTask == "Completed" || widget.statusTask == "Handed Off") {
      tabBar = 0;
    }
    print("widget.dataStsWrkShtServer task detail");
    print(page2init);
    final fillData = {
      "tabBar": tabBar,
      "pause": "aktif",
      "btnname": btnname,
      "page2": page2init
    };

    //
    final objBox = boxData(nameBox: 'box_workSheetSetting');
    var data = await objBox.getValueSettingFormWorksheet(
        userid: userid, taskid: widget.Task["id"].toString());
    print("data");
    print(data);
    // print(data['result']);
    if (data == null) {
      objBox.addDataSettingFormWorksheet(
          userid, widget.Task["id"].toString(), fillData);
    } else {
      if (widget.statusTask == "OnGoing") {
        tabBar = 1;
      } else {
        tabBar = data!['tabBar'];
      }
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<TabNotifier>(
            create: (context) => TabNotifier(widget.Task),
            child: Builder(builder: (BuildContext context) {
              return TaskWorksheetMenu(widget.Task, objDataTask, tabBar,
                  widget.statusTask, widget.dataStsWrkShtServer);
            })),
      ),
    );
  }

  btnPreview(dynamic objDataTask) async {
    //revisi flow 05072022
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<TabNotifier>(
            create: (context) => TabNotifier(widget.Task),
            child: Builder(builder: (BuildContext context) {
              return TaskWorksheetMenu(widget.Task, objDataTask, 0,
                  widget.statusTask, widget.dataStsWrkShtServer);
            })),
      ),
    );
    //
  }

  Future<void> btnTerima(int userid, dynamic objDataTask) async {
    final notifApi = NotificationApi();
    await notifApi.drainStream('from page task detail');
    _state = 0;
    if (_state == 0) {
      animateButton();
    }
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    TaskNetwork objTaskNetwork = TaskNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    if (cekKoneksi.Status) {
      late int dataTaskId;
      if (widget.Task["id"].runtimeType == String) {
        print("data string");
        dataTaskId = int.parse(widget.Task["id"]);
      }
      if (widget.Task["id"].runtimeType == int) {
        print("data integer 4");
        dataTaskId = widget.Task["id"];
      }

      // //TODO: simpan data task, detail task, form worksheet, value worksheet
      //
      // //add task
      // var addTask = boxData(nameBox: 'box_listPekerjaan');
      // addTask.addListTask(
      //     userid: userId,
      //     taskid: widget.Task['id'].toString(),
      //     statusTask: "OnGoing",
      //     values: Map<String, dynamic>.from(widget.Task));
      //
      // //add task detail
      // var box_AddDetail = Hive.box("box_detailPekerjaan");
      // box_AddDetail.put(
      //   widget.Task['id'].toString(),
      //   objDataTask,
      // );
      // var addValueServer = boxData(nameBox: 'box_valworksheet');
      // // add form
      //
      // await addValueServer.getFormWorksheet(widget.Task['id'].runtimeType == int
      //     ? widget.Task['id']
      //     : int.parse(widget.Task['id']));
      // // add value form default
      // var widgetHandoff = false;
      // if (widget.Task['handoff'] == "false") {
      //   widgetHandoff = false;
      // } else if (widget.Task['handoff'] == 'true') {
      //   widgetHandoff = true;
      // }
      // await addValueServer.getValueWork(
      //     widget.Task['id'].runtimeType == int
      //         ? widget.Task['id']
      //         : int.parse(widget.Task['id']),
      //     userid,
      //     widget.Task['handoff'] != null ? widgetHandoff : false);

      Network objNetwork =
          await objTaskNetwork.getTaskAccept(TaskId: dataTaskId);
      if (objNetwork.Status) {
        //TODO: simpan data task, detail task, form worksheet, value worksheet edited 16092022

        //add task
        var addTask = boxData(nameBox: 'box_listPekerjaan');
        addTask.addListTask(
            userid: userId,
            taskid: widget.Task['id'].toString(),
            statusTask: "OnGoing",
            values: Map<String, dynamic>.from(widget.Task));

        //add task detail
        var box_AddDetail = Hive.box("box_detailPekerjaan");
        box_AddDetail.put(
          widget.Task['id'].toString(),
          objDataTask,
        );
        var addValueServer = boxData(nameBox: 'box_valworksheet');
        // add form

        await addValueServer.getFormWorksheet(
            widget.Task['id'].runtimeType == int
                ? widget.Task['id']
                : int.parse(widget.Task['id']));
        // add value form default
        var widgetHandoff = false;
        if (widget.Task['handoff'] == "false") {
          widgetHandoff = false;
        } else if (widget.Task['handoff'] == 'true') {
          widgetHandoff = true;
        }
        await addValueServer.getValueWork(
            widget.Task['id'].runtimeType == int
                ? widget.Task['id']
                : int.parse(widget.Task['id']),
            userid,
            widget.Task['handoff'] != null ? widgetHandoff : false);
//close tag
        //TODO:roots setelah terima task
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(1),
            ),
            (route) => false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetail(
                widget.Task, "OnGoing", widget.Task['status_worksheet'], 0),
          ),
        );
        String btnname = "";
        print("widget.Task['status_worksheet']");
        print(widget.Task['status_worksheet']);
        if (widget.Task['status_worksheet'] == '2') {
          btnname = 'Fixing';
        }
        int tabBar = 1;

        final fillData = {
          "tabBar": tabBar,
          "pause": "aktif",
          "btnname": btnname,
          "page2": int.parse(widget.Task['status_worksheet'])
        };

        final objBox = boxData(nameBox: 'box_workSheetSetting');
        var data = await objBox.getValueSettingFormWorksheet(
            userid: userId, taskid: widget.Task["id"].toString());
        print("data");
        print(data);
        // print(data['result']);
        if (data == null) {
          objBox.addDataSettingFormWorksheet(
              userId, widget.Task["id"].toString(), fillData);
        } else {
          tabBar = data!['tabBar'];
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<TabNotifier>(
                create: (context) => TabNotifier(widget.Task),
                child: Builder(builder: (BuildContext context) {
                  return TaskWorksheetMenu(widget.Task, objDataTask, 1,
                      "OnGoing", widget.Task['status_worksheet']);
                })),
          ),
        );
        //ngurangin total notif ketika pekerjaan langsung di ambil
        // final updateNotif = boxData(nameBox: 'box_loncengNotif');
        // await updateNotif.updateTriggerNotif(param: false);

        //TODO: akhir roots
        setState(() {
          _state = 0;
        });
      } else {
        //Todo Delete Notif
        final boxlistNotif = boxData(nameBox: "box_listMessages");
        boxlistNotif.deleteNotif(
            taskid: widget.Task['id'].toString(), userid: userId);
        //
        final notifApi = NotificationApi();
        bool cekDrain = await notifApi.drainStream(
            "from worksheet page, condition task status Open and will be taken ");
        if (cekDrain) {
          _state = 0;
          if (_state == 0) {
            animateButton();
          }
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(0),
              ),
              (route) => false);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         HomeScreen(0),
          //   ),
          // );
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(objNetwork.Message ?? "")));
        } else {
          print("drain gagal");
        }
      }

      //kalo pekerjaan udah di ambil

      //

    } else {
      final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, false, mounted);
    }
  }

  Future<dynamic> getTaskDetail() async {
    //edited 25082022 clear stream on notifications
    if (widget.statusTask != "Open") {
      final notifApi = NotificationApi();
      await notifApi.drainStream('from page task detail');
    }
    //
    markedPage();
    dynamic objData = null;
    String StatusTask;
    TaskNetwork objTaskNetwork = TaskNetwork();
    WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    print("widget.statusTask");
    print(widget.statusTask);
    print(widget.dataStsWrkShtServer);
    print(widget.Task);
    print(widget.Task['handoff'].runtimeType);
    print(widget.idMessage);
    if (widget.Task['handoff'].runtimeType == String) {
      if (widget.Task['handoff'] == "true") {
        widget.Task['handoff'] = true;
      } else {
        widget.Task['handoff'] = false;
      }
    }
    if (widget.idMessage > 0 && widget.idMessage != null) {
      print('udah dapet result sebelum ke udpate notif');
      final notifUpdate = boxData(nameBox: "box_listMessages");
      await notifUpdate.updateMessage(idmessage: widget.idMessage);

      //update notif trigger
      final boxdata = boxData(nameBox: "box_setLoginCredential");

      String userId = await boxdata.getLoginCredential(param: "userId");
      try {
        if (Hive.isBoxOpen("box_listMessages")) {
          Hive.box("box_listMessages").close();
        }
      } catch (e) {}
      await Hive.openBox("box_listMessages");
      final box_OpenListMessage = await Hive.openBox("box_listMessages");
      final updateNotif = boxData(nameBox: "box_loncengNotif");

      if (box_OpenListMessage.isOpen) {
        if (box_OpenListMessage.isNotEmpty) {
          var dataLocal = box_OpenListMessage.get(userId);
          if (dataLocal != null) {
            for (var check in dataLocal) {
              print(check);
              if (check['messageOpen'] == false) {
                print("nyalain trigger");
                await updateNotif.updateTriggerNotif(param: true);
              } else {
                print("matiin trigger");
                await updateNotif.updateTriggerNotif(param: false);
              }
            }
          }
        }
      }

      //close tag
    }

    if (cekKoneksi.Status && widget.statusTask != "Handed Off") {
      late var dataTaskId;

      if (widget.Task["id"].runtimeType == String) {
        print("data string");
        dataTaskId = int.parse(widget.Task["id"]);
      }
      if (widget.Task["id"].runtimeType == int) {
        print("data integer 3");
        dataTaskId = widget.Task["id"];
      }

      Network objNetwork =
          await objTaskNetwork.getTaskDetail(TaskId: dataTaskId);
      if (!objNetwork.Status) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(objNetwork.Message.toString())));
      } else {
        var result = objNetwork.Data;
        if (widget.statusTask == "Open") {
          print('executed detail status open');
          return result;
        }
        print(result);
        // print("sampe sini dip");
        var box_AddDetail = Hive.box("box_detailPekerjaan");
        var box_DetailList = await Hive.openBox("box_detailPekerjaan");
        final data = box_DetailList.get(widget.Task['id'].toString());

        if (box_DetailList.isNotEmpty) {
          if (data == null) {
            box_AddDetail.put(widget.Task['id'].toString(), result);
            return result;
          } else {
            // use data
            result.forEach((i, value) {
              if (value != null && value != false && value != "") {
                data[i] = result[i];
              }
            });
            box_AddDetail.put(widget.Task['id'].toString(), data);
            objData = result;
            print(objData);
            return objData;
          }
        } else {
          box_AddDetail.put(widget.Task['id'].toString(), result);
        }

        //
      }
    } else {
      var box_DetailList = await Hive.openBox("box_detailPekerjaan");

      if (box_DetailList.isNotEmpty) {
        final data = box_DetailList.get(widget.Task['id'].toString());
        // use data
        if (data != null) {
          objData = data;
          print("data detail 123");
          print(data);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("data task detail tidak ada")));
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("data task detail tidak ada")));
        Navigator.pop(context);
      }
    }

    return objData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getTaskDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic objDataTask = snapshot.data!;

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailWidget(
                            Title: "Task No", Value: objDataTask["task_no"]),
                        DetailWidget(
                            Title: "Customer",
                            Value: objDataTask["customer_name"]),
                        DetailWidget(
                            Title: "Alamat Outlet",
                            Value: objDataTask["customer_address"]),
                        DetailWidget(
                            Title: "Email", Value: objDataTask["email"]),
                        DetailWidget(
                            Title: "Service", Value: objDataTask["service"]),
                        DetailWidget(
                            Title: "Project", Value: objDataTask["project"]),
                        DetailWidget(
                            Title: "Worksheet Template",
                            Value: objDataTask["worksheet"]),
                        // DetailWidget(
                        //     Title: "Assigned to", Value: objDataTask["assign"]),
                      ],
                    ),
                  ),
                  Container(
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.warnaHijau,
                          minimumSize: Size(289, 63),
                          padding: EdgeInsets.only(left: 43, right: 43),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(72.5)),
                          ),
                        ),
                        onPressed: () async {
                          final boxdata =
                              boxData(nameBox: "box_setLoginCredential");

                          String userid =
                              await boxdata.getLoginCredential(param: "userId");
                          if (widget.statusTask ==
                              "Open") //kondisi jika task blm di ambil
                          {
                            TaskNetwork objTaskNetwork = TaskNetwork();
                            print("getTaskAccept");
                            print(widget.Task);
                            if (widget.Task['handoff'] == true) {
                              btnPreview(objDataTask);
                              //
                            } else {
                              await btnTerima(int.parse(userid), objDataTask);
                            }
                          } else {
                            btnLanjutkan(userid, objDataTask);
                          }
                        },
                        child: widget.statusTask == "Open"
                            ? (widget.Task['handoff'] == true
                                ? Text(
                                    "Preview",
                                    style: AppTheme.OpenSans600LS(
                                        16, Colors.white, -0.41),
                                  )
                                : setUpButtonChild())
                            : Text(
                                "Lanjutkan",
                                style: AppTheme.OpenSans600LS(
                                    16, Colors.white, -0.41),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return Center(
            child: CircularProgressIndicator(
          color: AppTheme.warnaHijau,
        ));
      },
    );
  }
}

// getStatusItem(String taskid) async {
//   var box_AddList = Hive.box("box_listPekerjaan");
//   //open box list pekerjaan
//   var box_openListPekerjaan = await Hive.openBox("box_listPekerjaan");
//
//   final data = box_openListPekerjaan.get(taskid);
//   data['statusTask'] = "Handed Off";
//   box_AddList.put(taskid, data);
//   print(data);
// }

// Future loadDataFromServer(int taskid) async {
//   WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
//   Preferences pref = Preferences();
//   String userid = await pref.getUserId();
//   Network objLoadNetwork = await objWorksheetNetwork.LoadWorksheetForm(
//       userId: int.parse(userid), taskId: taskid);
// }
markedPage() async {
  final BoxData = boxData(nameBox: "box_MarkedPage");
  await BoxData.markedPage(namePage: "task_detail");
}

class DetailWidget extends StatelessWidget {
  String Title;
  dynamic Value;

  DetailWidget({required this.Title, required this.Value});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Title,
              style: AppTheme.OpenSans500(12, AppTheme.warnaAbuMuda),
            ),
            SizedBox(
              height: 6 * MySize.scaleFactorHeight,
            ),
            Text(
              Value == false ? "" : Value.toString(),
              style: AppTheme.OpenSans500(15, AppTheme.warnaAbuTua),
            ),
            SizedBox(
              height: 26 * MySize.scaleFactorHeight,
            ),
          ],
        ),
      ),
    );
  }
}
