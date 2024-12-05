import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../model/mNetwork.dart';
import '../network/CheckDataConnection.dart';
import '../network/task.dart';
import '../network/worksheet.dart';

class boxData {
  String? nameBox;
  dynamic objLoadData;
  late Map<String, dynamic> indexedData;
  final tanggal = DateFormat('dd').format(DateTime.now());
  boxData({this.nameBox});

  Future<bool> getTriggerNotif({String? param, bool background = false}) async {
    // if (Hive.isBoxOpen("box_setLoginCredential")) {
    //   await Hive.box("box_setLoginCredential").close();
    // }
    // var dir = await getApplicationDocumentsDirectory();
    // print(dir);
    // Hive.init(dir.path);
    await Hive.openBox("box_loncengNotif");
    if (Hive.isBoxOpen("box_loncengNotif")) {
      await Hive.box("box_loncengNotif").close();
    }

    // await Hive.openBox("box_setLoginCredential");
    await Hive.openBox("box_loncengNotif");
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");

    late Map notif;
    var openboxNotif = await Hive.openBox("box_loncengNotif");
    if (openboxNotif.isOpen) {
      if (openboxNotif.isNotEmpty) {
        notif = Map.from(openboxNotif.get(userId) ?? {"loncengNotif": false});
        //08082022
        // Hive.box("box_loncengNotif").close();
        if (notif == {}) {
          return true;
        }
        print("valDashboard cek notif");
        print(notif);
        if (notif[param] != false) {
          return notif[param];
        }
        // return false;
      }
    }

    if (Hive.isBoxOpen("box_loncengNotif")) {
      await Hive.box("box_loncengNotif").close();
    }

    return false;
  }

  Future<void> saveTimer(Map<String, dynamic> timer) async {
    var openboxTimerworksheet = await Hive.openBox(nameBox!);
    var addTimerworksheet = Hive.box(nameBox!);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    if (openboxTimerworksheet.isOpen) {
      if (openboxTimerworksheet.isNotEmpty) {
        print('save timer');
        print(timer);
        bool checkData = false;
        var data = List.from(openboxTimerworksheet.get(userId) ?? []);
        if (data.isNotEmpty) {
          print('save timer 1');
          for (int i = 0; i < data.length; i++) {
            if (data[i]['taskid'] == timer['taskid']) {
              data[i] = timer;
              print('save timer 2');
              checkData = true;
              break;
            } else {
              print('save timer 3');
              checkData = false;
            }
          }
          if (checkData) {
            print('save timer 4');
            print(data);
            addTimerworksheet.delete(userId);
            addTimerworksheet.put(userId, data);
          } else {
            print('save timer 5');
            data.insert(0, timer);
            addTimerworksheet.delete(userId);
            addTimerworksheet.put(userId, data);
          }
        } else {
          print('save timer 6');
          addTimerworksheet.delete(userId);
          addTimerworksheet.put(userId, [timer]);
        }
      } else {
        print('save timer 7');
        addTimerworksheet.delete(userId);
        addTimerworksheet.put(userId, [timer]);
      }
      await openboxTimerworksheet.compact();
    }
  }

  Future<void> deleteTimer({String? Taskid}) async {
    var openboxTimerworksheet = await Hive.openBox(nameBox!);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    if (openboxTimerworksheet.isOpen) {
      var addTimerworksheet = Hive.box(nameBox!);

      if (openboxTimerworksheet.isNotEmpty) {
        var data = List.from(openboxTimerworksheet.get(userId) ?? []);
        if (data.isNotEmpty) {
          for (var val in data) {
            if (val['taskid'] == Taskid) {
              data.remove(val);

              break;
            }
          }
          addTimerworksheet.delete(userId);
          addTimerworksheet.put(userId, data);
        } else {
          print('data ga ada');
        }
      }
      await openboxTimerworksheet.compact();
    }
  }

  Future<Map> getTimer(String? Taskid) async {
    var openboxTimerworksheet = await Hive.openBox(nameBox!);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    if (openboxTimerworksheet.isOpen) {
      var addTimerworksheet = Hive.box(nameBox!);

      if (openboxTimerworksheet.isNotEmpty) {
        List data = List.from(openboxTimerworksheet.get(userId) ?? []);
        //08082022
        // add_TimerWorksheet.close();
        if (data.isNotEmpty) {
          for (var val in data) {
            print(val);
            if (val['taskid'] == Taskid) {
              final result = val;
              print('gettimerrr');
              print(val);
              print(result);
              return result;
            }
          }
        }
      } else {
        print('kosong box timer worksheet');
      }
    }
    return {};
  }

  Future<void> savingTimer_temporary({String? Taskid, List? Timer}) async {
    var openboxSavingtimerTemporary = await Hive.openBox(nameBox!);
    if (openboxSavingtimerTemporary.isOpen) {
      var addSavingtimerTemporary = Hive.box(nameBox!);

      addSavingtimerTemporary.put(Taskid, Timer);
      await openboxSavingtimerTemporary.compact();
    }
  }

  Future getTimer_temporary({String? Taskid}) async {
    var openboxSavingtimerTemporary = await Hive.openBox(nameBox!);
    if (openboxSavingtimerTemporary.isOpen) {
      var addSavingtimerTemporary = Hive.box(nameBox!);

      final result = List.from(openboxSavingtimerTemporary.get(Taskid) ?? []);
      //08082022
      // add_savingTimer_temporary.close();
      return result;
    }
  }

  Future<void> deleteTimer_temporary({String? Taskid}) async {
    var openboxSavingtimerTemporary = await Hive.openBox(nameBox!);
    var addSavingtimerTemporary = Hive.box(nameBox!);
    openboxSavingtimerTemporary.clear();
  }

  Future<void> updateTriggerNotif({bool param = false}) async {
    await Hive.openBox("box_loncengNotif");
    if (Hive.isBoxOpen("box_loncengNotif")) {
      try {
        Hive.box('box_loncengNotif').close();
      } catch (e) {
        print(e);
      }
    }
    await Hive.openBox("box_loncengNotif");

    var openboxLocengnotif = await Hive.openBox("box_loncengNotif");
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    Map data = {"loncengNotif": param};
    String userId = await boxdata.getLoginCredential(param: "userId");
    if (openboxLocengnotif.isOpen) {
      print("box trigger notif is open");
      var updateLocengnotif = Hive.box("box_loncengNotif");
      if (updateLocengnotif.isNotEmpty) {
        var datas = Map.from(openboxLocengnotif.get(userId));
        updateLocengnotif.delete(userId);
        updateLocengnotif.put(userId, data);
        print("data update norif");
        print(data);
      } else {
        updateLocengnotif.put(userId, data);
      }
      // await openBox_locengNotif.compact();
    }
    // if (Hive.isBoxOpen("box_loncengNotif")) {
    //   try {
    //     Hive.box('box_loncengNotif').close();
    //   } catch (e) {
    //     print(e);
    //   }
    // }
  }

