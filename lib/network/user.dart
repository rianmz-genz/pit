import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/helpers/odoo.dart';
import 'package:pit/utils/boxData.dart';
import 'package:pit/viewmodel/vmUser.dart';

class UserNetwork {
  // final String _Url = "https://testpit.odoo.com"; //staging
  final String _Url = "https://pitelektronik.odoo.com"; //production

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<Network> getUserOtp(String strSecretKey, String strPhone, String otp,
      String user_token, int user_active) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // Preferences objPreferences = Preferences();
    // String strSecretKey = await objPreferences.getSecretKey();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");

    if (strSecretKey != "") {
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {
          "phone": strPhone,
          "otp": otp,
          "secretkey": strSecretKey,
          "usertoken": user_token,
          "user_active": user_active
        }
      };

      var request = http.Request('POST', Uri.parse('$_Url/user/otp'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      //TODO try catch
      try {
        http.StreamedResponse response = await request.send();

        print(objParam);
        print(response.statusCode);
        if (response.statusCode == 200) {
          String strResult = await response.stream.bytesToString();

          Map<String, String> lstHeader = response.headers;
          print(lstHeader);
          if (strResult != "") {
            print(strResult);
            objNetwork = await objOdooServer.getValidateApiResponse(
                strResult, "user/otp");

            if (objNetwork.Status) {
              print("otp status true");
              objNetwork.Status = true;
              dynamic objUser = objNetwork.Data;

              // print(objUser["picprofile"]);

              Directory appDocumentsDirectory =
                  await getApplicationDocumentsDirectory();
              String appDocumentsPath = appDocumentsDirectory.path;
              if (objUser["picprofile"] == false) {
                objUser["picprofile"] = "";
              }
              final base64Encode = base64.decode(objUser["picprofile"]);
              var file = File('$appDocumentsPath/profile_User.png');
              await file.writeAsBytes(base64Encode);

              vmUser objVmUser = vmUser();
              if (objUser["picprofile"] == "") {
                await objVmUser.getEditUser(
                    Name: objUser["name"],
                    Phone: strPhone,
                    Area: objUser["area"] == false ? "" : objUser["area"],
                    Kemampuan: objUser['skill'].join(', '),
                    Status: objUser['type'],
                    Picture: "");
              } else {
                await objVmUser.getEditUser(
                    Name: objUser["name"],
                    Phone: strPhone,
                    Area: objUser["area"] == false ? "" : objUser["area"],
                    Kemampuan: objUser['skill'].join(', '),
                    Status: objUser['type'],
                    Picture: file.path);
              }
              final boxdata = boxData(nameBox: "box_setLoginCredential");
              boxdata.setLoginCredential(
                  secretKey: objUser["secretkey"],
                  token: lstHeader["set-cookie"].toString(),
                  Phone: strPhone,
                  UserId: objUser["id"].toString(),
                  Otp: otp);
            }
          }
        }
      } catch (e) {
        objNetwork.Message = "anda tidak terhubung ke jaringan internet";
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }

  Future<Network> getUserProfile(
      String userid, String otp, String strPhone) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // Preferences objPreferences = Preferences();
    // String strSecretKey = await objPreferences.getSecretKey();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");

    if (strSecretKey != "") {
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {"userid": userid}
      };

      var request = http.Request('POST', Uri.parse('$_Url/user/profile'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      print("objParam getprofile");
      print(objParam);
      print(response.statusCode);
      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();

        Map<String, String> lstHeader = response.headers;

        if (strResult != "") {
          print(strResult);
          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "user/profile");

          if (objNetwork.Status) {
            print("otp status true");
            objNetwork.Status = true;
            dynamic objUser = objNetwork.Data;

            // print(objUser["picprofile"]);

            Directory appDocumentsDirectory =
                await getApplicationDocumentsDirectory();
            String appDocumentsPath = appDocumentsDirectory.path;
            if (objUser["picprofile"] == false) {
              objUser["picprofile"] = "";
            }
            final base64Encode = base64.decode(objUser["picprofile"]);
            var file = File('$appDocumentsPath/profile_User.png');
            await file.writeAsBytes(base64Encode);

            vmUser objVmUser = vmUser();
            if (objUser["picprofile"] == "") {
              await objVmUser.getEditUser(
                  Name: objUser["name"],
                  Phone: strPhone,
                  Area: objUser["area"] == false ? "" : objUser["area"],
                  Kemampuan: objUser['skill'].join(', '),
                  Status: objUser['type'],
                  Picture: "");
            } else {
              await objVmUser.getEditUser(
                  Name: objUser["name"],
                  Phone: strPhone,
                  Area: objUser["area"] == false ? "" : objUser["area"],
                  Kemampuan: objUser['skill'].join(', '),
                  Status: objUser['type'],
                  Picture: file.path);
            }
            final boxdata = boxData(nameBox: "box_setLoginCredential");
            boxdata.setLoginCredential(
                secretKey: objUser["secretkey"],
                token: lstHeader["set-cookie"].toString(),
                Phone: strPhone,
                UserId: objUser["id"].toString(),
                Otp: otp);
          }
        }
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }

  Future<Network> getUserLogin(String strPhone) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "params": {"phone": strPhone}
    };

    var request = http.Request('POST', Uri.parse('$_Url/user/login'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String strResult = await response.stream.bytesToString();
        if (strResult != "") {
          objNetwork = await objOdooServer.getValidateApiResponse(
              strResult, "user/login");

          if (objNetwork.Status) {
            final boxdata = boxData(nameBox: "box_setLoginCredential");
            await boxdata.setLoginCredential(
                secretKey: objNetwork.Data["secretkey"],
                token: "",
                Phone: strPhone,
                UserId: "",
                Otp: "");
          }
        }
      }
    } catch (e) {
      print('data gagal kirim');
      print(e);
      objNetwork.Message = "Anda tidak terhubung ke jaringan internet";
    }
    return objNetwork;
  }

