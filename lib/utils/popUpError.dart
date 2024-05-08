import 'package:flutter/material.dart';
import 'package:pit/model/mNetwork.dart';

class PopupError {
  showError(BuildContext context, Network objNetwork, bool showMessage,
      bool mounted) async {
    print("executed page from popUpError");
    if (!objNetwork.Status) {
      print(objNetwork.Error);
      if (objNetwork.Error == "" || objNetwork.Error == null) {
        if (showMessage) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 1),
                content: Text("Anda tidak terhubung ke jaringan internet")));
          }
        } else {
          print('Anda tidak terhubung ke jaringan internet');
        }
      } else {
        if (objNetwork.Error != null && objNetwork.Error != "") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 5),
              content: Text(objNetwork.Error!)));
        }
      }
    }
  }
}
