import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/network/task.dart';
import 'package:pit/network/user.dart';
import 'package:pit/utils/boxData.dart';
import 'package:pit/view/akun_new.dart';
import 'package:pit/view/homescreen.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

import '../network/master.dart';

class LoginOtp extends StatelessWidget {
  String Type;
  String Phone;

  LoginOtp({super.key, required this.Type, required this.Phone});

  final myNumberController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.fromLTRB(29 * MySize.scaleFactorWidth, 0,
                  29 * MySize.scaleFactorWidth, 0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image(
                        width: MySize.getScaledSizeWidth(250), //160
                        image: const AssetImage(
                            'assets/images/logo_pit_elektronik.png'),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Hampir selesai..',
                        style:
                            AppTheme.OpenSans600(31, const Color(0xFF1C1939)),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'Mohon masukkan kode 4 digit yang terdaftar untuk anda ',
                          style:
                              AppTheme.OpenSans600(15, const Color(0xFF1C1939)),
                        ),
                      ),
                      SizedBox(
                        height: 64 * MySize.scaleFactorHeight,
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 276, maxWidth: 276),
                        child: PinCodeTextField(
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], //
                          textStyle: AppTheme.OpenSans600LS(
                              30, const Color(0xFF1C1939), -0.43),
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 47,
                              fieldWidth: 57,
                              activeFillColor: Colors.white,
                              selectedColor: const Color(0xFF00A09D),
                              activeColor: const Color(0xFF1C1939),
                              inactiveColor: const Color(0xFF1C1939)),
                          animationDuration: const Duration(milliseconds: 300),
                          errorAnimationController: errorController,
                          controller: myNumberController,
                          onCompleted: (myNumberController) async {
                            final boxdata =
                                boxData(nameBox: "box_setLoginCredential");

                            String strSecretKey = await boxdata
                                .getLoginCredential(param: "secretKey");
                            print("sercret key dari otp page");
                            print(strSecretKey);
                            if (myNumberController.length == 4) {
                              UserNetwork objUserNetwork = UserNetwork();

                              double lat;
                              double long;

                              var addUserToken = Hive.box("box_usertoken");
                              String userToken = "";

                              await FirebaseMessaging.instance
                                  .getToken()
                                  .then((value) {
                                userToken = value ?? "";
                                addUserToken.put(Phone, userToken);
                              });

                              Network objNetwork =
                                  await objUserNetwork.getUserOtp(strSecretKey,
                                      Phone, myNumberController, userToken, 1);

                              bool checkGeolocation = false;
                              bool serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (serviceEnabled) {
                                Position _locationData =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                lat = _locationData.latitude;
                                long = _locationData.longitude;
                                if (objNetwork.Status) {
                                  UserNetwork objUserNetwork = UserNetwork();
                                  Network objNetworkGeo = await objUserNetwork
                                      .sendGeolocate(lat: lat, long: long);
                                  if (objNetworkGeo.Status) {
                                    print("init Check Geolocation has done");
                                    checkGeolocation = objNetworkGeo.Status;
                                    print(checkGeolocation);
                                  } else {
                                    checkGeolocation = objNetworkGeo.Status;
                                    if (objNetwork.Message != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text(objNetwork.Message!)));
                                    }
                                  }
                                } else {
                                  checkGeolocation = objNetwork.Status;
                                  if (objNetwork.Message != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(objNetwork.Message!)));
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Harap izinkan permission lokasi di device anda")));
                              }

                              if (checkGeolocation) {
                                Preferences pref = Preferences();
                                await pref.SetUserActive(1);
                                if (Type == "regist") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountNew(),
                                      ));
                                } else {
                                  masterNetwork objMasterProd = masterNetwork();
                                  Network objMasterPRoductNetwork =
                                      await objMasterProd.getMasterProduct();
                                  Network objMasterGaransiNetwork =
                                      await objMasterProd
                                          .getMasterWaktuGaransi();

                                  String userId = await boxdata
                                      .getLoginCredential(param: "userId");

                                  int userID = int.parse(userId);

                                  await initDashBoard(userId);
                                  await restartListUpload(userId);
                                  
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(0),
                                      ));
                                }
                              } else {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            return true;
                          },
                          appContext: context,
                        ),
                      ),
                      SizedBox(
                        height: 53 * MySize.scaleFactorHeight,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Future<void> fillDashboard(int userId, double lat, double long) async {
    TaskNetwork objTaskNetwork = TaskNetwork();
    Network objNetwork = await objTaskNetwork.getTaskCount(userid: userId);
    if (objNetwork.Status) {
      var updateDasboard = boxData(nameBox: 'box_dashboard');
      var addList = boxData(nameBox: 'box_listPekerjaan');
      updateDasboard.addDataDashboard(
          param: 'taskDikirim', tambah: false, reset: true);
      await addList.countListTaskOnHome(
          getpekerjaan: objNetwork.Data['CurrentTask'],
          point: objNetwork.Data['point'],
          FinishTask: objNetwork.Data['FinishTask']);
    }

    Network objNetworkHistory = await objTaskNetwork.getTaskList(
      strUserId: userId.toString(),
      Status: "History",
      Lat: lat,
      Lng: long,
    );
    if (objNetwork.Status) {
      final dataResultHistory = await objNetworkHistory.Data;
      var updateDasboard = boxData(nameBox: 'box_dashboard');
      var addHistory = boxData(nameBox: 'box_historyPekerjaan');
      updateDasboard.addDataDashboard(
          param: 'selesaiAll', tambah: false, reset: true);
      updateDasboard.addDataDashboard(
          param: 'selesaiPerDay', tambah: false, reset: true);
      await addHistory.countHistoryTaskOnHome(values: dataResultHistory);
    } else {
      print("anda tidak terhubung ke jaringan internet");
    }
  }

  Future<void> restartListUpload(String userId) async {
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    final boxOpendataupload = await Hive.openBox("box_listUploadWorksheet");
    if (boxOpendataupload.isNotEmpty) {
      if (userId != 0) {
        final data = boxOpendataupload.get(userId) ?? [];
        if (data != null && data.length != 0) {
          for (var val in data) {
            val['upload'] = 0;
            print(val);
          }
          print("dari reset listupload");
          print(data);
        } else {
          print("data kosong from otp cek listupload");
        }
      } else {
        print('userid empty');
      }
    } else {
      print('box listupload kosong');
    }
  }

  Future<void> initDashBoard(String userId) async {
    final tanggal = DateFormat('dd').format(DateTime.now());
    await Hive.openBox("box_dashboard");
    final boxdata = boxData(nameBox: "box_setLoginCredential");
    var dataDasboard = {
      "Date": tanggal,
      "getPekerjaan": 0,
      "selesaiAll": 0,
      "selesaiPerDay": 0,
      "taskDikirim": 0,
      "taskPendingKirim": 0,
      "Point": 0,
      "triggerRefresh": false
    };

    var openboxDashboard = await Hive.openBox("box_dashboard");
    if (openboxDashboard.isOpen) {
      var insertboxDashboard = Hive.box("box_dashboard");
      if (openboxDashboard.isNotEmpty) {
        var dataDasboardDB = openboxDashboard.get(userId);
        if (dataDasboardDB != null) {
        } else {
          print('start dashboard');
          print(dataDasboard);
          insertboxDashboard.put(userId, dataDasboard);
        }
      } else {
        insertboxDashboard.put(userId, dataDasboard);
      }
    }
  }
}
