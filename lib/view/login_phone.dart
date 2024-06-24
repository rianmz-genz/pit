import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/network/user.dart';

import 'package:pit/view/login_otp.dart';
import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

import '../utils/getLocation.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  final myNumberController = TextEditingController();
  int _state = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // myNumberController.text = "081294893800";
    myNumberController.text = "";

    super.initState();
    initLoc();
  }

  initLoc() async {
    Preferences objPreferences = Preferences();
    objPreferences.setLogoutManual(false);
    final getloc = Location();
    var dataLat = getloc.lat;
    var dataLong = getloc.long;
    var dataLoc = await getloc.getLocation();
    print("dataLocLat");
    print(dataLat);

    print("getlistask called");
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(37, 30, 37, 0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: MediaQuery.of(context).size.width, //160
                          image: const AssetImage(
                              'assets/images/logo_pit_elektronik.png'),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text("Masuk akun",
                            textAlign: TextAlign.center,
                            style:
                                AppTheme.OpenSans600(31, AppTheme.warnaHitam)),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                            "Mohon masuk menggunakan user login yang sudah terdaftar.",
                            style: AppTheme.OpenSans400LS(
                                14, AppTheme.warnaHitam, -0.36)),
                        Container(
                          margin: EdgeInsets.only(top: 32),
                          child: Form(
                            key: _formKey,
                            child: Theme(
                              data: themeData.copyWith(
                                  inputDecorationTheme:
                                      AppTheme.loginDecorationTheme()),
                              child: TextFormField(
                                style: AppTheme.OpenSans400LS(
                                    22, AppTheme.warnaHitam, 0.7),
                                decoration: const InputDecoration(
                                  hintText: 'User Login',
                                  hintStyle: TextStyle(
                                      fontSize: 15, fontFamily: 'OpenSans'),
                                ),
                                controller: myNumberController,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 24),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.warnaHijau,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(72.5)),
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _state = 0;
                                  if (_state == 0) {
                                    animateButton();
                                  }
                                });
                                // String strPhone = myNumberController.text;
                                String strMessage = "";
                                String nomer = "";
                                if (myNumberController.text != "") {
                                  nomer = myNumberController.text;
                                }
                                if (nomer == "") {
                                  strMessage = "Harap masukan user login anda.";
                                  setState(() {
                                    _state = 0;
                                  });
                                } else {
                                  UserNetwork objUserNetwork = UserNetwork();

                                  Network objNetwork =
                                      await objUserNetwork.getUserLogin(nomer);
                                  if (objNetwork.Status) {
                                    if (_state == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginOtp(
                                            Type: "otp",
                                            Phone: nomer,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _state = 0;
                                      });
                                    }
                                  } else {
                                    print("response api login");
                                    print(objNetwork.Data);
                                    print(objNetwork.Status);
                                    print(objNetwork.Message);
                                    print(objNetwork.Error);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(objNetwork.Message
                                                .toString())));
                                    setState(() {
                                      _state = 0;
                                    });
                                  }
                                }

                                if (strMessage != "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(strMessage)));
                                }
                              },
                              child: setUpButtonChild(),
                            )),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Login",
        style: AppTheme.OpenSans600(16, Colors.white),
      );
    } else if (_state == 1) {
      Future.delayed(const Duration(seconds: 10), () async {
        if (_state == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login gagal, harap coba lagi")));
        }
        setState(() {
          _state = 0;
        });
      });
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Text(
        "Login",
        style: TextStyle(fontSize: 17),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });
  }
}
