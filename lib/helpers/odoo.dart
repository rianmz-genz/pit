import 'dart:convert';

import 'package:pit/model/mNetwork.dart';
import 'package:pit/utils/boxData.dart';

class OdooServer {
  dynamic getHeaderApiParam() async {
    dynamic objReturn = {};

    // Preferences objPreferences = Preferences();
    //
    // String strToken = await objPreferences.getToken();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strToken = await boxdata.getLoginCredential(param: "token");
    objReturn = {'Content-Type': 'application/json'};
    if (strToken != "") {
      objReturn['Cookie'] = strToken;
    }

    return objReturn;
  }

  Future<Network> getValidateApiResponse(String strResult, String from) async {
    Network objNetwork =
        Network(Status: false, Message: "Koneksi server error");

    dynamic objData = await jsonDecode(strResult);

    if (objData.length > 0) {
      if (objData.containsKey("error")) {
        print(objData["error"]["data"]["debug"]);
        print(objData["error"]["data"]["argument"]);
        if (objData["error"]["code"] == 100) {
          objNetwork.Message = objData["error"]["message"];
          // objNetwork.Error = "Odoo Session Expired";
          // print("contains error in odoo.dart");
          // print(strResult);
          // print(objData);
          final boxdata = boxData(nameBox: "box_setLoginCredential");
          boxdata.deleteLoginCredential();

          return objNetwork;
        } else {
          objNetwork.Message = objData["error"]["message"];
          print("pesan error dari odoo");
          // print(objData["error"]["data"]["debug"]);
          print(objData["error"]["data"]["message"]);
          print(objData["error"]["data"]["argument"]);
          // print(objData);
          objNetwork.Error = objData["error"]["data"]["message"];
          // final boxdata = boxData(nameBox: "box_setLoginCredential");
          // boxdata.deleteLoginCredential();

          return objNetwork;
        }
      }
      if (!objData.containsKey("result")) return objNetwork;
      if (!objData["result"].containsKey("status")) return objNetwork;
      if (objData["result"].containsKey("message")) {
        objNetwork.Message = objData["result"]["message"];
        // //kode sementara
        // objNetwork.Message = "data ada";
      }
      if (objData["result"]["status"] != true) {
        if (from == "useraktif") {
          if (objNetwork.Data == null) {
            if (objData['result'].containsKey("token")) {
              objNetwork.Data = {"token": objData['result']['token']};
            } else {
              objNetwork.Data = {"token": ""};
            }
          }
        }
        return objNetwork;
      }

      objNetwork.Status = true;
      if (objData["result"].containsKey("data")) {
        objNetwork.Data = objData["result"]["data"];
      } else {
        objNetwork.Data = objData["result"];
      }
    }
    // print("objData odooo");
    // print(objData);
    // print(objData.length);
    // print(strResult);
    // print(objNetwork.Status);
    return objNetwork;
  }
}