  Future<Network> getUserEdit(
      {required String Phone,
      required String Nama,
      required String Area,
      required String Reason,
      required File PicProfile,
      required int user_active}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    // Preferences objPreferences = Preferences();
    // String strSecretKey = await objPreferences.getSecretKey();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");

    var bytes;
    String base64Encode = "";
    if (PicProfile.path.toString() != "") {
      bytes = PicProfile.readAsBytesSync();
      base64Encode = base64.encode(bytes);
    }

    dynamic headers = await objOdooServer.getHeaderApiParam();
    dynamic objParam = {
      "jsonrpc": "2.0",
      "params": {
        "secretkey": strSecretKey,
        "phone": Phone,
        "name": Nama,
        "area": Area,
        "reason": Reason,
        "profile": base64Encode,
        "user_active": user_active,
      }
    };
    print(objParam);
    print(headers);

    var request = http.Request('POST', Uri.parse('$_Url/user/edit'));
    request.body = json.encode(objParam);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print(headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String strResult = await response.stream.bytesToString();
      if (strResult != "") {
        print(strResult);
        objNetwork =
            await objOdooServer.getValidateApiResponse(strResult, "user/edit");
      }
    }

    return objNetwork;
  }

  Future<Network> editUserActive(
      {required String Phone, int? user_active}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);
    print("user_active edituseractive");
    print(user_active);
    print(user_active.runtimeType);
    // Preferences objPreferences = Preferences();
    // String strSecretKey = await objPreferences.getSecretKey();
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    if (strSecretKey != "") {
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {
          "secretkey": strSecretKey,
          "phone": Phone,
          "user_active": user_active,
        }
      };
      print(objParam);
      print(headers);
      var request = http.Request('POST', Uri.parse('$_Url/user/edit'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      try {
        http.StreamedResponse response = await request.send();

        print(response.statusCode);
        if (response.statusCode == 200) {
          String strResult = await response.stream.bytesToString();
          if (strResult != "") {
            objNetwork = await objOdooServer.getValidateApiResponse(
                strResult, "user/edit");
            print("response edit useractive");
            print(objNetwork.Data);
          }
        }
      } catch (e) {
        print(e);
        print("data gagal kekirim");
        objNetwork.Status = false;
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }

  Future<Network> sendGeolocate({double? lat, double? long}) async {
    OdooServer objOdooServer = OdooServer();
    Network objNetwork = Network(Status: false);

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    final strSecretKey = await boxdata.getLoginCredential(param: "secretKey");
    final token = await boxdata.getLoginCredential(param: "token");

    if (strSecretKey != "" && token != "") {
      dynamic headers = await objOdooServer.getHeaderApiParam();
      dynamic objParam = {
        "jsonrpc": "2.0",
        "params": {
          "secretkey": strSecretKey,
          "lat": lat,
          "long": long,
        }
      };
      // print(objParam);
      // print(headers);

      var request = http.Request('POST', Uri.parse('$_Url/user/geolocate'));
      request.body = json.encode(objParam);
      request.headers.addAll(headers);
      try {
        http.StreamedResponse response = await request.send();

        // print(response.statusCode);
        if (response.statusCode == 200) {
          String strResult = await response.stream.bytesToString();
          if (strResult != "") {
            // print(strResult);
            objNetwork = await objOdooServer.getValidateApiResponse(
                strResult, "user/geolocate");
          }
        }
      } catch (e) {
        print(e);
        print("data gagal kekirim");
        objNetwork.Status = false;
        objNetwork.Message = "Anda tidak terhubung ke jaringan internet";
      }

      return objNetwork;
    } else {
      return objNetwork;
    }
  }

  // Future<Network> getUserRegist(listvie
  //     {required String strPhone,
  //     required String strNama,
  //     required String strEmail}) async {
  //   OdooServer objOdooServer = OdooServer();
  //   Network objNetwork = Network(Status: false);
  //
  //   dynamic headers = await objOdooServer.getHeaderApiParam();
  //   dynamic objParam = {
  //     "jsonrpc": "2.0",
  //     // "params": {"mobile_phone": strPhone, "name": strNama}
  //   };
  //
  //   var request = http.Request('POST', Uri.parse('$_Url/user/regis'));
  //   request.body = json.encode(objParam);
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //
  //   String strResult = await response.stream.bytesToString();
  //
  //   print('$_Url/user/regis');
  //   print(response.statusCode);
  //   print(strResult);
  //   if (response.statusCode == 200) {
  //     String strResult = await response.stream.bytesToString();
  //     if (strResult != "") {
  //       print(strResult);
  //       objNetwork = await objOdooServer.getValidateApiResponse(
  //           strResult, "/user/regis");
  //
  //       if (objNetwork.Status) {
  //         final boxdata = boxData(nameBox: "box_setLoginCredential");
  //         boxdata.setLoginCredential(
  //             secretKey: objNetwork.Data["secretkey"],
  //             token: "",
  //             Phone: strPhone,
  //             UserId: "",
  //             Otp: "");
  //         // Preferences objPreferences = Preferences();
  //         // await objPreferences.SetLoginCredential(
  //         //     Phone: strPhone,
  //         //     secretKey: objNetwork.Data["secretkey"],
  //         //     UserId: '',
  //         //     token: '',
  //         //     Otp: '');
  //       }
  //     }
  //   }
  //
  //   return objNetwork;
  // }
}
