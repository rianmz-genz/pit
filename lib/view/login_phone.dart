import 'package:flutter/cupertino.dart';

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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                        Text("Masuk akun",
                            textAlign: TextAlign.center,
                            style:
                                AppTheme.OpenSans600(31, AppTheme.warnaHitam)),
                        SizedBox(
                          height: 54 * MySize.scaleFactorHeight,
                        ),
                        Text("Mohon masukkan nomor handphone anda",
                            style: AppTheme.OpenSans400LS(
                                14, AppTheme.warnaHitam, -0.36)),
                        Container(
                          constraints:
                              BoxConstraints(minWidth: 300, maxWidth: 300),
                          margin: EdgeInsets.only(
                              top: 23 * MySize.scaleFactorHeight),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      '+62',
                                      style: AppTheme.OpenSans400LS(
                                          25, AppTheme.warnaHitam, 0.74),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Container(
                                    child: Text(
                                      '|',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontSize: 25,
                                          color: const Color(0xFF2C2948)
                                              .withOpacity(0.2)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Expanded(
                                    child: Form(
                                      key: _formKey,
                                      child: Theme(
                                        data: themeData.copyWith(
                                            inputDecorationTheme: AppTheme
                                                .loginDecorationTheme()),
                                        child: TextFormField(
                                          style: AppTheme.OpenSans400LS(
                                              25, AppTheme.warnaHitam, 0.7),
                                          decoration: const InputDecoration(
                                            hintText: ' nomor handphone',
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          controller: myNumberController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 105 * MySize.scaleFactorHeight,
                        ),
                        Container(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.warnaHijau,
                            minimumSize: Size(289 * MySize.scaleFactorWidth,
                                63 * MySize.scaleFactorHeight),
                            padding: EdgeInsets.only(
                                left: 43 * MySize.scaleFactorWidth,
                                right: 43 * MySize.scaleFactorWidth),
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
                              if (myNumberController.text[0] != "0") {
                                nomer = "0" + myNumberController.text;
                              } else {
                                nomer = myNumberController.text;
                              }
                            }
                            if (nomer == "") {
                              strMessage =
                                  "Harap masukan nomor handphone anda.";
                              setState(() {
                                _state = 0;
                              });
                            } else if (nomer.length < 10) {
                              strMessage =
                                  "Periksa kembali nomor handphone anda.";
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
                                        content: Text(
                                            objNetwork.Message.toString())));
                                // Text('gagal login ga dpt respon dari api')));
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
                        // Container(
                        //   margin:
                        //       EdgeInsets.only(top: 23 * MySize.scaleFactorHeight),
                        //   child: RichText(
                        //     text: TextSpan(
                        //         text: 'Belum punya akun? ',
                        //         style: AppTheme.OpenSans400LS(
                        //             14, AppTheme.warnaHitam, -0.36),
                        //         children: <TextSpan>[
                        //           TextSpan(
                        //               text: 'Daftar',
                        //               style: AppTheme.OpenSans600LS(
                        //                   14, AppTheme.warnaHitam, -0.36),
                        //               recognizer: TapGestureRecognizer()
                        //                 ..onTap = () {
                        //                   Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                       builder: (context) => Register(),
                        //                     ),
                        //                   );
                        //                   // navigate to desired screen
                        //                 })
                        //         ]),
                        //   ),
                        // ),
                        SizedBox(
                          height: 86 * MySize.scaleFactorHeight,
                        ),
                        Image(
                          width: MySize.getScaledSizeWidth(250), //160
                          image: const AssetImage(
                              'assets/images/logo_pit_elektronik.png'),
                        )
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
