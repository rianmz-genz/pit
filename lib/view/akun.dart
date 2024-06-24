import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mUser.dart';
import 'package:pit/notifier/UserNotifier.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/boxData.dart';
import 'package:pit/utils/popUpError.dart';
import 'package:pit/view/about_us.dart';
import 'package:pit/view/help_center.dart';
import 'package:pit/view/login_phone.dart';
import 'package:pit/view/profile.dart';
import 'package:provider/provider.dart';

import '../model/mNetwork.dart';
import '../network/CheckDataConnection.dart';
import '../network/user.dart';
import '../themes/AppTheme.dart';
import '../utils/notificationApi.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double fit(double angka, double screen) => (angka);

  @override
  void initState() {
    super.initState();
    updateProfile();
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   print('Hello, world');
    //   getDataProfile();
    // });
    // runStart();

    // Provider.of<UserNotifier>(context, listen: false).updateList();
  }

  updateProfile() async {
    Preferences objPreferences = Preferences();
    objPreferences.setCheckUpdateProfile(1);
  }

  @override
  void dispose() {
    // timer.cancel();
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    ThemeData themeData = Theme.of(context);
    // Provider.of<UserNotifier>(context, listen: false).updateList();
    return ChangeNotifierProvider<UserNotifier>(
      create: (context) => UserNotifier(),
      child: Builder(builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.warnaUngu,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Pengaturan',
                style: AppTheme.appBarTheme(),
                textAlign: TextAlign.center,
              ),
            ),
            body: UserView(),
          ),
        );
      }),
    );
  }
}

class DetailAkun extends StatelessWidget {
  String Title;
  String Value;

  DetailAkun({super.key, required this.Title, required this.Value});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Title,
              style: AppTheme.OpenSans600LS(15, const Color(0xff323333), -0.26),
            ),
            Text(
              Value,
              style: AppTheme.OpenSans500(15, Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  String Title;
  final Widget Event;

  MenuOption({super.key, required this.Title, required this.Event});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        child: ListTile(
          dense: true,
          title: Text(
            Title,
            style: AppTheme.OpenSans500LS(16, const Color(0xFF323333), -0.27),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => Event));
            print("updateList");

            await Provider.of<UserNotifier>(context, listen: false)
                .updateList();
            await Provider.of<UserNotifier>(context, listen: false).getUser();
          },
        ),
      ),
    );
  }
}

class UserView extends StatelessWidget {
  int countData = 0;
  bool active = false;

