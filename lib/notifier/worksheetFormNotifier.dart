import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../model/mNetwork.dart';
import '../network/CheckDataConnection.dart';
import '../network/worksheet.dart';
import 'package:flutter/painting.dart';
import '../utils/boxData.dart';

class clsWorkshop {
  bool? header;
  dynamic page;
  dynamic type;
  dynamic name;
  dynamic text;
  dynamic input;

  List<dynamic> data = [];
  dynamic relation;
}

class workSheetFormNotifier extends ChangeNotifier {
  late int taskId;
  dynamic Task;
  dynamic statusTask;
  bool? lastSavedUser = false;
  dynamic dataFormPure = null;
  int tresholdPartDiganti = 5;
  int page = 1;
  Map<String, dynamic> dataArr = {};
  dynamic objData = null;
  dynamic objLoadData = null;
  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userid = "";
  workSheetFormNotifier(this.Task, this.statusTask) {
    init();
  }

  init() async {
    print("Task");
    print(Task);

    userid = await boxdata.getLoginCredential(param: "userId");
    objData = await getAllData();

    notifyListeners();
  }

  listDataLocal() => objLoadData;
  lastSaved() => lastSavedUser;
  listKey() => dataArr;
  listValue() => objData;
  listPage() => page;
  getDataFormPure() => dataFormPure;
  getTresholdPart() => tresholdPartDiganti;
  updateList() async {
    tresholdPartDiganti++;

    objData = await getAllData();
  }

  Future<List<dynamic>> getAllData() async {
    WorksheetNetwork objWorksheetNetwork = WorksheetNetwork();
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    var WorksheetForm = await Hive.openBox("box_worksheetform");
    var box_AddWorksheetForm = Hive.box("box_worksheetform");

    if (cekKoneksi.Status && statusTask == "Open") {
      //view di worksheet ketika di trigger dari ambil pekerjaan/pop up message/list messages
      //load from server
      // await _loadValueData(objWorksheetNetwork);
      int dataTaskId = 0;
      if (Task["id"].runtimeType == String) {
        dataTaskId = int.parse(Task["id"]);
      }
      if (Task["id"].runtimeType == int) {
        dataTaskId = Task["id"];
      }
      Network objNetwork =
          await objWorksheetNetwork.getWorksheetForm(TaskId: dataTaskId);
      if (!objNetwork.Status) {
        print("cek status");
      } else {
        await _getLoadDataFromServer(objWorksheetNetwork, int.parse(userid));
        dataFormPure = objNetwork.Data;
        objData = WorkSheetArrayData(objNetwork.Data);
        return objData;
      }
    }
    // else {
    //TODO cek update terakhir
    int int_taskid;
    if (Task["id"].runtimeType == String) {
      int_taskid = int.parse(Task['id']);
    } else {
      int_taskid = Task['id'];
    }
    if (cekKoneksi.Status && statusTask == "OnGoing") {
      print('last saved executed');
      lastSavedUser = await objWorksheetNetwork.ceklastSaved(
          userid: int.parse(userid), taskid: int_taskid);
    }

    //close tag
    //TODO ambil load data di lokal
    await _loadValueData(objWorksheetNetwork);
    //

    if (WorksheetForm.isNotEmpty) {
      final data = WorksheetForm.get(Task["id"].toString());
      // use data
      // var data = data;
      objData = WorkSheetArrayData(data);
    } else {
      //
    }
    // }

    return objData;
  }

  Future _getLoadDataFromServer(
      WorksheetNetwork objWorksheetNetwork, int userId) async {
    int dataTaskId = 0;
    if (Task["id"].runtimeType == String) {
      dataTaskId = int.parse(Task["id"]);
    }
    if (Task["id"].runtimeType == int) {
      dataTaskId = Task["id"];
    }
    Network objLoadNetwork = await objWorksheetNetwork.LoadWorksheetForm(
        userId: userId, taskId: dataTaskId, autoSaveLocal: false);
    if (!objLoadNetwork.Status) {
      print("gadapet ni load worksheetform line 99");
      print(objLoadNetwork.Status);
    } else {
      objLoadData = await objLoadNetwork.Data;
    }
    return objLoadData;
  }