  addDataDashboard(
      {String? param,
      String? param2,
      bool? tambah,
      bool? reset = false,
      dynamic set,
      bool background = false}) async {
    // TODO: Default format data,"Date": tanggal,"getPekerjaan","selesaiAll","selesaiPerDay","taskDikirim","taskPendingKirim","Point"
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    late Map valDashboard;

    if (background) {
      if (Hive.isBoxOpen("box_dashboard")) {
        await Hive.box("box_dashboard").close();
      }
    }
    await Hive.openBox("box_dashboard");

    var openboxDashboard = await Hive.openBox("box_dashboard");

    if (openboxDashboard.isOpen) {
      var insertboxDashboard = Hive.box("box_dashboard");
      // print("buka ni");
      if (openboxDashboard.isNotEmpty) {
        valDashboard = Map.from(openboxDashboard.get(userId));
        // print("valDashboard yg eror");
        // print(valDashboard);
        if (reset!) {
          valDashboard['$param'] = 0;
          valDashboard['triggerRefresh'] = true;
        }
        if (tambah!) {
          if (set != null) {
            // print('point erer');
            // print(param);
            valDashboard['$param'] = set;
            if (set != false) {
              valDashboard['triggerRefresh'] = true;
            }
          } else {
            valDashboard['$param'] += 1;
            valDashboard['triggerRefresh'] = true;
          }
          //TODO if ini untuk nambah pekerjaan selesai per hari
          // if (valDashboard['Date'] == tanggal && param == "selesaiAll") {
          //   valDashboard['selesaiPerDay'] += 1;
          // }
        } else {
          if (!reset) {
            valDashboard['$param'] -= 1;
            valDashboard['triggerRefresh'] = true;
          }
        }
        // print("valDashboard['$param']");
        // print(valDashboard['$param']);
        insertboxDashboard.delete(userId);
        insertboxDashboard.put(userId, valDashboard);
      } else {
        // print('kesini apaya');
        // valDashboard = {
        //   "Date": tanggal,
        //   "getPekerjaan": 1,
        //   "selesaiAll": 0,
        //   "selesaiPerDay": 0,
        //   "taskDikirim": 0,
        //   "taskPendingKirim": 0,
        //   "Point": 0,
        //"TotalNotif":0
        // };
        // insertBox_dashboard.put("values", valDashboard);
      }
      await openboxDashboard.compact();
    }

    if (background) {
      if (Hive.isBoxOpen("box_dashboard")) {
        await Hive.box("box_dashboard").close();
      }
    }
  }

  addDataShowNotif(String taskid, dynamic message) async {
    // print("add Data show Notif");
    // print(taskid);
    // print(message);
    var boxShownotif = await Hive.openBox(nameBox!);
    if (boxShownotif.isOpen) {
      var addboxShownotif = Hive.box(nameBox!);
      Map saveData = {"taskid": taskid, "data": message};
      bool checkData = false;
      if (boxShownotif.isNotEmpty) {
        var data = List.from(boxShownotif.get("showNotif"));

        // print("data");
        // print(data);
        if (data.isNotEmpty) {
          for (var val in data) {
            // print("val");
            // print(val);
            // print(val['taskid'].runtimeType);
            // print(taskid.runtimeType);
            if (val['taskid'] == taskid) {
              checkData = false;
              break;
            } else {
              checkData = true;
            }
          }
          if (checkData) {
            data.add(saveData);
            var dataDistinct = (data.toSet().toList()).toSet().toList();
            addboxShownotif.delete("showNotif");
            addboxShownotif.put("showNotif", dataDistinct);
          } else {
            // data.add(saveData);
            // addbox_showNotif.delete("showNotif");
            // addbox_showNotif.put("showNotif", data);
          }
        } else {
          data.add(saveData);
          var dataDistinct = (data.toSet().toList()).toSet().toList();
          addboxShownotif.delete("showNotif");
          addboxShownotif.put("showNotif", dataDistinct);
        }
      } else {
        var dataDistinct = ({saveData}.toList()).toSet().toList();
        addboxShownotif.put("showNotif", dataDistinct);
      }
    }
  }

  Future<dynamic> getDataShowNotif() async {
    var boxShownotif = await Hive.openBox(nameBox!);
    if (boxShownotif.isOpen) {
      var addboxShownotif = Hive.box(nameBox!);

      bool checkData = false;
      if (boxShownotif.isNotEmpty) {
        var data = List.from(
            (await boxShownotif.get("showNotif").toSet().toList())
                .toSet()
                .toList());
        // print(data);
        // print(data.length);
        if (data.isNotEmpty) {
          return data[data.length - 1]['data'];
        } else {
          // print('data show notif is empty 1');
        }
      } else {
        // print('data show notif is empty 2');
      }
    }
    return 0;
  }

  Future<void> deleteDataShowNotif(String taskid) async {
    var boxShownotif = await Hive.openBox(nameBox!);
    if (boxShownotif.isOpen) {
      var addboxShownotif = Hive.box(nameBox!);

      bool checkData = false;
      if (boxShownotif.isNotEmpty) {
        var data = List.from(boxShownotif.get("showNotif"));
        for (var val in data) {
          if (val['taskid'] == taskid) {
            checkData = false;
            data.remove(val);
            print("Delete show notif successed");
            break;
          } else {
            checkData = true;
          }
        }
        if (!checkData) {
          addboxShownotif.delete("showNotif");
          addboxShownotif.put("showNotif", data.toSet().toList());
        }
      }
    }
  }

