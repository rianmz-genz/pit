import 'package:pit/helpers/db_helpers.dart';
import 'package:pit/model/mUser.dart';

class vmUser {
  Future<void> getEditUser(
      {String? Name,
      String? Phone,
      String? Area,
      String? Picture,
      String? Kemampuan,
      String? Status}) async {
    final DbHelper _helper = new DbHelper();
    print("picture");
    print(Picture);
    User _User = User(
        id: 1,
        Name: Name,
        Phone: Phone,
        Area: Area,
        Picture: Picture,
        Kemampuan: Kemampuan,
        Status: Status);

    await _helper.update(UserQuery.TABLE_NAME, _User.toMap());
  }

  Future<User> getUserData() async {
    final DbHelper _helper = new DbHelper();

    User _User = User(id: 0, Picture: "");

    await _helper.getData(
        tableName: UserQuery.TABLE_NAME,
        strWhere: "id = ?",
        whereArgs: [1]).then((value) {
      value.forEach((element) {
        // print('select user');
        // print(element);
        _User = User.fromJson(element);
      });
    });

    String sql = "Select * From User ";
    final db = await _helper.openDB();
    var result = await db.rawQuery(sql);

    print('select user');
    print(result.toList());

    return _User;
  }
}