  _loadValueData(WorksheetNetwork objWorksheetNetwork) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String userid = await boxdata.getLoginCredential(param: "userId");
    //ambil load data di lokal
    var WorksheetForm = await Hive.openBox("box_valworksheet");

    if (WorksheetForm.isNotEmpty) {
      final data = WorksheetForm.get(userid);

      if (data == null) {
        // await _getLoadDataFromServer(objWorksheetNetwork, userid);
      } else {
        print('ambil value worksheet dari db lokal');
        final objBoxData = boxData(nameBox: 'box_valworksheet');
        objLoadData = await objBoxData.getValueWorksheet(
            userid: userid, taskid: Task['id'].toString());
        WorksheetForm.close();
        // for (var value in data) {
        //   if (value['taskid'] == Task["id"].toString()) {
        //     objLoadData = value['data'];
        //     print(Task["id"]);
        //     print(value['taskid']);
        //     print(value['data']);
        //     break;
        //   }
        // }
      }
    } else {
      // await _getLoadDataFromServer(objWorksheetNetwork, userid);
    }

    //code lama
    // //ambil load data di lokal
    // var WorksheetForm = await Hive.openBox("box_valworksheet");
    // if (WorksheetForm.isNotEmpty) {
    //   final data = WorksheetForm.get(Task["id"].toString());
    //   if (data == null) {
    //     await _getLoadDataFromServer(objWorksheetNetwork, userid);
    //   } else {
    //     objLoadData = data;
    //   }
    // } else {
    //   await _getLoadDataFromServer(objWorksheetNetwork, userid);
    // }