  addValueWorksheet(
      {Map<String, dynamic>? valServer,
      String? userid,
      String? taskid,
      bool handoff = false}) async {
    await Hive.openBox(nameBox!);
    var boxOpenvalueworksheet = await Hive.openBox(nameBox!);
    Map<String, dynamic> valueServertoDB = {"taskid": taskid};
    bool checkdata = false;
    if (boxOpenvalueworksheet.isOpen) {
      print('data value worksheet in boxData class');
      var boxAddvalueworksheet = Hive.box(nameBox!);

      if (boxOpenvalueworksheet.isNotEmpty) {
        List data = List.from(boxOpenvalueworksheet.get(userid) ?? []);
        await boxOpenvalueworksheet.compact();
        // print(data);

        if (data.isNotEmpty) {
          for (var value in data) {
            if (value['taskid'] == taskid) {
              checkdata = true;
              print('data value worksheet berhasil diremove');
              print(handoff);
              if (handoff) {
                data.remove(value);
              }
              break;
            }
          }
          if (!checkdata) {
            valueServertoDB['data'] = valServer;
            data.add(valueServertoDB);
            boxAddvalueworksheet.delete(userid);

            boxAddvalueworksheet.put(userid, data);
          } else {
            if (handoff) {
              valueServertoDB['data'] = valServer;
              data.add(valueServertoDB);
              boxAddvalueworksheet.delete(userid);

              boxAddvalueworksheet.put(userid, data);
            }
          }
        } else {
          //isi box

          valueServertoDB['data'] = valServer;
          boxAddvalueworksheet.put(userid, [valueServertoDB]);
        }
        // box_AddValueWorksheet.compact();
        await boxOpenvalueworksheet.compact();
      } else {
        //isi box

        valueServertoDB['data'] = valServer;
        boxAddvalueworksheet.put(userid, [valueServertoDB]);
        // box_AddValueWorksheet.compact();
        await boxOpenvalueworksheet.compact();
      }
      // box_AddValueWorksheet.close();
    }
  }

  updateValueWorksheet({Map<String, dynamic>? value, String? taskid}) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    var boxOpenvalueworksheet = await Hive.openBox(nameBox!);