  UserView({super.key});
  getDataProfile(BuildContext context) async {
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
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: const Column(
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
                    style: TextStyle(color: AppTheme.warnaHijau, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

    final boxdata = boxData(nameBox: "box_setLoginCredential");
    String strSecretKey = await boxdata.getLoginCredential(param: "secretKey");

    UserNetwork objUserNetwork = UserNetwork();
    Connection objCekConnection = Connection();

    Preferences pref = Preferences();
    // String phone = await pref.getPhone();
    // String otp = await pref.getOtp();
    //

    String phone = await boxdata.getLoginCredential(param: "phone");
    String otp = await boxdata.getLoginCredential(param: "otp");

    String userid = await boxdata.getLoginCredential(param: "userId");
    //

    Network cekKoneksi = await objCekConnection.CheckConnection();
    print("Cek Koneksi getDataProfile");
    print('hasilnya: ${cekKoneksi.Status}');
    if (cekKoneksi.Status) {
      String userToken = "";
      var OpenUserToken = await Hive.openBox("box_usertoken");
      userToken = OpenUserToken.get(phone);
      bool statuserActive = false;
      int userActive = await pref.getUserActive();

      Network objNetwork =
          await objUserNetwork.getUserProfile(userid, otp, phone);
      print('reload profile');
      if (objNetwork.Status) {
        Navigator.of(context).pop();
      } else {
        print("error niiy");
      }
    } else {
      final downMessage = PopupError();
      downMessage.showError(context, cekKoneksi, false, true);
      print('not connection, failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Build _CustomerListview");

    return Consumer<UserNotifier>(builder: (_, value, __) {
      User _User = value.getUser();
      int userActive = value.getuser_active();

      if (userActive == 1) {
        active = true;
      } else {
        active = false;
      }

      return RefreshIndicator(
        color: AppTheme.warnaHijau,
        onRefresh: () async {
          Connection objCekConnection = Connection();
          Network cekKoneksi = await objCekConnection.CheckConnection();
          if (cekKoneksi.Status) {
            print("refresh data akun");

            getDataProfile(context);

            Future.delayed(const Duration(seconds: 2), () {
              Provider.of<UserNotifier>(context, listen: false).updateList();
              _User = value.getUser();
            });
            // Provider.of<UserNotifier>(context, listen: false).updateList();
            // Provider.of<UserNotifier>(context, listen: false).updateList();
          } else {
            final downMessage = PopupError();
            downMessage.showError(context, cekKoneksi, true, true);
          }
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //       content: Text("anda tidak terhubung ke jaringan internet")));
          // }
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // margin: EdgeInsets.all(MySize.size4!),
                          width: MySize.getScaledSizeWidth(79),
                          height: MySize.getScaledSizeHeight(79),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: _User.Picture.toString() == "" ||
                                    _User.Picture == ""
                                ? const DecorationImage(
                                    image: AssetImage(
                                        "./assets/images/default_gambar.png"),
                                    fit: BoxFit.fill)
                                : DecorationImage(
                                    image: FileImage(
                                        File(_User.Picture.toString())),
                                    fit: BoxFit.fill),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: MySize.getScaledSizeWidth(160),
                    top: MySize.getScaledSizeHeight(70),
                    child: Container(
                      height: 20.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? Colors.green : Colors.red,
                          border: Border.all(
                            color: Colors.white70,
                            width: 2.0,
                            style: BorderStyle.solid,
                          )),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _User.Name.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.black),
              DetailAkun(Title: "Kontak", Value: _User.Phone.toString()),
              const Divider(color: Colors.black),
              DetailAkun(Title: "Area", Value: _User.Area.toString()),
              const Divider(color: Colors.black),
              DetailAkun(Title: "Kemampuan", Value: _User.Kemampuan.toString()),
              const Divider(color: Colors.grey),
              DetailAkun(Title: "Status", Value: _User.Status.toString()),
              const Divider(color: Colors.grey),
              MenuOption(Title: "Pengaturan Akun", Event: Profile(_User)),
              const Divider(color: Colors.black),
              // MenuOption(Title: "Pusat Bantuan", Event: HomeScreen(1)),
              MenuOption(Title: "Pusat Bantuan", Event: HelpCenter()),
              const Divider(color: Colors.black),
              MenuOption(Title: "Tentang", Event: const AboutUs()),
              const Divider(color: Colors.black),
              // MenuOption(Title: "Bahasa", Event: HomeScreen(1)),
              // Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(300, 55),
                        padding: const EdgeInsets.only(left: 37, right: 37),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        side: const BorderSide(
                            color: Color(0xFF979797), width: 1),
                      ),
                      onPressed: () async {
                        Connection objCekConnection = Connection();
                        Network cekKoneksi =
                            await objCekConnection.CheckConnection();
                        if (cekKoneksi.Status) {
                          final boxdata =
                              boxData(nameBox: "box_setLoginCredential");

                          String userId =
                              await boxdata.getLoginCredential(param: "userId");
                          var boxOpendataupload =
                              await Hive.openBox("box_listUploadWorksheet");

                          bool checkdata = false;
                          if (boxOpendataupload.isNotEmpty) {
                            if (userId != 0) {
                              final data = boxOpendataupload.get(userId);
                              if (data != null && data.length != 0) {
                                countData = data.length;
                                for (var val in data) {
                                  print(val);
                                }
                                // print(countData);
                              }
                            }
                          }
                          // }
                          await showDialog(
                                //show confirm dialogue
                                //the return value will be from "Yes" or "No" options
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Logout Aplikasi',
                                    style:
                                        AppTheme.OpenSans600(18, Colors.black),
                                  ),
                                  // content: Text('Do you want to exit an App?'),
                                  content: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                                    child: Container(
                                      child: Wrap(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Apakah anda yakin ingin logout dari aplikasi?',
                                                style: AppTheme.OpenSans500(
                                                    15, Colors.black),
                                              ),
                                              countData != 0
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "Anda memiliki ",
                                                          style: AppTheme
                                                              .OpenSans500(15,
                                                                  Colors.black),
                                                        ),
                                                        Text(
                                                          "$countData ",
                                                          style: AppTheme
                                                              .OpenSans500(15,
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          "data ",
                                                          style: AppTheme
                                                              .OpenSans500(15,
                                                                  Colors.red),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              countData != 0
                                                  ? Text(
                                                      "yang belum terunggah ",
                                                      style:
                                                          AppTheme.OpenSans500(
                                                              15, Colors.black),
                                                    )
                                                  : Container(),
                                              SizedBox(
                                                  height: MySize
                                                      .getScaledSizeHeight(15)),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        // elevation: 13,
                                                        backgroundColor:
                                                            Colors.white,
                                                        minimumSize:
                                                            const Size(180, 40),
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 37,
                                                                right: 37),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          40)),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        UserNetwork
                                                            objUserNetwork =
                                                            UserNetwork();
                                                        Preferences
                                                            objPreferences =
                                                            Preferences();
                                                        objPreferences
                                                            .setLogoutManual(
                                                                true);
                                                        Network objNetwork =
                                                            await objUserNetwork
                                                                .editUserActive(
                                                                    Phone: _User
                                                                            .Phone ??
                                                                        "",
                                                                    user_active:
                                                                        0);
                                                        if (objNetwork.Status) {
                                                          Preferences pref =
                                                              Preferences();
                                                          await pref
                                                              .SetUserActive(0);
                                                          final boxdata = boxData(
                                                              nameBox:
                                                                  "box_setLoginCredential");

                                                          boxdata
                                                              .setLoginCredential(
                                                                  secretKey: "",
                                                                  token: "",
                                                                  Phone: "",
                                                                  UserId: "",
                                                                  Otp: "");
                                                          await FirebaseMessaging
                                                              .instance
                                                              .deleteToken()
                                                              .then((value) {
                                                            print(
                                                                "token from firebase has deleted");
                                                          });
                                                          final notifApi =
                                                              NotificationApi();
                                                          await notifApi
                                                              .drainStream(
                                                                  "logout app");
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoginPhone(),
                                                              ));
                                                          // await SystemChannels
                                                          //     .platform
                                                          //     .invokeMethod<
                                                          //             void>(
                                                          //         'SystemNavigator.pop',
                                                          //         true);
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      objNetwork
                                                                              .Message
                                                                          .toString())));
                                                        }

                                                        // Future.delayed(
                                                        //     const Duration(
                                                        //         milliseconds: 1000),
                                                        //     () {
                                                        //   SystemChannels.platform
                                                        //       .invokeMethod(
                                                        //           'SystemNavigator.pop');
                                                        // });

                                                        // SystemNavigator
                                                        //     .pop(); //exit apps
                                                        // Navigator.of(context).pop(true);
                                                      },
                                                      child: const Text(
                                                        "Ya",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: MySize
                                                          .getScaledSizeWidth(
                                                              5)),
                                                  Expanded(
                                                      child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      // elevation: 13,
                                                      backgroundColor:
                                                          AppTheme.warnaHijau,
                                                      minimumSize:
                                                          const Size(180, 40),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 37,
                                                              right: 37),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    40)),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text(
                                                      "Tidak",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: const [],
                                ),
                              ) ??
                              false;
                        } else {
                          final downMessage = PopupError();
                          downMessage.showError(
                              context, cekKoneksi, true, true);
                        }
                        // print("periksa kembali koneksi internet anda");
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         "anda tidak terhubung ke jaringan internet")));
                      },
                      child: Text(
                        "Logout",
                        style: AppTheme.OpenSans600(17, const Color(0xff979797)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !active ? Colors.red : Colors.green,
                      minimumSize: const Size(300, 55),
                      padding: const EdgeInsets.only(left: 37, right: 37),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      side:
                          const BorderSide(color: Color(0xFF979797), width: 1),
                    ),
                    onPressed: () async {
                      Connection objCekConnection = Connection();
                      Network cekKoneksi =
                          await objCekConnection.CheckConnection();
                      if (cekKoneksi.Status) {
                        Preferences pref = Preferences();
                        UserNetwork objUserNetwork = UserNetwork();
                        if (!active) {
                          Network objNetwork =
                              await objUserNetwork.editUserActive(
                                  Phone: _User.Phone ?? "", user_active: 1);
                          if (objNetwork.Status) {
                            await pref.SetUserActive(1);

                            Provider.of<UserNotifier>(context, listen: false)
                                .updateList();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(objNetwork.Message.toString())));
                          }
                        } else {
                          Network objNetwork =
                              await objUserNetwork.editUserActive(
                                  Phone: _User.Phone ?? "", user_active: 0);
                          if (objNetwork.Status) {
                            await pref.SetUserActive(0);

                            Provider.of<UserNotifier>(context, listen: false)
                                .updateList();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(objNetwork.Message.toString())));
                          }
                        }
                      } else {
                        final downMessage = PopupError();
                        downMessage.showError(context, cekKoneksi, true, true);
                      }
                    },
                    child: !active
                        ? Text("Nonaktif",
                            style: AppTheme.OpenSans600(17, Colors.white))
                        : Text("Aktif",
                            style: AppTheme.OpenSans600(17, Colors.white)),
                  )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}

