
import 'package:flutter/material.dart';

import 'package:pit/themes/AppTheme.dart';
import 'package:pit/utils/SizeConfig.dart';

class Notif_detail extends StatelessWidget {
  const Notif_detail({Key? key}) : super(key: key);

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
              'Notifikasi',
              style: AppTheme.appBarTheme(),
              textAlign: TextAlign.center,
            ),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.fromLTRB(15, 17, 23, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image(
                          width: 250 * MySize.scaleFactorWidth, //160
                          image: const AssetImage(
                              'assets/images/logo_pit_elektronik.png'),
                        ),
                      ),
                      SizedBox(
                        height: 30 * MySize.scaleFactorHeight,
                      ),
                      Text(
                        "Selamat!",
                        style: AppTheme.OpenSans600(20, const Color(0xFF060606)),
                      ),
                      SizedBox(
                        height: 3 * MySize.scaleFactorHeight,
                      ),
                      Text(
                        "2 Jun 2020",
                        style: AppTheme.OpenSans500(
                            13, const Color(0xFF000000).withOpacity(0.4)),
                      ),
                      SizedBox(
                        height: 18 * MySize.scaleFactorHeight,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.In consequat venenatis turpis…",
                        textAlign: TextAlign.start,
                        style: AppTheme.OpenSans500(15, const Color(0xFF060606)),
                      ),
                      SizedBox(
                        height: 5 * MySize.scaleFactorHeight,
                      ),
                      Text(
                        "Lokasi : Jl. Garuda No.32, RT.1/RW.4, Kemayoran, Kec. Kemayoran, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10620",
                        textAlign: TextAlign.start,
                        style: AppTheme.OpenSans500(15, const Color(0xFF060606)),
                      ),
                      SizedBox(
                        height: 5 * MySize.scaleFactorHeight,
                      ),
                      Text(
                        "Status Garansi : Tidak",
                        textAlign: TextAlign.start,
                        style: AppTheme.OpenSans500(15, const Color(0xFF060606)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
