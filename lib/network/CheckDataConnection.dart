import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pit/model/mNetwork.dart';

import 'master.dart';

class Connection {
  String linkTested = 'odoo.pitelektronik.com'; //staging
  // String linkTested = 'pitelektronik.odoo.com'; //production
  // String linkTested = 'www.google.com';
  bool result = false;
  Network objNetwork = Network(Status: false);

  // init() async {}
  Future<Network> CheckConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      // print("connect dari mobile");
      objNetwork = await ConnectionFromHitAPI();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      // print("connect dari wifi");
      objNetwork = await ConnectionFromHitAPI();
    } else if (connectivityResult == ConnectivityResult.none) {
      return objNetwork;
    }
    // print('------Connection class------');
    // result = await internetAddress();

    // if (!result) {
    //   // print('try to connect with connectionchecker');
    // result = await ConnectionChecker();
    // }

    return objNetwork;
  }

  Future<Network> ConnectionFromHitAPI() async {
    masterNetwork objMasterProd = masterNetwork();
    Network objNetwork = Network(Status: false);
    objNetwork = await objMasterProd.cekConnections();

    return objNetwork;
  }

  Future<bool> ConnectionChecker() async {
    // final customInstance = InternetConnectionChecker.createInstance(
    //   checkTimeout: const Duration(seconds: 1), // Custom check timeout
    //   checkInterval: const Duration(seconds: 1), // Custom check interval
    //   addresses: [
    //     ... // Custom addresses
    //   ],
    // );
    //
    // // Register it with any dependency injection framework. For example GetIt.
    // GetIt.registerSingleton<InternetConnectionChecker>(
    //   customInstance,
    // );
    // try {
    //   result = await InternetConnectionChecker().hasConnection;
    //   if (result == true) {
    //     // print('Connected To Internet from InternetConnectionChecker()');
    //     return true;
    //   }
    // } on SocketException catch (_) {
    //   // print('gagal connect from InternetConnectionChecker');
    //   // print('Hanya masuk ke db local');
    // }

    return false;
  }

  Future<bool> internetAddress() async {
    try {
      final tested = await InternetAddress.lookup(linkTested);
      // final tested = await AddressCheckOptions(
      //   InternetAddress(
      //     '1.1.1.1', // CloudFlare
      //     type: InternetAddressType.IPv4,
      //   ),
      //   port: 53,
      //   timeout: InternetConnectionChecker.DEFAULT_TIMEOUT,
      // );
      // print('tested');
      // print(tested);
      if (tested.isNotEmpty && tested[0].rawAddress.isNotEmpty) {
        // print('connected, using from lookup to $linkTested');
        return true;
      }
    } on SocketException catch (_) {
      // print('gagal connect from lookup to $linkTested');
      // print('Hanya masuk ke db local');
    }

    return false;
  }

/////////
// Future<bool> CheckConnection() async {
//   print('------Connection class------');
//   try {
//     result = await internetAddress();
//   } on SocketException catch (_) {
//     try {
//       print('No internet from from lookup to $linkTested');
//
//       result = await ConnectionChecker();
//     } on SocketException catch (_) {
//       print('No internet from InternetConnectionChecker()');
//       print('Hanya masuk ke db local');
//     }
//   }
//   return result;
// }
//
// Future<bool> ConnectionChecker() async {
//   result = await InternetConnectionChecker().hasConnection;
//   if (result == true) {
//     print('Connected To Internet from InternetConnectionChecker()');
//     return result;
//   } else {
//     print('gagal connect from InternetConnectionChecker');
//     print('Hanya masuk ke db local');
//     return false;
//   }
// }
//
// Future<bool> internetAddress() async {
//   final tested = await InternetAddress.lookup(linkTested);
//   print('tested');
//   print(tested);
//   if (tested.isNotEmpty && tested[0].rawAddress.isNotEmpty) {
//     print('connected, using from lookup to $linkTested');
//     return true;
//   } else {
//     print('gagal connect from lookup to $linkTested');
//     return false;
//   }
// }
}
