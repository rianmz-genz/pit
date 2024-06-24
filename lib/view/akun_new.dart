import 'package:flutter/material.dart';
import 'package:pit/utils/SizeConfig.dart';

import 'package:pit/view/homescreen.dart';

class AccountNew extends StatefulWidget {
  const AccountNew({super.key});

  @override
  State<AccountNew> createState() => _AccountNewState();
}

class _AccountNewState extends State<AccountNew> {
  double fit(double angka, double screen) => (angka);

  final objCtrlFullName = TextEditingController();
  final objCtrlEmail = TextEditingController();
  final objCtrlPhoneNumber = TextEditingController();

  @override
  void disopose() {
    objCtrlEmail.dispose();
    objCtrlFullName.dispose();
    objCtrlPhoneNumber.dispose();
    super.dispose();
  }

  final String _Message = '';
  final bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          fit(30.0, MediaQuery.of(context).size.width),
                          fit(30.0, MediaQuery.of(context).size.height),
                          fit(30.0, MediaQuery.of(context).size.width),
                          fit(30.0, MediaQuery.of(context).size.height)),
                      child: Column(
                        children: [
                          Image(
                            width: MySize.getScaledSizeWidth(250), //160
                            image: const AssetImage('assets/images/thumb.png'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Selesai!",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w500)),
                          Container(
                            margin: EdgeInsets.only(
                                top: fit(
                                    80.0, MediaQuery.of(context).size.height)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(250, 50),
                                padding:
                                    const EdgeInsets.only(left: 37, right: 37),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(0),
                                    ));
                              },
                              child: const Text(
                                "Beranda",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
