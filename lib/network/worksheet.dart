import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:pit/helpers/app_helper.dart';

import 'package:pit/model/mNetwork.dart';
import 'package:pit/helpers/odoo.dart';

import '../utils/boxData.dart';

class WorksheetNetwork {
  // final String _Url = "https://testpit.odoo.com"; //staging
  // final String _Url = "http://103.195.30.141:8069"; //dev
  final String _Url = AppConfig().getBaseUrl(); //production
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<Network> getWorksheetForm({required int TaskId}) async {
      OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
        dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "method": "call",
      "jsonrpc": "2.0",
      "params": {"taskid": TaskId}
    };

    try {

    print('objParam get worksheet form ${objParam}');
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/worksheet/form'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
  print("strResultsebelum");

    http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 10));
  print("strResultsesudah ${response.statusCode}");
    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      print("strResult $strResult");
      if (strResult != "") {
        objNetwork = await objOdooServer.getValidateApiResponse(
            strResult, "worksheet/form");
      }
    }

    return objNetwork;
    } catch (e) {
      print("errrorr apa a $e");
      return objNetwork;
    }
  }

  Future<Network> saveWorksheetForm({
    int? Id = 0,
    required int userId,
    required int taskId,
    required Map<String, dynamic> worksheet,
    required String status,
    bool manualSave = true,
    String timesheetDate = "",
    String timesheetDesc = "",
    int timesheetDuration = 0,
    int open = 0,
  }) async {
    //param status, untuk memberitahukan status worksheet done cheking atau done fixing
    //param open, digunakan untuk menandakan pekerjaan open atau close(diambil)
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    // Connection objCekConnection = Connection();
    // Network cekKoneksi = await objCekConnection.CheckConnection();
    var dataBox = boxData(nameBox: "box_listUploadWorksheet");
    print("Cek Koneksi saveworkshett line 80 ${worksheet}");
    // print('hasilnya: $cekKoneksi');
    // if (cekKoneksi.Status) {
    dynamic objParam = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    if (open == 1) {
      {
        //kondisi ini ketika teknisi menyerahkan pekerjaan
        objParam = {
          "jsonrpc": "2.0",
          "params": {
            "userid": userId,
            "taskid": taskId,
            "status": status,
            "taskopen": true,
            "worksheet": worksheet
          }
        };
      }
    } else {
      if (timesheetDate != "" &&
          timesheetDesc != "" &&
          timesheetDuration != 0) {
        // if (status != "") {
        //kondisi ini ketika ada data pencatatan timesheet
        objParam = {
          "jsonrpc": "2.0",
          "params": {
            "userid": userId,
            "taskid": taskId,
            "status": status,
            "timesheet_date": timesheetDate,
            "timesheet_description": timesheetDesc,
            "timesheet_duration": timesheetDuration,
            "worksheet": worksheet
          }
        };
      } else {
        if (status == "3") {
          objParam = {
            "jsonrpc": "2.0",
            "params": {
              "userid": userId,
              "taskid": taskId,
              "status": "2",
              "taskcompelete": true,
              "worksheet": worksheet
            }
          };
        } else {
          objParam = {
            "jsonrpc": "2.0",
            "params": {
              "userid": userId,
              "taskid": taskId,
              "status": status,
              "worksheet": worksheet
            }
          };
        }
      }
    }

    print('objParam line 125 dari file saveworksheet.dart ${objParam}');
    objNetwork =
        Network(Status: false, Message: json.encode(objParam).toString());
    // print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/worksheet/save'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    //init box list upload
    var boxAddlistuploadworksheet = Hive.box("box_listUploadWorksheet");

    var boxOpenlistuploadworksheet =
        await Hive.openBox("box_listUploadWorksheet");
    // if (!manualSave && Id != 0) {
    //   dataBox.replaceUploadListTask(
    //     id: Id!,
    //     upload: 1,
    //     userId: userId.toString(),
    //     taskId: taskId.toString(),
    //   );
    //   // box_AddlistUploadWorksheet.put(index, {
    //   //   "upload": 1,
    //   //   "userid": userId,
    //   //   "taskid": taskId,
    //   //   "status": status,
    //   //   "timesheet_date": timesheetDate,
    //   //   "timestheet_description": timesheetDesc,
    //   //   "timestheet_duration": timesheetDuration,
    //   //   "open": open
    //   // });
    // }

    try {
      if (!manualSave) {
        print("request send task id $Id");

        // await dataBox.replaceUploadListTask(
        //   id: Id ?? 0,
        //   upload: 1,
        //   userId: userId.toString(),
        //   taskId: taskId.toString(),
        // );
      }
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();

        if (strResult != "") {
          print('strResult line 41 dari file worksheetsave.dart');
          print(strResult);

//update status upload task jadi 1 (udah di upload)

          //
          if (status == "3" && open != 1 && timesheetDesc == "") {
            // var updateDasboard = boxData(nameBox: 'box_dashboard');
            //
            // updateDasboard.addDataDashboard(
            //     param: 'selesaiAll', tambah: true);
          }

          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "worksheet/save");
          print("objNetwork.Message dari saveworksheet line 175");
          print(objNetwork.Message);
          print(objNetwork.Status);

          if (objNetwork.Status == true) {
            //delete item on list upload
            if (!manualSave && Id != 0) {
              dataBox.deleteItemUploadListTask(
                  id: Id!, userId: userId.toString());
            }
            // ganti status task di ongoing ke history
            var boxAddlist = Hive.box("box_listPekerjaan");
            //open box list pekerjaan
            var boxOpenlistpekerjaan = await Hive.openBox("box_listPekerjaan");

            //

            //update data dashboard
            if (status == "3") {
              //changed
              final data = boxOpenlistpekerjaan.get(userId);
              final updateList = boxData(nameBox: 'box_listPekerjaan');

              updateList.UpdateListTask(
                  userid: userId.toString(),
                  taskid: taskId.toString(),
                  statusTask: 'Completed');

              //changed

              // var updateDasboard = boxData(nameBox: 'box_dashboard');
              // //
              // updateDasboard.addDataDashboard(
              //     param: 'taskDikirim', tambah: true);
              // updateDasboard.addDataDashboard(
              //     param: 'taskPendingKirim', tambah: false);
            }
          } else {
            print("objNetwork status false when send data to server");
            // //koneksi ada tapi gagal kirim, simpan data yg akan disaving ke lokal

            // if (manualSave) {
            final boxdata = boxData(nameBox: "box_listUploadWorksheet");
            bool checkData =
                await boxdata.cekDataOnListUpload(taskId.toString());

            if (checkData) {
              // dataBox.replaceUploadListTask(
              //   id: Id!,
              //   upload: 0,
              //   userId: userId.toString(),
              //   taskId: taskId.toString(),
              // );
              // box_AddlistUploadWorksheet.put(index!, {
              //   "upload": 0,
              //   "userid": userId,
              //   "taskid": taskId,
              //   "status": status,
              //   "timesheet_date": timesheetDate,
              //   "timestheet_description": timesheetDesc,
              //   "timestheet_duration": timesheetDuration,
              //   "open": open
              // });
            } else {
              // dataBox.addUploadListTask(
              //     userId: userId.toString(),
              //     taskId: taskId.toString(),
              //     status: status,
              //     timesheetDate: timesheetDate,
              //     timesheetDesc: timesheetDesc,
              //     timesheetDuration: timesheetDuration,
              //     open: open);
            }

            // } else {
            //   print('push data to server worksheet/save has trobble');
            //   print(objNetwork.Data);
            // }
          }
        }
      } else {
        print("response selain status code 200");
        // if (!manualSave && Id != 0) {
        //   dataBox.replaceUploadListTask(
        //     id: Id!,
        //     upload: 0,
        //     userId: userId.toString(),
        //     taskId: taskId.toString(),
        //   );
        // }
      }
    } catch (e) {
      print("data error when send save worksheet");
      print(e);
      if (manualSave) {
        print("tambah data saat save kondisi udah ga ada internet");

        dataBox.addUploadListTask(
            userId: userId.toString(),
            taskId: taskId.toString(),
            status: status,
            timesheetDate: timesheetDate,
            timesheetDesc: timesheetDesc,
            timesheetDuration: timesheetDuration,
            open: open);
        objNetwork = Network(Status: true, Message: "Koneksi server error");
      } else {
        objNetwork = Network(Status: false, Message: "Koneksi server error");
      }
    }

    //save data to listupload

    // }
    // else {
    //   //ga ada koneksi, simpan data yg akan disaving ke lokal
    //
    //   if (manualSave) {
    //     print("tambah data saat save kondisi udah ga ada internet");
    //
    //     dataBox.addUploadListTask(
    //         userId: userId.toString(),
    //         taskId: taskId.toString(),
    //         status: status,
    //         timesheetDate: timesheetDate,
    //         timesheetDesc: timesheetDesc,
    //         timesheetDuration: timesheetDuration,
    //         open: open);
    //   } else {
    //     //reset task jika ketika listupload task di proses, jaringan internet hilang, maka task yang tadinya status upload =1 jadi 0 lagi
    //     final boxdata = boxData(nameBox: "box_listUploadWorksheet");
    //     bool checkData = await boxdata.cekDataOnListUpload(taskId.toString());
    //
    //     if (checkData) {
    //       // dataBox.replaceUploadListTask(
    //       //   id: Id!,
    //       //   upload: 0,
    //       //   userId: userId.toString(),
    //       //   taskId: taskId.toString(),
    //       // );
    //     }
    //   }
    //
    //   objNetwork = Network(Status: false, Message: "Koneksi server error");
    // }
    return objNetwork;
  }

  Future<bool> ceklastSaved({int? taskid, int? userid}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "params": {"userid": userid, "taskid": taskid}
    };
    print('cek last saved param send');
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/user/saved'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    try {
      // print('try cek koneksi');
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();

        if (strResult != "") {
          print("strResult cek last saved");
          print(strResult);
          // print(strResult['error']['data']['debug']);
          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "cek last saved");
          print(strResult);
          if (!objNetwork.Status && userid != null && taskid != null) {
            await LoadWorksheetForm(
                userId: userid, taskId: taskid, handoff: true);
            return true;
          } else {
            return false;
          }
          // return objNetwork;
        }
      }
    } catch (e) {
      // print(e);
      objNetwork.Status = false;
      // return objNetwork;
      return false;
    }

    // return objNetwork;
    return false;
  }

  Future<Network> LoadWorksheetForm({
  required int userId,
  required int taskId,
  bool autoSaveLocal = true,
  bool handoff = false,
}) async {
  OdooServer objOdooServer = OdooServer();
  Network objNetwork = Network(Status: false);

  try {
    // Ambil Header dan Param
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "params": {"userid": userId, "taskid": taskId}
    };

    // Debugging log untuk Header dan Parameter
    print('Headers: $headers');
    print('Parameters: $objParam');

    // Buat Request
    var request = http.Request('POST', Uri.parse('$_Url/worksheet/load'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);

    // Debugging log sebelum mengirim request
    print('Sending request to $_Url/worksheet/load...');

    // Kirim request dengan timeout
    http.StreamedResponse response = await request
        .send()
        .timeout(const Duration(seconds: 10), onTimeout: () {
      print('Request timeout after 10 seconds');
      throw TimeoutException('Request timed out');
    });

    // Debugging log setelah menerima respons
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();

      if (strResult.isNotEmpty) {
        print('Response body: $strResult');

        objNetwork = await objOdooServer.getValidateApiResponse(
          strResult,
          "worksheet/load",
        );

        if (objNetwork.Status && autoSaveLocal) {
          dynamic valServer = objNetwork.Data;

          // Simpan data secara lokal
          var addValueServer = boxData(nameBox: 'box_valworksheet');
          addValueServer.addValueWorksheet(
            valServer: valServer,
            userid: userId.toString(),
            taskid: taskId.toString(),
            handoff: handoff,
          );
        }

        print('Final Network Data: ${objNetwork.Data}');
      } else {
        print('Empty response body');
      }
    } else {
      print('Error: Response status code ${response.statusCode}');
    }
  } catch (e, stacktrace) {
    print('Exception occurred: $e');
    print('Stacktrace: $stacktrace');

    // Tangani timeout
    if (e is TimeoutException) {
      print('The request timed out');
    }
  }

  return objNetwork;
}

}
