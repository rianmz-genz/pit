import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<void> SetLoginCredential(
      {required String secretKey,
      required String token,
      required String Phone,
      required String UserId,
      required String Otp}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("secretKey", secretKey);
    sharedPreferences.setString("token", token);
    sharedPreferences.setString("phone", Phone);
    sharedPreferences.setString("userid", UserId);
    sharedPreferences.setString("otp", Otp);
  }

  // Future<String> getToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? data = sharedPreferences.getString("token");
  //   String strReturn = data == null ? "" : data;
  //
  //   return strReturn;
  // }
  //
  // Future<String> getOtp() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? data = sharedPreferences.getString("otp");
  //   String strReturn = data == null ? "" : data;
  //
  //   return strReturn;
  // }

  // Future<String> getSecretKey() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? data = sharedPreferences.getString("secretKey");
  //   String strReturn = data == null ? "" : data;
  //
  //   return strReturn;
  // }

  // Future<String> getPhone() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? data = sharedPreferences.getString("phone");
  //   String strReturn = data == null ? "" : data;
  //
  //   return strReturn;
  // }

  Future<int> getUserActive() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? data = sharedPreferences.getInt("userActive");
    int strReturn = data ?? 0;

    return strReturn;
  }

  Future<int> getChckProf() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? data = sharedPreferences.getInt("chckProf");
    int strReturn = data ?? 0;

    return strReturn;
  }

  Future<bool> getLogoutManual() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? data = sharedPreferences.getBool("logoutManual") ?? false;
    bool strReturn = data;

    return strReturn;
  }

  // Future<String> getUserId() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? data = sharedPreferences.getString("userid");
  //   String strReturn = data == null ? "" : data;
  //
  //   return strReturn;
  // }

  // Future<void> setList(List<dynamic> list) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final List<String> jsonList = list.map((item) => jsonEncode(item)).toList();
  //   prefs.setStringList('list', jsonList);
  // }

  // Future<void> SetMasterFasilitas(List<String> listNamaFasilitas) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setStringList("list_nama_fasilitas", listNamaFasilitas);
  // }

  Future<void> SetUserActive(int userActive) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.setString("userActive", userActive);
    sharedPreferences.setInt("userActive", userActive);
  }

  Future<void> setLogoutManual(bool state) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.setString("userActive", userActive);

    sharedPreferences.setBool("logoutManual", state);
  }

  Future<void> setCheckUpdateProfile(int chckProf) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // sharedPreferences.setString("userActive", userActive);
    sharedPreferences.setInt("chckProf", chckProf);
  }
}
