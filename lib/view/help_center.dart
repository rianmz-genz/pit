import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

class HelpCenter extends StatelessWidget {
  HelpCenter({Key? key}) : super(key: key);

  List<dynamic> ListData = [
    {
      "workshop": "Workshop I : JAKARTA",
      "alamat": "Jl. Kebon kelapa No 68,",
      "wilayah": "Tambun, Bekasi – Jawa Barat",
      "telepon": "+6221- 88331146, 88363469",
      "fax": "+6221-88363472"
    },
    {
      "workshop": "Workshop II : SURABAYA",
      "alamat": "Pergudangan Meiko Abadi blok B / 53",
      "wilayah": "Desa Wedi, Betro Gedangan,",
      "telepon": "Sidoarjo – Jawa Timur",
      "fax": ""
    },
    {
      "workshop": "Workshop III : DENPASAR",
      "alamat": "Jl. Merdeka IV No 7 Renon,",
      "wilayah": "Denpasar – Bali",
      "telepon": "",
      "fax": ""
    },
    {
      "workshop": "Workshop IV : YOGYAKARTA",
      "alamat":
          "Jl. Kabupaten Mayangan, RT.5/RW.14,Ngawean, Trihanggo, Kec. Gamping, Kabupaten Sleman",
      "wilayah": "Daerah Istimewa Yogyakarta 55291",
      "telepon": "",
      "fax": ""
    },
    {
      "workshop": "Workshop V : MATARAM",
      "alamat": "Jl. Saleh Sungkar 16 D Dayen Peken, Ampenan Utara, 83511",
      "wilayah": "Mataram – NTB.",
      "telepon": "",
      "fax": ""
    }
  ];

  Widget Teks(String data) {
    return Column(
      children: [
        Text(
          data,
          style: const TextStyle(
              fontFamily: "OpenSans", fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  List<Widget> widgetBuilder(List data) {
    List<Widget> lstWidget = [];
    for (var val in data) {
      if (val['workshop'] != "") {
        lstWidget.add(Teks(val['workshop']));
      }
      if (val['alamat'] != "") {
        lstWidget.add(Teks(val['alamat']));
      }
      if (val['wilayah'] != "") {
        lstWidget.add(Teks(val['wilayah']));
      }
      if (val['telepon'] != "") {
        final telepon = "Tlp : " + val["telepon"];
        lstWidget.add(Teks(telepon));
      }
      if (val['fax'] != "") {
        final fax = "Fax : " + val['fax'];
        lstWidget.add(Teks(fax));
      }
      lstWidget.add(const SizedBox(
        height: 20,
      ));
    }
    return lstWidget;
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.warnaUngu,
            actions: [],
            leading: IconButton(
              splashColor: AppTheme.warnaUngu,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.keyboard_arrow_left, size: 40),
            ),
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text(
              "Pusat Bantuan",
              style: AppTheme.appBarTheme(),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: ListView(
                children: [
                  const Text(
                    "Untuk anda yang berada diwilayah ini dapat menghubungi kami di",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetBuilder(ListData),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
