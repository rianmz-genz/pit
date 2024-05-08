import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pit/utils/boxData.dart';

import '../themes/AppTheme.dart';

class informationPage extends StatelessWidget {
  const informationPage({Key? key}) : super(key: key);
  markedPage() async {
    final BoxData = boxData(nameBox: "box_MarkedPage");
    await BoxData.markedPage(namePage: "information");
  }

  @override
  Widget build(BuildContext context) {
    markedPage();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.warnaUngu,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            return Navigator.of(context).pop();
          },
          icon: Icon(Icons.keyboard_arrow_left, size: 40),
        ),
        centerTitle: true,
        title: const Text(
          "Information",
          // "task name",
          // "LPU",
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tab Stop"),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                minimumSize: Size(259, 63),
                padding: EdgeInsets.only(left: 43, right: 43),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: AppTheme.warnaHijau,
                      width: 1.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(72.5)),
                ),
              ),
              onPressed: () {},
              child: Text("Lanjut Checking",
                  style:
                      AppTheme.OpenSans600LS(16, AppTheme.warnaHijau, -0.41)),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Tombol ini digunakan untuk melanjutkan proses Cheking dari pengisian data di worksheet atau LPU",
              // style: TextStyle(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.warnaHijau,
                // minimumSize: Size(60, 63),
                fixedSize: const Size(60, 63),
                padding: const EdgeInsets.only(left: 43, right: 43),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(72.5)),
                ),
              ),
              onPressed: () {},
              child: Text("Lanjut Fixing",
                  style: AppTheme.OpenSans600LS(16, Colors.white, -0.41)),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Tombol ini digunakan untuk melanjutkan ke proses Fixing dari pengisian data di worksheet atau LPU",
              // style: TextStyle(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.warnaHijau,
                // minimumSize: Size(60, 63),
                fixedSize: Size(60, 63),
                padding: EdgeInsets.only(left: 43, right: 43),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(72.5)),
                ),
              ),
              onPressed: () {},
              child: Text("Lanjut Kirim",
                  style: AppTheme.OpenSans600LS(16, Colors.white, -0.41)),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Tombol ini digunakan untuk menandakan bahwa proses pengisian di worksheet atau LPU telah selesai",
              // style: TextStyle(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                minimumSize: Size(60, 63),
                padding: EdgeInsets.only(left: 43, right: 43),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: AppTheme.warnaDongker,
                      width: 1.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(72.5)),
                ),
              ),
              onPressed: () {},
              child: Text("Serahkan ke orang lain",
                  style:
                      AppTheme.OpenSans600LS(16, AppTheme.warnaDongker, -0.41)),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Tombol ini digunakan untuk menyerahkan pekerjaan kepada teknisi lain",
              // style: TextStyle(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      )),
    );
  }
}
