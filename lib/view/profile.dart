import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pit/model/mNetwork.dart';
import 'package:pit/model/mUser.dart';
import 'package:pit/network/user.dart';
import 'package:pit/utils/SizeConfig.dart';
import 'package:pit/utils/boxData.dart';
import 'package:pit/viewmodel/vmUser.dart';

import '../helpers/Preferences.dart';

import '../themes/AppTheme.dart';

class Profile extends StatefulWidget {
  final User _User;

  const Profile(this._User, {super.key});

  @override
  State<Profile> createState() => _ProfileState(_User);
}

class _ProfileState extends State<Profile> {
  final User _User;

  _ProfileState(this._User);

  double fit(double angka, double screen) => (angka);
  String dropdownValue = 'Teknisi Internal';
  List<String> lstTeknisi = ['Teknisi Internal', 'Mitra'];
  final myFullNameController = TextEditingController();
  final myAreaController = TextEditingController();
  final myPhonenumberController = TextEditingController();
  final mySkillController = TextEditingController();

  String alerts = '';
  File _image = File("");

  File _imageSelect = File("");
  final _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  _imgFromCamera() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      print(image.path);
      setState(() {
        _image = image;
        _imageSelect = image;
      });
    }
  }

  _imgFromGallery() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
      print(pickedFile);
      if (pickedFile != null) {
        File image = File(pickedFile.path);
        print(image.path);
        _image = image;
        _imageSelect = image;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak mendapatkan aksess file')));
      }
    } catch (e) {
      print("error gallery ${e}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak mendapatkan aksess file')));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text('Photo Library',
                          style: AppTheme.OpenSans400(
                              14, const Color(0xFF333333))),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text('Camera',
                        style:
                            AppTheme.OpenSans400(14, const Color(0xFF333333))),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markedPage();

    myFullNameController.text = _User.Name.toString();
    myAreaController.text = _User.Area.toString();
    myPhonenumberController.text = _User.Phone.toString();
    mySkillController.text = _User.Kemampuan.toString();
    _image = File(_User.Picture.toString());
  }

  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "profile");
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.warnaUngu,
          leading: IconButton(
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.keyboard_arrow_left, size: 40),
          ),
          centerTitle: true,
          title: Text(
            'Ubah Akun',
            style: AppTheme.appBarTheme(),
          ),
        ),
        body: ListView(children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    fit(37.0, MediaQuery.of(context).size.width),
                    0,
                    fit(37.0, MediaQuery.of(context).size.width),
                    fit(30.0, MediaQuery.of(context).size.height)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Container(
                              width: MySize.getScaledSizeWidth(79),
                              height: MySize.getScaledSizeHeight(79),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: _image.path.toString() != ""
                                    ? DecorationImage(
                                        image: FileImage(_image),
                                        fit: BoxFit.fill)
                                    : const DecorationImage(
                                        image: AssetImage(
                                            "./assets/images/default_gambar.png"),
                                        fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _User.Name.toString(),
                            style: AppTheme.OpenSans600(
                                16, const Color(0xFF272E3D)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                side: const BorderSide(
                                    color: Color(0xFF00A09D),
                                    width: 2,
                                    style: BorderStyle.solid),
                                backgroundColor: Colors.white,
                                minimumSize: const Size(130, 38),
                                padding:
                                    const EdgeInsets.only(left: 37, right: 37),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                ),
                              ),
                              onPressed: () async {
                                _showPicker(context);
                              },
                              child: Text(
                                "Ubah Foto",
                                style: AppTheme.OpenSans500(
                                    15, const Color(0xFF00A09D)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(20.0, MediaQuery.of(context).size.height)),
                        child: Text(
                          "Nama",
                          style:
                              AppTheme.OpenSans500(10, const Color(0xFF737373)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(5.0, MediaQuery.of(context).size.height)),
                        child: TextFormField(
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans',
                              color: Color(0xFF2C2948)),
                          controller: myFullNameController,
                          maxLines: 1, // max baris
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 20.0, right: 10.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (alerts == "") {
                                alerts = 'Harap masukan nama anda';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(10.0, MediaQuery.of(context).size.height)),
                        child: Text(
                          "Nomor Ponsel",
                          style:
                              AppTheme.OpenSans500(10, const Color(0xFF737373)),
                        ),
                      ),
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(
                              top:
                                  fit(5.0, MediaQuery.of(context).size.height)),
                          child: TextFormField(
                            enabled: false,
                            style: AppTheme.OpenSans400(
                                15, const Color(0xff000000)),
                            controller: myPhonenumberController,
                            maxLines: 1, // max baris
                            decoration: InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintText: "+62 " + _User.Phone.toString()),
                            // decoration: InputDecoration(
                            //   contentPadding: EdgeInsets.only(
                            //       left: 15.0, right: 10.0),
                            // ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only num
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     if (alerts == "") {
                            //       alerts =
                            //           'Harap masukan nomor handphone anda';
                            //     }
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(10.0, MediaQuery.of(context).size.height)),
                        child: Text(
                          "Area",
                          style:
                              AppTheme.OpenSans500(10, const Color(0xFF737373)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(5.0, MediaQuery.of(context).size.height)),
                        child: TextFormField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans',
                              color: Color(0xFF2C2948)),
                          controller: myAreaController,
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(
                              hintText: _User.Area.toString()),
                          // decoration: InputDecoration(
                          //   contentPadding:
                          //       EdgeInsets.only(left: 20.0, right: 10.0),
                          //   focusColor: Colors.white70,
                          // ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     if (alerts == "") {
                          //       alerts = 'Harap masukan area anda';
                          //     }
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(10.0, MediaQuery.of(context).size.height)),
                        child: Text(
                          "KEMAMPUAN",
                          style:
                              AppTheme.OpenSans500(10, const Color(0xFF737373)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(5.0, MediaQuery.of(context).size.height)),
                        child: TextFormField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans',
                              color: Color(0xFF2C2948)),
                          controller: mySkillController,
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(
                              hintText: _User.Kemampuan.toString()),
                          // decoration: InputDecoration(
                          //   contentPadding:
                          //       EdgeInsets.only(left: 20.0, right: 10.0),
                          //   focusColor: Colors.white70,
                          // ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     if (alerts == "") {
                          //       alerts = 'Harap masukan kemampuan anda';
                          //     }
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                          height:
                              fit(11.0, MediaQuery.of(context).size.height)),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(10.0, MediaQuery.of(context).size.height)),
                        child: Text(
                          "STATUS",
                          style:
                              AppTheme.OpenSans500(10, const Color(0xFF737373)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: fit(5.0, MediaQuery.of(context).size.height)),
                        child: TextFormField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans',
                              color: Color(0xFF2C2948)),
                          // controller: mySkillController,
                          initialValue: _User.Status.toString(),
                          maxLines: 1,
                          // decoration: InputDecoration(
                          //   contentPadding:
                          //       EdgeInsets.only(left: 20.0, right: 10.0),
                          //   focusColor: Colors.white70,
                          // ),
                          decoration: InputDecoration.collapsed(
                              hintText: _User.Status.toString()),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     if (alerts == "") {
                          //       alerts = 'Harap masukan kemampuan anda';
                          //     }
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                          height:
                              fit(11.0, MediaQuery.of(context).size.height)),
                      // InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelStyle: AppTheme.OpenSans400(15, Color(0xff000000)),
                      //     floatingLabelStyle:
                      //         AppTheme.OpenSans400(15, Color(0xff000000)),
                      //     enabledBorder: OutlineInputBorder(
                      //         gapPadding: 1.0,
                      //         borderRadius: BorderRadius.circular(5.0),
                      //         borderSide: BorderSide(
                      //             color: const Color(0xFF27394E).withOpacity(0.2),
                      //             width: 1.0 * MySize.scaleFactorWidth)),
                      //   ),
                      //   child: Container(
                      //     height: 23 * MySize.scaleFactorHeight,
                      //     child: DropdownButtonHideUnderline(
                      //       child: DropdownButton<String>(
                      //         hint: Container(
                      //           width: 150,
                      //           //and here
                      //           child: Text(
                      //             "Pilih kemampuan anda",
                      //             style: AppTheme.OpenSans400(15, Colors.grey),
                      //             textAlign: TextAlign.end,
                      //           ),
                      //         ),
                      //         isExpanded: true,
                      //         value: dropdownValue,
                      //         // style: AppTheme.OpenSans400(15, Color(0xff000000)),
                      //         style: AppTheme.OpenSans400(15, Colors.grey),
                      //         items: lstTeknisi
                      //             .map<DropdownMenuItem<String>>((String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 value == dropdownValue
                      //                     ? SizedBox(
                      //                         width: 20,
                      //                         child: Icon(
                      //                           Icons.radio_button_checked,
                      //                           size: MySize.size20,
                      //                           color: Color(0xFF008199),
                      //                         ),
                      //                       )
                      //                     : SizedBox(
                      //                         width: 20,
                      //                         child: Icon(
                      //                           Icons.radio_button_off,
                      //                           size: MySize.size20,
                      //                           color: Color(0xFF008199),
                      //                         ),
                      //                       ),
                      //                 Container(
                      //                   margin: EdgeInsets.only(left: 10),
                      //                   child: Text(
                      //                     value,
                      //                     // style: AppTheme.OpenSans400(
                      //                     //     15, Color(0xff000000)),
                      //                     style:
                      //                         AppTheme.OpenSans400(15, Colors.grey),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         }).toList(),
                      //         // onChanged: (String? value) {// aktifkan ketika opsi tidak disable
                      //         //   setState(() {
                      //         //     dropdownValue = value!;
                      //         //   });
                      //         // },
                      //         onChanged: null,
                      //         selectedItemBuilder: (BuildContext context) {
                      //           return lstTeknisi.map<Widget>((String item) {
                      //             return Text(item,
                      //                 style: AppTheme.OpenSans400(15, Colors.grey));
                      //             // style: AppTheme.OpenSans400(
                      //             //         15, Color(0xff000000)));
                      //           }).toList();
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 15 * MySize.scaleFactorHeight,
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       top: fit(5.0, MediaQuery.of(context).size.height)),
                      //   child: TextFormField(
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         fontFamily: 'OpenSans',
                      //         color: Color(0xFF2C2948)),
                      //     controller: myReasonController,
                      //     maxLines: 3,
                      //     decoration: InputDecoration(
                      //         contentPadding:
                      //             EdgeInsets.fromLTRB(20.0, 20, 20.0, 20),
                      //         hintText: "Mohon masukkan alasan perubahan…"),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         if (alerts == "") {
                      //           alerts = 'Harap masukan alasan anda';
                      //         }
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Container(
                          margin: EdgeInsets.only(
                              top: fit(
                                  20.0, MediaQuery.of(context).size.height)),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.warnaHijau,
                                minimumSize: const Size(330, 50),
                                padding:
                                    const EdgeInsets.only(left: 37, right: 37),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              onPressed: () async {
                                String tanggal =
                                    DateFormat('dd/MM/yyyy HH:mm:ss')
                                        .format(DateTime.now());
                                String nFullname = myFullNameController.text;
                                String nArea = myAreaController.text;
                                String nPhonenumber =
                                    myPhonenumberController.text;
                                String nReason = "";

                                if (_formKey.currentState!.validate()) {
                                  if (nFullname == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(alerts)));

                                    alerts = "";
                                  } else {
                                    String strPicture = _image.path;
                                    File newImage = File("");

                                    if (_imageSelect.path != "") {
                                      Directory appDocumentsDirectory =
                                          await getApplicationDocumentsDirectory();
                                      String appDocumentsPath =
                                          appDocumentsDirectory.path;

                                      newImage = await _imageSelect.copy(
                                          '$appDocumentsPath/profile_User.jpg');
                                      strPicture = _imageSelect.path;
                                    }
                                    Preferences pref = Preferences();

                                    int userActive = await pref.getUserActive();
                                    UserNetwork objUserNetwork = UserNetwork();
                                    Network objNetwork =
                                        await objUserNetwork.getUserEdit(
                                            Phone: nPhonenumber,
                                            Nama: nFullname,
                                            Area: nArea,
                                            Reason: nReason,
                                            PicProfile: newImage,
                                            user_active: userActive);
                                    if (objNetwork.Status) {
                                      vmUser objUser = vmUser();
                                      await objUser.getEditUser(
                                          Name: nFullname,
                                          Phone: nPhonenumber,
                                          Area: nArea,
                                          Picture: strPicture);

                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Gagal menyimpan perubahan")));
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //         content: Text(objNetwork.Message
                                      //             .toString())));
                                    }
                                  }
                                }
                              },
                              child: Text(
                                "Simpan",
                                style: AppTheme.OpenSans500(
                                    17, const Color(0xFFFFFFFF)),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onLongPress: () async {
                      List pending = [];
                      final boxdata =
                          boxData(nameBox: "box_setLoginCredential");

                      String userId =
                          await boxdata.getLoginCredential(param: "userId");
                      final boxOpendataupload =
                          await Hive.openBox("box_listUploadWorksheet");
                      final boxAddndataupload =
                          Hive.box("box_listUploadWorksheet");

                      bool checkdata = false;
                      if (boxOpendataupload.isNotEmpty) {}
                      await showDialog(
                            //show confirm dialogue
                            //the return value will be from "Yes" or "No" options
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Peringatan',
                                style: AppTheme.OpenSans600(18, Colors.red),
                              ),
                              // content: Text('Do you want to exit an App?'),
                              content: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                    textScaler: const TextScaler.linear(1.0)),
                                child: Container(
                                  child: Wrap(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Apakah anda yakin ingin mereset status upload data pada List Upload?',
                                            style: AppTheme.OpenSans500(
                                                15, Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                                                              Radius.circular(
                                                                  40)),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    final boxdata = boxData(
                                                        nameBox:
                                                            "box_setLoginCredential");

                                                    String userId =
                                                        await boxdata
                                                            .getLoginCredential(
                                                                param:
                                                                    "userId");
                                                    final boxOpendataupload =
                                                        await Hive.openBox(
                                                            "box_listUploadWorksheet");
                                                    final boxAddndataupload =
                                                        Hive.box(
                                                            "box_listUploadWorksheet");

                                                    bool checkdata = false;
                                                    if (boxOpendataupload
                                                        .isNotEmpty) {
                                                      if (userId != 0) {
                                                        final data =
                                                            boxOpendataupload
                                                                .get(userId);
                                                        if (data != null &&
                                                            data.length != 0) {
                                                          for (var val
                                                              in data) {
                                                            val['upload'] = 0;
                                                            print(val);
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                          print(data);
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "tidak ada data di listupload")));
                                                        }
                                                      }
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "tidak ada data di listupload")));
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Ya",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      MySize.getScaledSizeWidth(
                                                          5)),
                                              Expanded(
                                                  child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  // elevation: 13,
                                                  backgroundColor:
                                                      AppTheme.warnaHijau,
                                                  minimumSize:
                                                      const Size(180, 40),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 37, right: 37),
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
                                                      fontFamily: 'OpenSans',
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
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
