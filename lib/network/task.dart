import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

import 'package:pit/model/mNetwork.dart';
import 'package:pit/helpers/odoo.dart';
import 'package:pit/network/CheckDataConnection.dart';
import 'package:pit/utils/boxData.dart';

class TaskNetwork {
  // final String _Url = "http://192.168.20.24:8070";
  // final String _Url = "http://192.168.1.5:8070";
  // final String _Url = "http://192.168.20.24";

  // final String _Url = "https://testpit.odoo.com"; //staging
  final String _Url = "https://odoo.pitelektronik.com"; //production
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<Network> getTaskList(
      {required String Status,
      String? strUserId,
      double? Lat,
      double? Lng}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    final boxdata = boxData(nameBox: "box_setLoginCredential");

    String strUserId = await boxdata.getLoginCredential(param: "userId");

    dynamic headers = await objOdooServer.getHeaderApiParam();
    print('headerss ${headers}');

    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "userid": int.parse(strUserId),
        "status": Status,
        "lat": Lat,
        "lng": Lng,
        "limit": 99999,
        "offset": 0
      }
    };

    var request = http.Request('POST', Uri.parse('$_Url/task/list'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "task/list");
      }
    } else {
      print("ga ada data");
      return objNetwork;
    }

    return objNetwork;
  }

  addDataDashboard() async {
    final tanggal = DateFormat('dd').format(DateTime.now());
    late var valDashboard;
    late var data;
    var openboxDashboard = await Hive.openBox("box_dashboard");
    var insertboxDashboard = Hive.box("box_dashboard");
    if (openboxDashboard.isNotEmpty) {
      valDashboard = openboxDashboard.get("values");
      valDashboard['getPekerjaan'] += 1;

      insertboxDashboard.put("values", valDashboard);
    } else {
      valDashboard = {
        "Date": tanggal,
        "getPekerjaan": 1,
        "selesaiAll": 0,
        "selesaiPerDay": 0,
        "taskDikirim": 0,
        "taskPendingKirim": 0,
        "Point": 0,
      };
      insertboxDashboard.put("values", valDashboard);
    }
  }

  Future<Network> getTaskCount({required int userid}) async {
    print("task/count");
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "params": {"userid": userid}
    };
    print("objParam task/count");
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/task/count'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print(strResult);
        objNetwork = await objOdooServer.getValidateApiResponse(
            strResult, "/task/count");
      }
    }

    return objNetwork;
  }

  Future<Network> getTaskDetail({required int TaskId}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();
    final getUserid = boxData(nameBox: "box_setLoginCredential");
    // final token = await getUserid.getLoginCredential(param: "token");
    final secretKey = await getUserid.getLoginCredential(param: "secretKey");

    if (secretKey != "") {
      dynamic objResult = {};
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {"taskid": TaskId}
      };
      print("objParam task/detail");
      print(objParam);
      var request = http.Request('POST', Uri.parse('$_Url/task/detail'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();
        if (strResult != "") {
          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "/task/detail");
        }
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }

  Future<Network> taskNotif({required int TaskId, required int UserId}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    Connection objCekConnection = Connection();
    Network cekKoneksi = await objCekConnection.CheckConnection();

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"taskid": TaskId, "userid": UserId}
    };
    print("objParam list/notif");
    // debugPrint("objParam list/notif");

    print(objParam);
    // debugPrint(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/list/notif'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        // print("ini dapet dip");
        print(strResult);
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "list/notif");
      }
    }

    return objNetwork;
  }

  Future<Network> getTaskAccept({required int TaskId}) async {
    // Preferences objPreferences = Preferences();
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // String strUserId = await objPreferences.getUserId();
    // String strSecretKey = await objPreferences.getSecretKey();

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    String strUserId = await boxdata.getLoginCredential(param: "userId");

    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "userid": int.parse(strUserId),
        "secretkey": strSecretKey,
        "taskid": TaskId,
        // "taskopen": false, // tanda bila pekerjaan sudah tidak open
      }
    };
    print("objParam dari get task accept");
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/task/request'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print("strResult");
        print(strResult);
        objNetwork = await objOdooServer.getValidateApiResponse(
            strResult, "task/request");
      }
    }

    return objNetwork;
  }

  //timesheet api
  Future<Network> startTimeSheet({required int TaskId}) async {
    // Preferences objPreferences = Preferences();
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // String strUserId = await objPreferences.getUserId();
    // String strSecretKey = await objPreferences.getSecretKey();

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    String strUserId = await boxdata.getLoginCredential(param: "userId");

    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"taskid": TaskId}
    };
    print("objParam dari startTimeSheet");
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/task/start'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print("strResult");
        print(strResult);
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "task/start");
      }
    }

    return objNetwork;
  }

  Future<Network> pauseTimeSheet({required int TaskId}) async {
    // Preferences objPreferences = Preferences();
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // String strUserId = await objPreferences.getUserId();
    // String strSecretKey = await objPreferences.getSecretKey();

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    String strUserId = await boxdata.getLoginCredential(param: "userId");
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"taskid": TaskId}
    };
    print("objParam dari pauseTimeSheet");
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/task/pause'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print("strResult");
        print(strResult);
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "task/pause");
      }
    }

    return objNetwork;
  }

  Future<Network> stopTimeSheet({required int TaskId}) async {
    // Preferences objPreferences = Preferences();
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // String strUserId = await objPreferences.getUserId();
    // String strSecretKey = await objPreferences.getSecretKey();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    String strUserId = await boxdata.getLoginCredential(param: "userId");
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {"taskid": TaskId}
    };
    print("objParam dari stopTimeSheet");
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/task/stop'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print("strResult");
        print(strResult);
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "task/stop");
      }
    }

    return objNetwork;
  }
}
