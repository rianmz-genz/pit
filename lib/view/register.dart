// import 'package:flutter/material.dart';
// import 'package:pit/model/mNetwork.dart';
// import 'package:pit/network/user.dart';
// import 'package:pit/utils/SizeConfig.dart';
// import 'package:pit/view/TermsAndConditions.dart';
// import 'package:pit/view/login_otp.dart';
// import 'package:pit/themes/AppTheme.dart';
// import 'package:pit/view/login_phone.dart';
// import 'package:pit/viewmodel/vmUser.dart';
//
// class Register extends StatefulWidget {
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//   double fit(double angka, double screen) => (angka);
//
//   final objCtrlFullName = TextEditingController();
//   final objCtrlEmail = TextEditingController();
//   final objCtrlPhoneNumber = TextEditingController();
//
//   String _Message = '';
//   bool _isChecked = false;
//
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//       child: Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     child: Container(
//                       margin: EdgeInsets.fromLTRB(
//                           fit(30.0, MediaQuery.of(context).size.width),
//                           fit(30.0, MediaQuery.of(context).size.height),
//                           fit(30.0, MediaQuery.of(context).size.width),
//                           fit(30.0, MediaQuery.of(context).size.height)),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             Text("Selamat datang",
//                                 style: AppTheme.OpenSans600(
//                                     30, AppTheme.warnaHitam)),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: 21.0 * MySize.scaleFactorHeight),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "Mohon masukkan data berikut untuk",
//                                     style: AppTheme.OpenSans600(15,
//                                         AppTheme.warnaHitam.withOpacity(0.8)),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   Text(
//                                     "membuat akun anda",
//                                     style: AppTheme.OpenSans600(15,
//                                         AppTheme.warnaHitam.withOpacity(0.8)),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: 62.0 * MySize.scaleFactorHeight),
//                               child: Card(
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 child: Theme(
//                                   data: themeData.copyWith(
//                                       inputDecorationTheme:
//                                           AppTheme.loginDecorationTheme()),
//                                   child: TextFormField(
//                                     style: AppTheme.OpenSans500(
//                                         15, AppTheme.warnaHitam),
//                                     controller: objCtrlFullName,
//                                     maxLines: 1, // max baris
//
//                                     decoration: const InputDecoration(
//                                       contentPadding: EdgeInsets.only(
//                                           left: 29.0, right: 10.0),
//                                       hintText: 'Nama Lengkap',
//                                       hintStyle: TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                           fontFamily: 'OpenSans',
//                                           color: Color(0xFF75728D),
//                                           fontSize: 15),
//                                       focusColor: Colors.white70,
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         _Message = 'Harap lengkapi nama anda';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: fit(
//                                       5.0, MediaQuery.of(context).size.height)),
//                               child: Card(
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 child: Theme(
//                                   data: themeData.copyWith(
//                                       inputDecorationTheme:
//                                           AppTheme.loginDecorationTheme()),
//                                   child: TextFormField(
//                                     style: AppTheme.OpenSans500(
//                                         15, AppTheme.warnaHitam),
//                                     controller: objCtrlEmail,
//                                     maxLines: 1, // max baris
//
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.only(
//                                           left: 29.0, right: 10.0),
//                                       hintText: 'Alamat Email',
//                                       hintStyle: TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                           fontFamily: 'OpenSans',
//                                           fontSize: 15),
//                                       focusColor: Color(0xff75728D),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         if (_Message == "")
//                                           _Message =
//                                               'Harap lengkapi alamat email anda';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: fit(
//                                       5.0, MediaQuery.of(context).size.height)),
//                               child: Card(
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 child: Theme(
//                                   data: themeData.copyWith(
//                                       inputDecorationTheme:
//                                           AppTheme.loginDecorationTheme()),
//                                   child: TextFormField(
//                                     style: AppTheme.OpenSans500(
//                                         15, AppTheme.warnaHitam),
//                                     controller: objCtrlPhoneNumber,
//                                     maxLines: 1, // max baris
//
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.only(
//                                           left: 29.0, right: 10.0),
//                                       hintText: 'Nomor Handphone',
//                                       hintStyle: TextStyle(
//                                           fontStyle: FontStyle.italic,
//                                           fontFamily: 'OpenSans',
//                                           fontSize: 15),
//                                       focusColor: Color(0xFF75728D),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         if (_Message == "")
//                                           _Message =
//                                               'Harap lengkapi nomor handphone anda';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: 21.0 * MySize.scaleFactorHeight),
//                               child: FittedBox(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       margin:
//                                           EdgeInsets.only(left: 6, right: 9.0),
//                                       width: 26,
//                                       height: 26,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white70,
//                                           border: Border.all(
//                                             color: Colors.grey,
//                                             style: BorderStyle.solid,
//                                             width: 1.0,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(4)),
//                                       child: Transform.scale(
//                                         scale: 1.5,
//                                         child: Checkbox(
//                                             checkColor: AppTheme.warnaHijau,
//                                             activeColor: AppTheme.warnaHijau
//                                                 .withOpacity(0.2),
//                                             side: BorderSide(
//                                                 color: AppTheme.warnaHijau
//                                                     .withOpacity(0.2)),
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(4)),
//                                             value: _isChecked,
//                                             onChanged: (bool? value) {
//                                               setState(() {
//                                                 _isChecked = value!;
//                                               });
//                                             }),
//                                       ),
//                                     ),
//                                     Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Dengan membuat akun ini, anda telah setuju',
//                                             style: AppTheme.OpenSans400LS(
//                                                 13,
//                                                 AppTheme.warnaHitam
//                                                     .withOpacity(0.8),
//                                                 0.35),
//                                           ),
//                                           Row(children: [
//                                             Text('dengan',
//                                                 style: AppTheme.OpenSans400LS(
//                                                     13,
//                                                     AppTheme.warnaHitam
//                                                         .withOpacity(0.8),
//                                                     0.35)),
//                                             InkWell(
//                                               onTap: () {
//                                                 Navigator.push(context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) {
//                                                   return TermsAndConditions();
//                                                 }));
//                                               },
//                                               child: Text(
//                                                 " Ketentuan ",
//                                                 style: AppTheme.OpenSans700LS(
//                                                     13,
//                                                     AppTheme.warnaHitam,
//                                                     0.35),
//                                               ),
//                                             ),
//                                             Text('kami.',
//                                                 style: AppTheme.OpenSans400LS(
//                                                     13,
//                                                     AppTheme.warnaHitam
//                                                         .withOpacity(0.8),
//                                                     0.35)),
//                                           ]),
//                                         ])
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                                 margin: EdgeInsets.only(
//                                     top: 52.0 * MySize.scaleFactorHeight),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     onPrimary: AppTheme.warnaHijau,
//                                     primary: AppTheme.warnaHijau,
//                                     minimumSize: Size(289, 63),
//                                     padding:
//                                         EdgeInsets.only(left: 88, right: 88),
//                                     shape: const RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(72.5)),
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       if (_Message != "") {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 content: Text(_Message)));
//
//                                         _Message = "";
//                                         return null;
//                                       }
//                                       if (_isChecked == false) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 content: Text(
//                                                     "Centang pada box untuk menyetujui ketentuan.")));
//                                         return null;
//                                       }
//
//                                       UserNetwork objUserNetwork =
//                                           UserNetwork();
//
//                                       // Network objNetwork =
//                                       //     await objUserNetwork.getUserRegist(
//                                       //   strPhone: objCtrlPhoneNumber.text,
//                                       //   strEmail: objCtrlEmail.text,
//                                       //   strNama: objCtrlFullName.text,
//                                       // );
//
//                                       if (objNetwork.Status) {
//                                         vmUser objUser = vmUser();
//                                         await objUser.getEditUser(
//                                             Name: objCtrlFullName.text,
//                                             Phone: objCtrlPhoneNumber.text,
//                                             Area: objCtrlEmail.text);
//
//                                         Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => LoginOtp(
//                                                 Type: "regist",
//                                                 Phone: objCtrlPhoneNumber.text),
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 content: Text(objNetwork.Message
//                                                     .toString())));
//                                       }
//                                     }
//                                   },
//                                   child: Text(
//                                     "Daftar",
//                                     style: AppTheme.OpenSans600LS(
//                                         16, Colors.white, -0.41),
//                                   ),
//                                 )),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: 20 * MySize.scaleFactorHeight),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text("Sudah punya akun? ",
//                                       style: AppTheme.OpenSans400LS(
//                                           14, AppTheme.warnaHitam, -0.36)),
//                                   InkWell(
//                                     onTap: () async {
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LoginPhone()));
//                                     },
//                                     child: Text(
//                                       "Masuk",
//                                       style: AppTheme.OpenSans700LS(
//                                           14, AppTheme.warnaHitam, -0.36),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