    if (boxOpenvalueworksheet.isOpen) {
      var boxAddvalueworksheet = Hive.box(nameBox!);

      if (boxOpenvalueworksheet.isNotEmpty) {
        var data = List.from(boxOpenvalueworksheet.get(userId));
        await boxOpenvalueworksheet.compact();
        // print(value);

        // valueServertoDB['data'] = valServer;
        // box_AddValueWorksheet.put(userId.toString(), valueServertoDB);
        for (var values in data) {
          if (values['taskid'] == taskid) {
            values['data'] = value;
            break;
          }
        }
        boxAddvalueworksheet.delete(userId);
        boxAddvalueworksheet.put(userId, data);
      } else {
        //isi box
      }
    }
    await boxOpenvalueworksheet.compact();
  }

  Future<dynamic> getValueWorksheet({String? userid, String? taskid}) async {
    // await Hive.openBox("box_valworksheet");

    var boxOpenvalueworksheet = await Hive.openBox("box_valworksheet");
    var valueServertoDB = {"taskid": taskid};
    bool checkdata = false;
    if (boxOpenvalueworksheet.isOpen) {
      var boxAddvalueworksheet = Hive.box("box_valworksheet");

      if (boxOpenvalueworksheet.isNotEmpty) {
        final data = List.from(await boxOpenvalueworksheet.get(userid) ?? []);

        await boxOpenvalueworksheet.compact();

        for (var value in data) {
          if (value['taskid'] == taskid) {
            objLoadData = Map<String, dynamic>.from(value['data']);
            break;
          } else {
            objLoadData = null;
          }
        }
      } else {
        //isi box
        objLoadData = null;
      }
    }
    return objLoadData;
  }

  Future<bool> UpdateListNotif(List dataGet) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    await Hive.openBox(nameBox!);
    String userId = await boxdata.getLoginCredential(param: "userId");
    final boxOpenlistmessage = await Hive.openBox(nameBox!);
    if (boxOpenlistmessage.isOpen) {
      final boxAddmessage = Hive.box(nameBox!);

      if (boxOpenlistmessage.isOpen) {
        if (boxOpenlistmessage.isNotEmpty) {
          boxAddmessage.delete(userId);
          boxAddmessage.put(userId, dataGet);
          return true;
        }
      }
      await boxOpenlistmessage.compact();
    }
    return false;
  }

  updateMessage({int? idmessage}) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");

    await Hive.openBox("box_listMessages");
    final boxOpenlistmessage = await Hive.openBox("box_listMessages");

    if (boxOpenlistmessage.isOpen) {
      final boxAddmessage = Hive.box("box_listMessages");

      if (boxOpenlistmessage.isNotEmpty) {
        var dataGet = List.from(boxOpenlistmessage.get(userId) ?? []);
        if (dataGet.isNotEmpty) {
          for (var value in dataGet) {
            if (value['idmessage'] == idmessage &&
                value['messageOpen'] == false) {
              print("message Open is change true in $idmessage");
              value['messageOpen'] = true;
              print("notif update");
              // await addDataDashboard(param: 'triggerNotif', tambah: true, set: false);
              break;
            }
          }
          boxAddmessage.delete(userId);
          boxAddmessage.put(userId, dataGet);
        } else {
          print('dataGet is null and the length is 0');
        }
      } else {
        print('box is empty');
      }
      //08082020
      await boxOpenlistmessage.compact();
    }
  }

  addMessage(
      {String? title,
      String? body,
      dynamic data,
      bool background = false,
      bool onclick = false}) async {
    if (background) {
      if (Hive.isBoxOpen("box_listMessages")) {
        await Hive.box("box_listMessages").close();
      }
    }
    await Hive.openBox("box_listMessages");
    final boxOpenlistmessage = await Hive.openBox("box_listMessages");
    if (boxOpenlistmessage.isOpen) {
      final boxAddmessage = Hive.box("box_listMessages");
      final boxdata = boxData(nameBox: "box_setLoginCredential");

      String userId = await boxdata.getLoginCredential(param: "userId");
      print(userId);
      DateTime timeMessage = DateTime.now();

      Map<String, dynamic> dataSave = {"taskid": data['id']};
      if (boxOpenlistmessage.isNotEmpty) {
        var dataGet = List.from(boxOpenlistmessage.get(userId) ?? []);
        if (dataGet.isNotEmpty) {
          dataSave['idmessage'] = dataGet.length + 1;
          dataSave['title'] = title;
          dataSave['body'] = body;
          dataSave['time'] = timeMessage.millisecondsSinceEpoch;
          dataSave['data'] = data;
          if (!onclick) {
            dataSave['messageOpen'] = false;
          } else {
            dataSave['messageOpen'] = true;
          }
          print("dataSave1");
          print(dataSave);
          dataGet.insert(0, dataSave);
          boxAddmessage.delete(userId);
          boxAddmessage.put(userId, dataGet);
          await Hive.openBox("box_listMessages");
        } else {
          dataSave['idmessage'] = 1;
          dataSave['title'] = title;
          dataSave['body'] = body;
          dataSave['time'] = timeMessage.millisecondsSinceEpoch;
          dataSave['data'] = data;
          if (!onclick) {
            dataSave['messageOpen'] = false;
          } else {
            dataSave['messageOpen'] = true;
          }
          print("dataSave2");
          print(dataSave);
          boxAddmessage.put(userId, [dataSave]);
          await Hive.openBox("box_listMessages");
        }
      } else {
        dataSave['idmessage'] = 1;
        dataSave['title'] = title;
        dataSave['body'] = body;
        dataSave['time'] = timeMessage.millisecondsSinceEpoch;
        dataSave['data'] = data;
        if (!onclick) {
          dataSave['messageOpen'] = false;
        } else {
          dataSave['messageOpen'] = true;
        }
        print("dataSave3");
        print(dataSave);
        boxAddmessage.put(userId, [dataSave]);
        await Hive.openBox("box_listMessages");
      }
      await boxOpenlistmessage.compact();
    }

    if (background) {
      try {
        if (Hive.isBoxOpen("box_listMessages")) {
          await Hive.box("box_listMessages").close();
        }
      } catch (e) {}
    }
  }

  addTimeSheet({String? userid, String? taskid, List<String?>? values}) async {
    final boxOpenlisttimesheet = await Hive.openBox(nameBox!);
    bool availData = false;
    Map<String, dynamic> valueToDB = {"taskid": taskid};
    if (boxOpenlisttimesheet.isOpen) {
      final boxAddtimesheet = Hive.box(nameBox!);

      if (boxOpenlisttimesheet.isNotEmpty) {
        // print(box_openListTimesheet.values);
        var dataListTimesheet =
            List.from(boxOpenlisttimesheet.get(userid) ?? []);

        if (dataListTimesheet.isNotEmpty) {
          for (var value in dataListTimesheet) {
            print("value timer from db");
            print(value);
            if (value['taskid'] == taskid) {
              print("add timesheet");
              print(values);
              // value['data'].add(values);
              value['data'].insert(0, values);

              // savedata.addAll(value['data']);
              availData = false;
              break;
            } else {
              availData = true;
            }
          }
          if (availData) {
            print("kseini1");
            valueToDB['data'] = [values];
            dataListTimesheet.add(valueToDB);
            boxAddtimesheet.delete(userid);
            boxAddtimesheet.put(userid, dataListTimesheet);
          } else {
            print("kseini2");
            boxAddtimesheet.put(userid, dataListTimesheet);
          }
        } else {
          print("kseini3");
          valueToDB['data'] = [values];
          boxAddtimesheet.put(userid, [valueToDB]);
        }
      } else {
        print("kseini4");
        valueToDB['data'] = [values];
        boxAddtimesheet.put(userid, [valueToDB]);
      }
      await boxOpenlisttimesheet.compact();
    }
    return true;
  }

  // loadSettingFormWorksheet()async{}

  addDataSettingFormWorksheet(
      String? userid, String? taskid, Map<String, dynamic>? values) async {
    final openCommonSetting = await Hive.openBox(nameBox!);

    Map<String, dynamic> valueToDB = {"taskid": taskid};
    dynamic valueBox = {};
    if (openCommonSetting.isOpen) {
      final boxAddcommonsetting = Hive.box(nameBox!);

      if (openCommonSetting.isNotEmpty) {
        var dataSetting = List.from(openCommonSetting.get(userid) ?? []);
        valueToDB['data'] = values;
        dataSetting.add(valueToDB);
        boxAddcommonsetting.delete(userid);
        boxAddcommonsetting.put(userid, dataSetting);
      } else {
        valueToDB['data'] = values;
        boxAddcommonsetting.put(userid, [valueToDB]);
      }
      await openCommonSetting.compact();
    }
  }

  settingFormWorksheet(
      String? userid, String? taskid, Map<String, dynamic>? values) async {
    final openCommonSetting = await Hive.openBox(nameBox!);
    bool chekcData = false;
    Map<String, dynamic> valueToDB = {"taskid": taskid};
    dynamic valueBox = {};
    if (openCommonSetting.isOpen) {
      final boxAddcommonsetting = Hive.box(nameBox!);

      if (openCommonSetting.isNotEmpty) {
        var dataSetting = List.from(openCommonSetting.get(userid) ?? []);
        for (var val in dataSetting) {
          if (val['taskid'] == taskid) {
            valueBox = val['data'];

            //
            if (values!['tabbar'] == 2) {
              valueBox["tabBar"] = 1;
            } else {
              valueBox['tabBar'] = values['tabBar'];
            }

            if (values['btnname'] != "") {
              // print("btnnameeeee");
              // print(values['btnname']);
              valueBox["btnname"] = values['btnname'];
            }
            if (values['page2'] == 2) {
              valueBox["page2"] = values['page2'];
            }
            if (values['pause'] != "") {
              valueBox['pause'] = values['pause'];
            }

            // if (pause != "") {
            //   data['pause'] = pause;
            // }
            // print(
            //     "data with $taskid is not empty in boxdata setting formworksheet");
            // print(valueBox);
            val['data'] = valueBox;
            //
            chekcData = false;
            // box_AddcommonSetting.put(userid, val);
            break;
          } else {
            chekcData = true;
          }
        }
        // if (chekcData) {
        //   valueToDB['data'] = values;
        //   dataSetting.add(valueToDB);
        //   box_AddcommonSetting.put(userid, dataSetting);
        // } else {
        boxAddcommonsetting.delete(userid);
        boxAddcommonsetting.put(userid, dataSetting);
        // }
      } else {
        valueToDB['data'] = values;
        boxAddcommonsetting.put(userid, [valueToDB]);
      }
      await openCommonSetting.compact();
    }
  }

  Future getValueSettingFormWorksheet({String? userid, String? taskid}) async {
    final openCommonSetting = await Hive.openBox(nameBox!);
    bool chekcData = false;
    Map<String, dynamic> valueToDB = {"taskid": taskid};
    dynamic valueBox = {"result": ""};
    if (openCommonSetting.isOpen) {
      final boxAddcommonsetting = Hive.box(nameBox!);

      if (openCommonSetting.isNotEmpty) {
        List dataSetting = List.from(openCommonSetting.get(userid) ?? []);
        //08082022
        // box_AddcommonSetting.close();
        for (var val in dataSetting) {
          if (val['taskid'] == taskid) {
            return val['data'];
            chekcData = false;
            // box_AddcommonSetting.put(userid, val);
            break;
          }
        }
      }
    }
    return null;
  }

  addListTask(
      {String? userid,
      String? taskid,
      String? statusTask,
      Map<String, dynamic>? values}) async {
    // var updateDasboard = boxData(nameBox: 'box_dashboard');
    final boxOpenlisttask = await Hive.openBox(nameBox!);
    List dataList = [];
    Map<String, dynamic> dataSave = {};

    bool checkData = false;

    if (boxOpenlisttask.isOpen) {
      dataList = List.from(boxOpenlisttask.get(userid) ?? []);

      final boxAddlisttask = Hive.box(nameBox!);

      if (dataList.isNotEmpty) {
        for (var value in dataList) {
          if (values!['id'] == value['data']['id']) {
            value['data'] = values;
            value['StatusTask'] = statusTask;
            checkData = false;

            break;
          } else {
            checkData = true;
          }
        }
        print('add data list');
        print(checkData);
        print(values);
        print(statusTask);
        if (checkData) {
          dataSave['data'] = values;
          dataSave['StatusTask'] = statusTask;

          dataList.insert(0, dataSave);
          boxAddlisttask.delete(userid);
          boxAddlisttask.put(userid, dataList);
          // updateDasboard.addDataDashboard(
          //     param: 'getPekerjaan', tambah: true, reset: false);
        } else {
          boxAddlisttask.delete(userid);
          boxAddlisttask.put(userid, dataList);
        }
      } else {
        checkData = false;
        dataSave['data'] = values;
        dataSave['StatusTask'] = statusTask;
        dataList.insert(0, dataSave);
      }

      await boxOpenlisttask.compact();
    }
  }

  Future<void> deleteTask(
      {String? userid, int? taskid, String? from = ""}) async {
    var updateDasboard = boxData(nameBox: 'box_dashboard');
    final boxOpenlisttask = await Hive.openBox(nameBox!);
    List dataList = [];

    if (boxOpenlisttask.isOpen) {
      dataList = List.from(boxOpenlisttask.get(userid) ?? []);

      final boxAddlisttask = Hive.box(nameBox!);

      if (dataList.isNotEmpty) {
        for (var value in dataList) {
          // print("value datalist");
          // print(value);
          if (taskid == value['data']['id']) {
            // print("value datalist before delete task");
            if (from == "Handed Off") {
              value['data']['task_status'] = "Handed Off";
              // print(value);

              var updateHistoryPekerjaan =
                  boxData(nameBox: 'box_historyPekerjaan');
              await updateHistoryPekerjaan.addListTask(
                  statusTask: from,
                  userid: userid,
                  taskid: taskid.toString(),
                  values: Map<String, dynamic>.from(value['data']));
            }
            if (from == "Completed") {
              value['data']['task_status'] = "Handed Off";
              // print(value);

              var updateHistoryPekerjaan =
                  boxData(nameBox: 'box_historyPekerjaan');
              await updateHistoryPekerjaan.addListTask(
                  statusTask: from,
                  userid: userid,
                  taskid: taskid.toString(),
                  values: Map<String, dynamic>.from(value['data']));
            }
            dataList.remove(value);
            print("delete task in listtask ongoing successed");
            break;
          }
        }
      }

      boxAddlisttask.delete(userid);
      boxAddlisttask.put(userid, dataList);

      await boxOpenlisttask.compact();
    }
  }

  Future countListTaskOnHome(
      {int? getpekerjaan, int? point, int? FinishTask}) async {
    var updateDasboard = boxData(nameBox: 'box_dashboard');

    updateDasboard.addDataDashboard(
        param: 'getPekerjaan', tambah: true, reset: false, set: getpekerjaan!);
    updateDasboard.addDataDashboard(
        param: 'Point', tambah: true, reset: false, set: point!);
    updateDasboard.addDataDashboard(
        param: 'selesaiAll', tambah: true, reset: false, set: FinishTask!);
    updateDasboard.addDataDashboard(
        param: 'selesaiPerDay', tambah: true, reset: false, set: FinishTask);

    // box_AddListTask.put(userid, dataSave);

    return true;
  }

  Future<bool> countHistoryTaskOnHome({List? values}) async {
    var updateDasboard = boxData(nameBox: 'box_dashboard');

    for (var data in values!) {
      if (data['fsm_done'] == true) {
        updateDasboard.addDataDashboard(param: 'taskDikirim', tambah: true);
      }
      if (data['task_status'] != "On Going" || data['fsm_done'] == true) {
        // updateDasboard.addDataDashboard(param: 'getPekerjaan', tambah: true);

        updateDasboard.addDataDashboard(param: 'selesaiAll', tambah: true);
        updateDasboard.addDataDashboard(param: 'selesaiPerDay', tambah: true);
      }
    }

    // box_AddListTask.put(userid, dataSave);

    return true;
  }

  Future<void> addTaskToListTask(
      {dynamic dataTask, bool handoff = false}) async {
    //ini hanya ongoing dan completed
    if (handoff) {
      dataTask['task_status'] = "On Going";
    }
    final getUserid = boxData(nameBox: "box_setLoginCredential");
    String userid = await getUserid.getLoginCredential(param: "userId");
    final boxOpenlisttask = await Hive.openBox(nameBox!);
    Map<String, dynamic> dataAdd = {};
    if (boxOpenlisttask.isOpen) {
      final boxAddtask = Hive.box(nameBox!);

      if (boxOpenlisttask.isNotEmpty) {
        var data = List.from(boxOpenlisttask.get(userid) ?? []);
        dataAdd['data'] = dataTask;
        dataAdd['StatusTask'] = "OnGoing";
        data.insert(0, dataAdd);
        boxAddtask.delete(userid);
        boxAddtask.put(userid, data);
        await getDetail(dataTask['id']);
        await getFormWorksheet(dataTask['id']);
        await getValueWork(dataTask['id'], int.parse(userid), false);
      } else {
        dataAdd['data'] = dataTask;
        dataAdd['StatusTask'] = "OnGoing";

        boxAddtask.put(userid, [dataAdd]);
        await getDetail(dataTask['id']);
        await getFormWorksheet(dataTask['id']);
        await getValueWork(dataTask['id'], int.parse(userid), false);
      }
      await boxOpenlisttask.compact();
    }
  }

  Future<bool> refreshListTask(
      {String? userid,
      String? taskid,
      String? statusTask,
      List? values}) async {
    var updateDasboard = boxData(nameBox: 'box_dashboard');
    final boxOpenlisttask = await Hive.openBox(nameBox!);

    List dataSave = [];
    List dataHistory = [];
    bool checkData = false;

    if (boxOpenlisttask.isOpen) {
      final boxAddlisttask = Hive.box(nameBox!);

      for (var data in values!) {
        Map<String, dynamic> dataAdd = {};
        dataAdd['data'] = data;
        dataAdd['StatusTask'] = statusTask;

        dataSave.add(dataAdd);
        getDetail(data['id']);
        await getFormWorksheet(data['id']);
        print("sampai getFormWorksheet2");
        // deleteFormWorksheet([]);
        await getValueWork(data['id'], int.parse(userid ?? ""), false);
        print("sampai getValueWork");

        // updateDasboard.addDataDashboard(
        //     param: 'getPekerjaan', tambah: true, reset: false);
      }
      boxAddlisttask.delete(userid);
      boxAddlisttask.put(userid, dataSave);
      await boxOpenlisttask.compact();
    }
    return true;
  }

  Future<bool> refreshHistoryTask(
      {String? userid,
      String? taskid,
      String? statusTask,
      List? values}) async {
    final boxOpenhistorytask = await Hive.openBox(nameBox!);
    var updateDasboard = boxData(nameBox: 'box_dashboard');
    updateDasboard.addDataDashboard(
        param: 'taskDikirim', tambah: false, reset: true);
    // List dataList = [];
    List dataSave = [];
    List idTaskHistory = [];
    bool checkData = false;
    print("values history");
    print(values);
    if (boxOpenhistorytask.isOpen) {
      final boxAddhistorytask = Hive.box(nameBox!);

      for (var data in values!) {
        idTaskHistory.add(data['id'].toString());
        Map<String, dynamic> dataAdd = {};
        dataAdd['data'] = data;
        dataAdd['StatusTask'] = data['task_status'];
        if (data['fsm_done'] == true) {
          updateDasboard.addDataDashboard(param: 'taskDikirim', tambah: true);
        }
        dataSave.add(dataAdd);
        getDetail(data['id']);

        await getFormWorksheet(data['id']);
        await getValueWork(data['id'], int.parse(userid ?? ""), false);
        // print("idtaskhistory");
        // print(idTaskHistory.length);
      }
      //delete value from task
      var boxOpenlistpekerjaan = Hive.box("box_listPekerjaan");
      var viewData = List.from(boxOpenlistpekerjaan.get(userid) ?? []);
      for (var value in viewData) {
        // print(value);
        idTaskHistory.add(value['data']['id'].toString());
      }
      deleteTaskDetail(idTaskHistory);
      deleteFormWorksheet(idTaskHistory);
      deleteValueWorksheet(idTaskHistory, userid);
      //close tag
      boxAddhistorytask.delete(userid);
      boxAddhistorytask.put(userid, dataSave);
      await boxOpenhistorytask.compact();
    }

    return true;
  }

  Future<void> markedPage({String? namePage}) async {
    print("namePage");
    print(namePage);
    final boxOpenmarkedpage = await Hive.openBox(nameBox!);
    if (boxOpenmarkedpage.isOpen) {
      final boxAddmarkedpage = Hive.box(nameBox!);
      if (boxAddmarkedpage.isNotEmpty) {
        boxAddmarkedpage.delete('markedPage');
      }
      boxAddmarkedpage.put("markedPage", namePage);
      await boxOpenmarkedpage.compact();
    }
  }

  Future<String> getMarkedPage() async {
    var namePage = "";
    final boxOpenmarkedpage = await Hive.openBox(nameBox!);
    if (boxOpenmarkedpage.isOpen) {
      final boxAddmarkedpage = Hive.box(nameBox!);

      if (boxOpenmarkedpage.isNotEmpty) {
        namePage = boxOpenmarkedpage.get("markedPage");
      }
      await boxOpenmarkedpage.compact();
    }
    return namePage;
  }

  getDetail(int taskid) async {
    TaskNetwork objTaskNetwork = TaskNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    if (cekKoneksi.Status) {
      Network objNetwork = await objTaskNetwork.getTaskDetail(TaskId: taskid);
      if (!objNetwork.Status) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(objNetwork.Message.toString())));
      } else {
        var result = objNetwork.Data;
        // print("result dari getdetail");
        // print(result);
        var boxDetaillist = await Hive.openBox("box_detailPekerjaan");
        final data = boxDetaillist.get(taskid.toString());

        if (boxDetaillist.isOpen) {
          var boxAdddetail = Hive.box("box_detailPekerjaan");

          if (boxDetaillist.isNotEmpty) {
            if (data == null) {
              boxAdddetail.put(taskid.toString(), result);
              // return result;
            } else {
              // use data

              result.forEach((i, value) {
                if (value != null && value != false && value != "") {
                  data[i] = result[i];
                }
              });
              boxAdddetail.delete(taskid.toString());
              boxAdddetail.put(taskid.toString(), data);
            }
          } else {
            boxAdddetail.put(taskid.toString(), result);
          }
          await boxDetaillist.compact();
        }
        // box_AddList.clear();
        // box_AddDetail.clear();
        //
        // var datas = objNetwork.Data;
      }
    }
  }

  deleteFormWorksheet(List idWorksheet) async {
    var WorksheetForm = await Hive.openBox("box_worksheetform");
    if (WorksheetForm.isOpen) {
      var boxAddworksheetform = Hive.box("box_worksheetform");
// WorksheetForm.containsKey(key)
      if (WorksheetForm.isNotEmpty) {
        for (var val in WorksheetForm.keys) {
          if (!idWorksheet.contains(val)) {
            boxAddworksheetform.delete(val);
            print("delete formworksheet success");
          }
        }
      }
    }
  }

  deleteTaskDetail(List idWorksheet) async {
    var WorksheetForm = await Hive.openBox("box_detailPekerjaan");
    if (WorksheetForm.isOpen) {
      var boxAddworksheetform = Hive.box("box_detailPekerjaan");
// WorksheetForm.containsKey(key)
      if (WorksheetForm.isNotEmpty) {
        for (var val in WorksheetForm.keys) {
          if (!idWorksheet.contains(val)) {
            boxAddworksheetform.delete(val);
            // box_AddWorksheetForm.delete("9071");
            print("delete detailTask success");
          }
        }
      }
    }
  }

  deleteValueWorksheet(List idWorksheet, String? userid) async {
    var WorksheetValue = await Hive.openBox("box_valworksheet");
    if (WorksheetValue.isOpen) {
      var boxAddworksheetvalue = Hive.box("box_valworksheet");
// WorksheetForm.containsKey(key)
      if (WorksheetValue.isNotEmpty) {
        var dataDelete = [];
        List data = List.from(WorksheetValue.get(userid));
        var dataTest = ['9071'];
        for (var value in data) {
          if (!idWorksheet.contains(value['taskid'])) {
            dataDelete.add(value);
          }
        }

        if (dataDelete.isNotEmpty) {
          for (var val in dataDelete) {
            print("val yang di delete");
            print(val);
            if (data.contains(val)) {
              data.remove(val);
            }
          }
        }

        dataDelete = [];
        WorksheetValue.delete(userid);

        boxAddworksheetvalue.put(userid, data);
        print("delete value has true success");
      }
    }
  }

  deleteNotif({String? taskid, String? userid}) async {
    final boxOpenlistmessage = await Hive.openBox("box_listMessages");

    if (boxOpenlistmessage.isOpen) {
      final boxAddmessage = Hive.box("box_listMessages");

      if (boxOpenlistmessage.isNotEmpty) {
        var dataLocal = List.from(boxOpenlistmessage.get(userid) ?? []);

        print("dataLocal");
        print(dataLocal);
        if (dataLocal.isNotEmpty) {
          //TODO remove ketika menyimpan task id null
          var remove = [];

          for (var del in dataLocal) {
            print(del['taskid']);
            print(del['taskid'].runtimeType);
            print(taskid.runtimeType);
            if (del['taskid'] == taskid) {
              dataLocal.remove(del);
              break;
            }
          }
          // dataLocal.removeWhere((element) => remove.contains(element));
          boxAddmessage.delete(userid);
          boxAddmessage.put(userid, dataLocal);
        } else {
          print("notif box from userid is empty");
        }
      } else {
        print("notif box is empty");
      }
    }
  }

  Future<bool> getFormWorksheet(int taskid) async {
    // Preferences pref = Preferences();
    // String userid = await pref.getUserId();
    WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    var WorksheetForm = await Hive.openBox("box_worksheetform");
    print("chekkkk ${cekKoneksi.Status} ${WorksheetForm.isOpen} ${WorksheetForm.isNotEmpty}");
    if (WorksheetForm.isOpen) {
      var boxAddworksheetform = Hive.box("box_worksheetform");

      if (WorksheetForm.isNotEmpty) {
        var data = WorksheetForm.get(taskid.toString());
              print("data gadapet ni worksheet form nya $data");

        if (data == null) {
          if (cekKoneksi.Status) {
            Network objNetwork =
                await objWorksheetNetwork.getWorksheetForm(TaskId: taskid);
            if (!objNetwork.Status) {
              print("gadapet ni worksheet form nya");
            } else {
              print("dapet ni worksheet form nya");

              boxAddworksheetform.put(taskid.toString(), objNetwork.Data);
              return true;
            }
          }

        } else {
          return true;
        }
      } else {

    print("chekkkkObjs ${cekKoneksi.Status}");
        if (cekKoneksi.Status) {
          Network objNetwork =
              await objWorksheetNetwork.getWorksheetForm(TaskId: taskid);
    print("chekkkkObjs2 ${objNetwork.Status}");

          if (!objNetwork.Status) {
            print("gadapet ni worksheet form nya");
            return false;
          } else {
            print("masuk objeeekk");
            boxAddworksheetform.put(taskid.toString(), objNetwork.Data);
            return true;
          }
        } else {
          return false;
        }
      }
      await WorksheetForm.compact();
    }
    return true;
  }

  Future<bool> getValueWork(int? taskid, int? userid, bool? handoff) async {
    print("handoffs $handoff");
    if (handoff == "false") {
      handoff = false;
    } else if (handoff == "true") {
      handoff = true;
    }
    var checkdata = await getValueWorksheet(
        userid: userid.toString(), taskid: taskid.toString());
    print("checkdataaaaaa $checkdata");

    if (checkdata == null) {
          print("objLoadNetwork.Status sebelum");
      WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
          print("objLoadNetwork.Status WorksheetNetwork");

      Network objLoadNetwork = await objWorksheetNetwork.LoadWorksheetForm(
          userId: userid ?? 0, taskId: taskid ?? 0, handoff: handoff!);
          print("objLoadNetwork.Status ${objLoadNetwork.Status}");
      if (!objLoadNetwork.Status) {
        print("getValueWork");
        print(objLoadNetwork.Status);
      } else {
        print("getValueWork berhasil");
      }
      return true;
    } else {
      return true;
    }
    return false;
  }

  UpdateListTask({
    String? userid,
    String? taskid,
    String? statusTask,
  }) async {
    final boxOpenlisttask = await Hive.openBox(nameBox!);
    List dataList = [];

    if (boxOpenlisttask.isOpen) {
      final boxAddlisttask = Hive.box(nameBox!);

      dataList = List.from(boxOpenlisttask.get(userid));

      if (dataList.isNotEmpty) {
        for (var value in dataList) {
          if (value['data']['id'].toString() == taskid) {
            value['StatusTask'] = statusTask;
            // print("datadatadata2");
            // print(value);
            // print(statusTask);
            // print(value);
            break;
          }
        }
      }
      boxAddlisttask.delete(userid);
      boxAddlisttask.put(userid, dataList);
      await boxOpenlisttask.compact();
    }
  }

  Future<bool> cekDataOnListUpload(String taskID) async {
    // print("taskid");
    // print(taskID);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    var listUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
    var addUploadWorksheet = Hive.box("box_listUploadWorksheet");
    bool checkData = false;
    if (listUploadWorksheet.isOpen) {
      List datalistUpload = List.from(listUploadWorksheet.get(userId) ?? []);
      //08082022
      // addUploadWorksheet.close();
      print("datalistUpload from cekdataonlistupload");
      print(datalistUpload);

      if (datalistUpload.isNotEmpty) {
        for (var value in datalistUpload) {
          if (value['taskid'] == taskID) {
            //delete this validation value['upload']
            // if (value['upload'] != 1) {
            print("value was found");
            print(value);
            break;
            // }
          }
        }
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> getDataOnListUpload(
      String taskID, String Status, String open) async {
    // print("taskid");
    // print(taskID);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    var listUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
    var addUploadWorksheet = Hive.box("box_listUploadWorksheet");
    bool checkData = false;
    if (listUploadWorksheet.isOpen) {
      List datalistUpload = listUploadWorksheet.get(userId);
      //08082022
      // addUploadWorksheet.close();
      print("datalistUpload from cekdataonlistupload");
      print(datalistUpload);

      if (datalistUpload.isNotEmpty) {
        for (var value in datalistUpload) {
          if (value['taskid'] == taskID) {
            print("value was found");
            print(value);
            break;
          }
        }
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  Future<bool> cekExistDataOnListUpload() async {
    // print("taskid");
    // print(taskID);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userId = await boxdata.getLoginCredential(param: "userId");
    var listUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
    var addUploadWorksheet = Hive.box("box_listUploadWorksheet");

    if (listUploadWorksheet.isOpen) {
      List datalistUpload = List.from(listUploadWorksheet.get(userId) ?? []);
      //08082022
      // addUploadWorksheet.close();
      print(datalistUpload);

      if (datalistUpload.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    return false;
    // return true;
  }

  addUploadListTask({
    required String userId,
    required String taskId,
    required String status,
    required String timesheetDate,
    required String timesheetDesc,
    required int timesheetDuration,
    required int open,
  }) async {
    // var AddlistUploadWorksheet = Hive.box("box_listUploadWorksheet");

    var OpenlistUploadWorksheet = await Hive.openBox(nameBox!);
    // var OpenlistUploadWorksheet =
    //     await Hive.openBox("box_listUploadWorksheet");
    bool checkData = false;
    int Id = 1;
    if (OpenlistUploadWorksheet.isOpen) {
      var AddlistUploadWorksheet = Hive.box(nameBox!);

      if (OpenlistUploadWorksheet.isNotEmpty) {
        var dataUploadList =
            List.from(OpenlistUploadWorksheet.get(userId) ?? []);
        Id = dataUploadList.length + 1;
        print(userId);
        print("taskId");
        print(taskId);
        print(status);

        print(timesheetDate);
        print(timesheetDesc);
        print(timesheetDuration);
        print(open);
        dataUploadList.add({
          "id": Id,
          "upload": 0,
          "taskid": taskId,
          "status": status,
          "timesheet_date": timesheetDate,
          "timesheet_description": timesheetDesc,
          "timesheet_duration": timesheetDuration,
          "open": open
        });
        print(dataUploadList.last);
        AddlistUploadWorksheet.delete(userId);
        AddlistUploadWorksheet.put(userId, dataUploadList);
      } else {
        AddlistUploadWorksheet.put(userId, [
          {
            "id": Id,
            "upload": 0,
            "taskid": taskId,
            "status": status,
            "timesheet_date": timesheetDate,
            "timesheet_description": timesheetDesc,
            "timesheet_duration": timesheetDuration,
            "open": open
          }
        ]);
      }
      await OpenlistUploadWorksheet.compact();
    }
  }

  Future<bool> replaceUploadListTask({
    required int id,
    required int upload,
    required String userId,
    required String taskId,
  }) async {
    var AddlistUploadWorksheet = Hive.box("box_listUploadWorksheet");

    var OpenlistUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
    if (OpenlistUploadWorksheet.isOpen) {
      var dataUploadList = List.from(OpenlistUploadWorksheet.get(userId) ?? []);

      for (var val in dataUploadList) {
        if (val['id'] == id) {
          val['upload'] = upload;
          break;
        }
      }
      AddlistUploadWorksheet.delete(userId);
      AddlistUploadWorksheet.put(userId, dataUploadList);
      await OpenlistUploadWorksheet.compact();
    }
    return true;
  }

  deleteItemUploadListTask({
    required int id,
    required String userId,
  }) async {
    var OpenlistUploadWorksheet = await Hive.openBox("box_listUploadWorksheet");
    if (OpenlistUploadWorksheet.isOpen) {
      var AddlistUploadWorksheet = Hive.box("box_listUploadWorksheet");

      var dataUploadList = OpenlistUploadWorksheet.get(userId.toString()) ?? [];
      List remove = [];
      for (var val in dataUploadList) {
        if (val['id'] == id) {
          remove.add(val);
          print("data has been deleted");
          print(val);
          break;
        }
      }
      for (var val in remove) {
        dataUploadList.remove(val);
      }
      print(dataUploadList);
      AddlistUploadWorksheet.delete(userId.toString());
      AddlistUploadWorksheet.put(userId.toString(), dataUploadList);
      await OpenlistUploadWorksheet.compact();
    }
  }

  setLoginCredential(
      {required String secretKey,
      required String token,
      required String Phone,
      required String UserId,
      required String Otp}) async {
    await Hive.openBox("box_setLoginCredential");

    var OpensetLoginCredential = await Hive.openBox("box_setLoginCredential");
    var data = {};
    data['secretKey'] = secretKey;
    data['token'] = token;
    data['phone'] = Phone;
    data['userId'] = UserId;
    data['otp'] = Otp;
    if (OpensetLoginCredential.isOpen) {
      // print('kesinii loh');
      print("$secretKey $token $Phone $UserId $Otp");
      var AddsetLoginCredential = Hive.box("box_setLoginCredential");

      AddsetLoginCredential.put("credential", data);
//08082022
      // AddsetLoginCredential.close();
    }
  }

  deleteLoginCredential() async {
    var OpensetLoginCredential = await Hive.openBox("box_setLoginCredential");

    if (OpensetLoginCredential.isOpen) {
      var AddsetLoginCredential = Hive.box("box_setLoginCredential");

      var data = {};
      data['secretKey'] = "";
      data['token'] = "";
      data['phone'] = "";
      data['userId'] = "";
      data['otp'] = "";
      AddsetLoginCredential.delete('credential');
      AddsetLoginCredential.put("credential", data);
      // AddsetLoginCredential.close();
    }
  }

  Future<String> getLoginCredential({required String param}) async {
    await Hive.openBox("box_setLoginCredential");
    var OpensetLoginCredential = await Hive.openBox("box_setLoginCredential");
    if (OpensetLoginCredential.isOpen) {
      var AddsetLoginCredential = Hive.box("box_setLoginCredential");

      if (OpensetLoginCredential.isNotEmpty) {
        // print('keisini');
        Map data = Map.from(OpensetLoginCredential.get("credential"));
        //08082022
        // AddsetLoginCredential.close();
        final result = data[param];

        return result;
      }
    }
    return "";
  }

//model data
/*
[~$
  {
  "taskid": 1,
  "data": {"tabBar": 0, "pause": "", "btnname": "", "page2": 0}
  },{
  "taskid": 2,
  "data": {"tabBar": 0, "pause": "", "btnname": "", "page2": 0}
  },{
  "taskid": 3,
  "data": {"tabBar": 0, "pause": "", "btnname": "", "page2": 0}
  },{
  "taskid": 4,
  "data": {"tabBar": 0, "pause": "", "btnname": "", "page2": 0}
  }
  ]
  */
}
