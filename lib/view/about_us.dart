import 'package:flutter/material.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.warnaUngu,
            leading: IconButton(
              splashColor: AppTheme.warnaUngu,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.keyboard_arrow_left, size: 40),
            ),
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text(
              "Tentang Kami",
              style: AppTheme.appBarTheme(),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
            child: ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Text(
                    "PIT elektronik berdiri pada tahun 1995, fokus pada jasa service/perbaikan dan"
                    " menjual spare part khusus unit-unit pendingin. Komitment kami adalah memberikan"
                    " pelayanan yang terbaik dan berkualitas. Selama ini PIT elektronik melayani perusahaan2"
                    " berscala nasional ataupun lokal yang memiliki unit pendingin seperti cold storage, freezer,"
                    " showcase, coldcar, cake display, blast freezer, waterchiller,dsb ",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Text(
                    "PIT elektronik memiliki cabang di Bekasi, Bandung, Yogya, Surabaya, Denpasar dan kota2 lain di Indonesia."
                    " Kualitas pekerjaan dan kualitas spare part yang kami gunakan telah diakui secara luas dan kami terus berusaha "
                    "memberikan yang terbaik. PIT elektronik secara berkala memberikan pelatihan bagi teknisi-teknisinya agar memilki k"
                    "ualitas yang sama dan mendapatkan informasi akan teknologi pendingin terbaru.",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
