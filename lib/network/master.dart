import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:pit/model/mNetwork.dart';
import 'package:pit/helpers/odoo.dart';
import 'package:pit/utils/boxData.dart';

class masterNetwork {
  // final String _Url = "https://testpit.odoo.com"; //staging
  final String _Url = "https://pitelektronik.odoo.com"; //production
  Future<Network> getMasterProduct() async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {"jsonrpc": "2.0", "params": {}};
    print('objParam line 26 dari file masterproduct.dart');
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/master/product'));
    request.body = json.encode(objParam);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();

      if (strResult != "") {
        dynamic objData = await jsonDecode(strResult);
        objNetwork = await objOdooServer.getValidateApiResponse(
            strResult, "master/product");

        // print(objData['result']['data']);
        // print(objData['result']['data'][0]);
        if (objNetwork.Status) {
          print("get master product");
          print(objNetwork.Data);
          var box_AddList = Hive.box("box_masterProduct");
          // dynamic masterData = [
          //   {"product": dataProduct, "garansi": objData['result']['data']}
          // ];
          box_AddList.put("product", objNetwork.Data);
          // await getMasterWaktuGaransi();
          // await getMasterWaktuGaransi(objData['result']['data']);
        }
      }
    }
    return objNetwork;
  }

  Future<Network> getMasterWaktuGaransi() async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {"jsonrpc": "2.0", "params": {}};
    print('objParam line 54 dari file masterwarranty.dart');
    print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/master/warranty'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();

      if (strResult != "") {
        objNetwork = await objOdooServer.getValidateApiResponse(
            strResult, "master/warranty");

        if (objNetwork.Status) {
          print("objek data result dari master garansi");
          print(objNetwork.Data);
          //aktifkan ini ketika api masa garansi sudah tersedia
          var box_Garansi = Hive.box("box_masterGaransi");
          // dynamic masterData = [
          //   {"product": dataProduct, "garansi": objData['result']['data']}
          // ];
          box_Garansi.put("garansi", objNetwork.Data);
        }
      }
    }

    return objNetwork;
  }

  Future<Network> cekConnections() async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    dynamic objResult = {};
    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {"jsonrpc": "2.0", "params": {}};
    // print('objParam line 54 dari file masterwarranty.dart');
    // print(objParam);
    var request = http.Request('POST', Uri.parse('$_Url/online'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    try {
      // print('try cek koneksi');
      http.StreamedResponse response =
          await request.send().timeout(Duration(milliseconds: 3000));

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();

        if (strResult != "") {
          // print("strResult cek koneksi");
          // print(strResult);
          // print(strResult['error']['data']['debug']);
          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "check connection");
          return objNetwork;
        }
      }
    } catch (e) {
      // print(e);
      objNetwork.Status = false;
      // objNetwork.Error = "${e}";
      return objNetwork;
    }

    return objNetwork;
  }

  Future<Network> cekUserActive(int userid) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    final getUserid = boxData(nameBox: "box_setLoginCredential");
    final token = await getUserid.getLoginCredential(param: "token");
    final secretKey = await getUserid.getLoginCredential(param: "secretKey");
    dynamic objResult = {};
    if (userid != null && userid != 0 && secretKey != "" && token != "") {
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {"userid": userid}
      };
      // print('objParam dari file cek useractive.dart');
      // print(objParam);
      // print(headers);
      var request = http.Request('POST', Uri.parse('$_Url/useraktif'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      try {
        // print('try cek koneksi');
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String strResult = await response.stream.bytesToString();

          if (strResult != "") {
            // print('result dari user aktif');
            // print(strResult);

            objNetwork = await objOdooServer.getValidateApiResponse(
                strResult, "useraktif");

            return objNetwork;
          }
        }
      } catch (e) {
        // print(e);
        objNetwork.Status = true;
        return objNetwork;
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }
}