class buttonUserActive extends StatefulWidget {
  dynamic User;
  buttonUserActive(this.User, {super.key});

  @override
  _buttonUserActiveState createState() => _buttonUserActiveState();
}

class _buttonUserActiveState extends State<buttonUserActive> {
  bool active = false;
  Preferences pref = Preferences();
  @override
  void initState() {
    // TODO: implement initState
    markedPage();
    getUserActive();
    super.initState();
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "akun");
  }

  getUserActive() async {
    int Active = await pref.getUserActive();
    if (Active == 1) {
      active = true;
      setState(() {});
    } else {
      active = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: !active ? Colors.red : Colors.green,
        minimumSize: const Size(300, 55),
        padding: const EdgeInsets.only(left: 37, right: 37),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        side: const BorderSide(color: Color(0xFF979797), width: 1),
      ),
      onPressed: () async {
        UserNetwork objUserNetwork = UserNetwork();
        if (!active) {
          Network objNetwork = await objUserNetwork.editUserActive(
              Phone: widget.User.Phone ?? "", user_active: 1);
          if (objNetwork.Status) {
            await pref.SetUserActive(1);
            getUserActive();
            setState(() {});
            // Provider.of<UserNotifier>(context, listen: false)
            //     .updateList();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(objNetwork.Message.toString())));
          }
        } else {
          Network objNetwork = await objUserNetwork.editUserActive(
              Phone: widget.User.Phone ?? "", user_active: 0);
          if (objNetwork.Status) {
            await pref.SetUserActive(0);
            getUserActive();
            setState(() {});
            // Provider.of<UserNotifier>(context, listen: false)
            //     .updateList();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(objNetwork.Message.toString())));
          }
        }
      },
      child: !active
          ? Text("Nonaktif", style: AppTheme.OpenSans600(17, Colors.white))
          : Text("Aktif", style: AppTheme.OpenSans600(17, Colors.white)),
    );
  }
}
