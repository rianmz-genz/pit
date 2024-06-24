import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pit/helpers/Preferences.dart';
import 'package:pit/model/mUser.dart';
import 'package:pit/viewmodel/vmUser.dart';

class UserNotifier extends ChangeNotifier {
  User _User = User(id: 0, Picture: "");
  int countDataUpload = 0;
  int user_active = 0;

  UserNotifier() {
    init();
  }

  init() async {
    Preferences pref = Preferences();

    user_active = await pref.getUserActive();

    vmUser objUser = vmUser();
    _User = await objUser.getUserData();

    notifyListeners();
  }

  getuser_active() => user_active;
  getUser() => _User;

  getUploadData() async {
    var boxOpenvalueworksheet = await Hive.openBox("box_valworksheet");

    bool checkdata = false;
    if (boxOpenvalueworksheet.isNotEmpty) {
      if (_User.id != 0) {
        final data = boxOpenvalueworksheet.get(_User.id);
        if (data != null && data.length != 0) {
          countDataUpload = data.length;
        }
      }
    }
    return countDataUpload;
  }

  Future<void> updateList() async {
    print('update');
    Preferences pref = Preferences();

    user_active = await pref.getUserActive();
    vmUser objUser = vmUser();
    _User = await objUser.getUserData();

    notifyListeners();
  }
}
