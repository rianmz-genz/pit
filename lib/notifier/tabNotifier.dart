import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TabNotifier extends ChangeNotifier {
  int tabbar = 0;
  dynamic Task;
  TabNotifier(this.Task) {
    init();
  }

  init() async {
    await getData(this.Task['id']);
    print("provider init");

    notifyListeners();
  }

  nilai() => tabbar;

  updateList() async {
    print('update tabbar semua');
    // tabbar = await getData(this.Task['id']);
    tabbar = 1;
    notifyListeners();
  }

  Future<int> getData(dynamic id) async {
    late int tabBar = 0;
    var commonSetting = await Hive.openBox("box_workSheetSetting");

    if (commonSetting.isNotEmpty) {
      final data = commonSetting.get(id.toString());
      print(data);
      if (data == null) {
        print("data with $id is empty line 35");
        cetak("data  with $id is not empty line 36", null);
      } else {
        cetak("data  with $id is not empty line 38", data);
        tabBar = data['tabSetting'];

        // var box_AddcommonSetting = await Hive.box("box_commonSetting");
        //
        // box_AddcommonSetting.put(id.toString(), "");
      }
    } else {
      //isi box
      // var box_AddWorksheetForm = Hive.box("box_commonSetting");
      print("box_workSheetSetting is  empty 48");

      // box_AddWorksheetForm.put(taskId.toString(), valServer);
    }
    return tabBar;
  }

  cetak(String title, dynamic data) {
    if (title != "") print(title);
    if (data != null) print(data);
  }
}