    //
  }

  bool getHeaderStatus(String nameOfField) {
    bool Header = false;
    List unitKecil = [
      "x_studio_warehouse__1",
      "x_studio_no_",
      "x_studio_nama_outlet_",
      "x_studio_alamat_",
      "x_studio_kota_",
      "x_studio_kode_pos_",
      "x_studio_pemilik_unit_",
      "x_studio_merk_",
      "x_studio_unit_",
      "x_studio_type_",
      "x_studio_logo_",
      "x_studio_model_",
      "x_studio_no_seri_",
      "x_studio_kategori_unit_",
      "x_studio_no_registrasi_",
      // "x_studio_no_registrasi_pengganti_",

      //list header unit besar
      "x_studio_contoh_related_filed",
      // "x_studio_nama_outlet_",
      // "x_studio_alamat_",
      // "x_studio_pemilik_unit_",
      // 3 data list diatas ini di comment karena nama fieldnya sama dengan yang ada di unit kecil
      "x_studio_no_tlp_",
      "x_studio_type_unit_",
      // list header lainnyaa dibawah ini
    ];

    //jika nama field sama pakai list unit kecil, jika namafield beda,gabung jadi satu list aja, sementara di gabung
    List unitBesar = [
      "x_studio_nama_outlet_",
      "x_studio_alamat_",
      "x_studio_pemilik_unit_",
      "x_studio_no_tlp_",
      "x_studio_type_unit_",
    ];

    for (var i = 0; i < unitKecil.length; i++) {
      if (nameOfField == unitKecil[i]) {
        return true;
      }
    }

    return false;
  }

  // String getCapitalizeString({String? str}) {
  //   if (str!.length <= 1) {
  //     return str.toUpperCase();
  //   }
  //   return '${str[0].toUpperCase()}${str.substring(1)}';
  // }

  String titleCase({String? str}) {
    var splitStr = str!.toLowerCase().split(' ');

    for (var i = 0; i < splitStr.length; i++) {
      // You do not need to check if i is larger than splitStr length, as your for does that for you
      // Assign it back to the array
      if (splitStr[i].length != 0) {
        splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
      }
    }
    // Directly return the joined string
    return splitStr.join(' ');
  }

  WorkSheetArrayData(dynamic objArray) {
    List<clsWorkshop> lstClsWorkshop = [];

    objArray.forEach((entitlement) {
      if (entitlement is List<dynamic>) {
        // print("list worksheet array");
        List<clsWorkshop> tmpWidget = WorkSheetArrayData(entitlement);
        tmpWidget.forEach((objData) {
          lstClsWorkshop.add(objData);
        });
      } else if (entitlement.containsKey("child") &&
          entitlement['child'].length != 0) {
        clsWorkshop objClsWorkshop = clsWorkshop();
        objClsWorkshop.type = entitlement["type"];
        objClsWorkshop.header = false;
        if (entitlement["name"].toString() == "studio_group_5t9Rg_right") {
          page = 2;
        } else {
          page = 1;
        }
        objClsWorkshop.page = page;
        if (entitlement["text"] != null) {
          objClsWorkshop.text = entitlement["text"];
          objClsWorkshop.name = entitlement["name"];
        } else {
          if (!entitlement['name'].contains('after') &&
              entitlement['name'].contains('x_studio_')) {
            objClsWorkshop.text = titleCase(
                    str: entitlement["name"]
                        .replaceAll('x_studio_', '')
                        .replaceAll('after', '')
                        .replaceAll('_', ' ')) +
                " :";
          } else if (entitlement['name'].contains('after')) {
            objClsWorkshop.text = titleCase(
                str: entitlement["name"]
                    .replaceAll('x_studio_', '')
                    .replaceAll('after', '')
                    .replaceAll('_', ' '));
          }
          if (entitlement['name'] == 'x_studio_after') {
            objClsWorkshop.text = entitlement['text'];
          }
        }

        // objClsWorkshop.text = entitlement["text"] ?? "--";
        lstClsWorkshop.add(objClsWorkshop);
        if (entitlement['child'] is List<dynamic>) {
          List<clsWorkshop> tmpWidget =
              WorkSheetArrayData(entitlement['child']);
          tmpWidget.forEach((objData) {
            lstClsWorkshop.add(objData);
          });
        }
      } else {
        clsWorkshop objClsWorkshop = clsWorkshop();

        if (entitlement["name"].toString() == "x_studio_after" ||
            entitlement["name"].toString() == "x_studio_pic_" ||
            entitlement["name"].toString() == "x_studio_saran" ||
            entitlement["name"].toString() == "x_studio_customer_1" ||
            entitlement["name"].toString() ==
                "x_studio_foto_sekitar_cold_storage_1_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_sekitar_cold_storage_2_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_ruang_anteroom_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_ruang_genset_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_lorong_freezer_1_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_lorong_freezer_2_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_lorong_freezer_3_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_ruang_mesin_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_1_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_2_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_3_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_4_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_5_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_6_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_7_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_8_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_9_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_10_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_11_after" ||
            entitlement["name"].toString() ==
                "x_studio_foto_cold_storage_lainnya_12_after" ||
            entitlement["name"].toString() == "x_studio_teknisi" ||
            entitlement["name"].toString() == "x_studio_customer") {
          page = 2;
        } else {
          page = 1;
        }

//disable field header
        var header = getHeaderStatus(entitlement["name"]);
        entitlement["header"] = header;
        objClsWorkshop.header = header;

        //
        objClsWorkshop.text = entitlement["text"];
        if (!entitlement['name'].contains('after') &&
            (entitlement['text'] == null || entitlement['text'] == " ") &&
            entitlement['name'].contains('x_studio_')) {
          objClsWorkshop.text = titleCase(
                  str: entitlement["name"]
                      .replaceAll('x_studio_', '')
                      .replaceAll('after', '')
                      .replaceAll('_', ' ')) +
              " :";
        } else if (entitlement['name'].contains('after')) {
          objClsWorkshop.text = titleCase(
              str: entitlement["name"]
                  .replaceAll('x_studio_', '')
                  .replaceAll('after', '')
                  .replaceAll('_', ' '));
        }
        if (entitlement['name'] == 'x_studio_after') {
          objClsWorkshop.text = entitlement['text'];
        }
        objClsWorkshop.page = page;

        objClsWorkshop.type = entitlement["type"];
        objClsWorkshop.name = entitlement["name"];
        objClsWorkshop.input = entitlement["input"] ?? "";
        objClsWorkshop.data = entitlement["data"] ?? [];
        objClsWorkshop.relation = entitlement["relation"] ?? "";
        _insertDatatoWidget(entitlement);

        lstClsWorkshop.add(objClsWorkshop);
      }
    });

    return lstClsWorkshop;
  }

  Future<dynamic> _insertDatatoWidget(dynamic entitlement) async {
    if (entitlement["header"]) {
      // if (objLoadData != null) {
      if (objLoadData[entitlement["name"]] != false) {
        dataArr[entitlement["name"]] = objLoadData[entitlement["name"]];
        return dataArr;
      } else {
        dataArr[entitlement["name"]] = "";
      }
    } else if (!entitlement["header"]) {
      if (entitlement['input'] == "char" ||
          entitlement['input'] == "text" ||
          entitlement['input'] == "date" ||
          entitlement['input'] == "datetime" ||
          entitlement['input'] == "float" ||
          entitlement['input'] == "integer") {
        if (objLoadData != null && objLoadData[entitlement["name"]] != false) {
          if (entitlement['input'] == "date") {
            DateTime dt = DateTime.parse(objLoadData[entitlement["name"]]);
            final tanggal = DateFormat('dd/MM/yyyy').format(dt);
            dataArr[entitlement["name"]] =
                TextEditingController(text: tanggal.toString());
            return dataArr;
          } else if (entitlement['input'] == "datetime") {
            DateTime dt = DateTime.parse(objLoadData[entitlement["name"]]);
            // final tanggal = DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
            final tanggal = DateFormat('dd/MM/yyyy').format(dt);
            dataArr[entitlement["name"]] =
                TextEditingController(text: tanggal.toString());
            return dataArr;
          } else if (entitlement['input'] == "float" ||
              entitlement['input'] == "integer") {
            dataArr[entitlement["name"]] = TextEditingController(
                text: objLoadData[entitlement["name"]].toString());
            return dataArr;
          } else {
            dataArr[entitlement["name"]] =
                TextEditingController(text: objLoadData[entitlement["name"]]);
            return dataArr;
          }
        } else {
          if (entitlement['input'] == "date") {
            final tanggal = DateFormat('dd/MM/yyyy').format(DateTime.now());
            objLoadData[entitlement["name"]] =
                DateFormat('yyyy-MM-dd').format(DateTime.now());
            dataArr[entitlement["name"]] = TextEditingController(text: tanggal);
            return dataArr;
          } else if (entitlement['input'] == "datetime") {
            // final tanggal =
            //     DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
            final tanggal = DateFormat('dd/MM/yyyy').format(DateTime.now());
            objLoadData[entitlement["name"]] =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            dataArr[entitlement["name"]] = TextEditingController(text: tanggal);
            return dataArr;
          } else {
            dataArr[entitlement["name"]] = TextEditingController();
            return dataArr;
          }
        }
      } else if (entitlement['input'] == "selection") {
        if (objLoadData != null && objLoadData[entitlement["name"]] != false) {
          String getdata = "";
          List options = entitlement["data"];
          for (var i = 0; i < options.length; i++) {
            if (options[i]['value'] == objLoadData[entitlement["name"]]) {
              getdata = options[i]['name'];
              break;
            }
          }
          dataArr[entitlement["name"]] = [
            objLoadData[entitlement["name"]],
            getdata
          ];
          return dataArr;
        } else {
          dataArr[entitlement["name"]] = [];
          return dataArr;
        }
      } else if (entitlement['input'] == "boolean") {
        if (objLoadData != null && objLoadData[entitlement["name"]] != false) {
          dataArr[entitlement["name"]] = objLoadData[entitlement["name"]];
        } else {
          dataArr[entitlement["name"]] = false;
        }
        return dataArr;
      } else if (entitlement['input'] == "many2one" ||
          entitlement['input'] == "one2many" ||
          entitlement['input'] == "many2many") {
        // List<dynamic> options = [];
        List<dynamic> product = [];
        List<dynamic> garansi = [];
        String getdata = "";
        // var WorksheetForm = await Hive.openBox("box_listMaster");
        var masterProduct = await Hive.openBox("box_masterProduct");
        var masterGaransi = await Hive.openBox("box_masterGaransi");
        if (entitlement['relation'] == 'product.product') {
          if (masterProduct.isNotEmpty) {
            product = masterProduct.get('product');
            // options = WorksheetForm.get('master'.toString());

            for (var i = 0; i < product.length; i++) {
              if (objLoadData[entitlement["name"]] == product[i]['id']) {
                getdata =
                    "[${product[i]['default_code']}] ${product[i]['name']}";
                break;
              } else {}
            }
          } else {
            //kondisi jk boxnya kosong
            print("box list master product masih kosong ");
          }
        } else if (entitlement['relation'] == 'isd.warranty.term') {
          if (masterGaransi.isNotEmpty) {
            product = masterProduct.get('product');

            garansi = masterGaransi.get('garansi');

            for (var i = 0; i < garansi.length; i++) {
              if (objLoadData[entitlement["name"]] == garansi[i]['id']) {
                print("garansi[i]['name']");
                print(garansi[i]['name']);
                getdata = "${garansi[i]['name']}";
                break;
              } else if (objLoadData[entitlement["name"]] == false) {
                if (garansi[i]['name'] == "Default") {
                  objLoadData[entitlement["name"]] = garansi[i]['id'];
                  getdata = "${garansi[i]['name']}";
                }

                // print('default coba');
                //error ini bisa muncul karena entitlement.text nya null
                print("data objload atau option bermasalah line 382");
                // break;
              }
            }
          } else {
            //kondisi jk boxnya kosong
            print("box list garansi  masih kosong ");
          }
        }
        //
        if (objLoadData != null && objLoadData[entitlement["name"]] != false) {
          dataArr[entitlement["name"]] = [
            objLoadData[entitlement["name"]],
            getdata
          ];
          return dataArr;
        } else {
          // print('ini kepanggil karena tombol plus');
          dataArr[entitlement["name"]] = [];
          return dataArr;
        }
      } else if (entitlement['input'] == "binary") {
        if (objLoadData != null && objLoadData[entitlement["name"]] != false) {
          dataArr[entitlement["name"]] = File(await _createFileFromString(
              objLoadData[entitlement["name"]],
              Task['id'].toString(),
              entitlement["text"]));
          // await _createFileFromString(objLoadData[entitlement["name"]]);
          return dataArr;
        } else {
          dataArr[entitlement["name"]] = File("");
          return dataArr;
        }
      }
      // }
      //TODO:ini klo textnya udh ga ada yg null dihapus aja elsenya
      // else {
      //   if (entitlement['input'] == "many2one" ||
      //       entitlement['input'] == "one2many" ||
      //       entitlement['input'] == "many2many") {
      //     List<dynamic> options = [];
      //     List<dynamic> master = [];
      //     String getdata = "";
      //     var WorksheetForm = await Hive.openBox("box_listMaster");
      //     if (WorksheetForm.isNotEmpty) {
      //       master = WorksheetForm.get('master'.toString());
      //       if (entitlement['relation'] == 'product.product') {
      //         // options = WorksheetForm.get('master'.toString());
      //
      //         for (var i = 0; i < (master[0]['product']).length; i++) {
      //           if (objLoadData[entitlement["name"]] ==
      //               (master[0]['product'])[i]['id']) {
      //             getdata =
      //                 "[${(master[0]['product'])[i]['default_code']}] ${(master[0]['product'])[i]['name']}";
      //             break;
      //           } else {
      //             //error ini bisa muncul karena entitlement.text nya null
      //             // print("data objload atau option bermasalah line 228");
      //             // break;
      //           }
      //         }
      //       } else if (entitlement['relation'] == 'isd.warranty.term') {
      //         print("garansi 374");
      //         options = WorksheetForm.get('master'.toString());
      //
      //         for (var i = 0; i < (master[0]['garansi']).length; i++) {
      //           if (objLoadData[entitlement["name"]] ==
      //               (master[0]['garansi'])[i]['id']) {
      //             getdata = "${(master[0]['garansi'])[i]['name']}";
      //             break;
      //           } else {
      //             //error ini bisa muncul karena entitlement.text nya null
      //             print("data objload atau option bermasalah line 382");
      //             // break;
      //           }
      //         }
      //       }
      //     } else {
      //       //kondisi jk boxnya kosong
      //       print("box masih kosong ");
      //     }
      //
      //     //
      //     if (objLoadData != null &&
      //         objLoadData[entitlement["name"]] != false) {
      //       dataArr[entitlement["name"]] = [
      //         objLoadData[entitlement["name"]],
      //         getdata
      //       ];
      //       return dataArr;
      //     } else {
      //       dataArr[entitlement["name"]] = [];
      //       return dataArr;
      //     }
      //   } else if (entitlement['input'] == "selection") {
      //     if (objLoadData != null &&
      //         objLoadData[entitlement["name"]] != false) {
      //       String getdata = "";
      //       List options = entitlement["data"];
      //       for (var i = 0; i < options.length; i++) {
      //         if (options[i]['value'] == objLoadData[entitlement["name"]]) {
      //           getdata = options[i]['name'];
      //           break;
      //         }
      //       }
      //       dataArr[entitlement["name"]] = [
      //         objLoadData[entitlement["name"]],
      //         getdata
      //       ];
      //       return dataArr;
      //     } else {
      //       dataArr[entitlement["name"]] = [];
      //       return dataArr;
      //     }
      //   } else if (entitlement['input'] == "boolean") {
      //     if (objLoadData != null &&
      //         objLoadData[entitlement["name"]] != false) {
      //       dataArr[entitlement["name"]] = objLoadData[entitlement["name"]];
      //     } else {
      //       dataArr[entitlement["name"]] = false;
      //     }
      //     return dataArr;
      //   }
      // }
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  _createFileFromString(String data, String taskid, String nameField) async {
    Uint8List bytes = base64.decode(data);
    // print("nameField");
    // print(nameField);
    final tanggal = DateFormat('dd').format(DateTime.now());
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File("$dir/" + userid + taskid + nameField + ".png");
    // File file = File("$dir/" + userid + taskid + nameField + tanggal + ".png");
    if (!file.existsSync()) {
      // print("file gambar tidak ada,maka file dapat dibuat");
      file.writeAsBytes(bytes);
    } else {
      // print("file di delete baru di create lagi");
      file.deleteSync();
      imageCache!.clear();
      // _createFileFromString(data, taskid, nameField);
      if (!file.existsSync()) {
        //   print("file gambar tidak ada,maka file dapat dibuat");
        file.writeAsBytes(bytes);
      }
    }

    return file.path;
  }
}

Future<bool> checkFile(String nameField, dynamic task) async {
  final boxdata = boxData(nameBox: "box_setLoginCredential");

  String userid = await boxdata.getLoginCredential(param: "userId");

  String dir = (await getApplicationDocumentsDirectory()).path;
  File file =
      File("$dir/" + userid + task['id'].toString() + nameField + ".png");
  if (file.existsSync()) {
    return true;
  } else {
    return false;
  }
}
