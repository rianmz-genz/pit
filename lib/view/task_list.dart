import 'package:flutter/material.dart';
import 'package:pit/themes/AppTheme.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:pit/pages/task_list_adapter.dart';

class TaskList extends StatefulWidget {
  TaskList();

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.warnaUngu,
          leading: IconButton(
            splashColor: AppTheme.warnaUngu,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_left, size: 40),
          ),
          centerTitle: true,
          title: Text(
            'List Pekerjaan',
            style: AppTheme.appBarTheme(),
            textAlign: TextAlign.center,
          ),
        ),
        body: SafeArea(
          child: TaskListLocation(),
        ),
      ),
    );
  }
}

class TaskListLocation extends StatelessWidget {
  Future<dynamic> getLocationTask() async {
    /*
    loc.Location location = new loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    String strStreet =
        placemarks[0].street!.split(placemarks[0].subLocality.toString())[0];

    dynamic objReturn = {
      "Address": "${placemarks[0].subLocality}, $strStreet",
      "Lat": _locationData.latitude,
      "Lng": _locationData.longitude
    };
    return objReturn;

     */

    // dynamic objReturn = {"Address": "", "Lat": 0, "Lng": 0};

    bool serviceEnabled;
    LocationPermission permission;

    // print("1");

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    } else {
      print("lokasi tidak ditemukan");
      print(serviceEnabled);
      permission = await Geolocator.checkPermission();
      print('permission');
      print(permission);
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print("permission");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    // print("3");

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // print("4");
    Position _locationData = await Geolocator.getCurrentPosition(
        // forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);

    // print("5");
    //============== geocoding ==============//
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    String strStreet =
        placemarks[0].street!.split(placemarks[0].subLocality.toString())[
            0]; //-6.162098207967056, 106.84434863946925
    // double distanceTwoCoordinates = Geolocator.distanceBetween(
    //   -6.162098207967056,
    //   106.84434863946925,
    //   _locationData.latitude,
    //   _locationData.longitude,
    // );

// fitur pilih pekerjaan berdasarkan radius yg dibatasi, bila sesuai pekerjaan bisa muncul
    dynamic objReturn = {
      "Address": "${placemarks[0].subLocality}, $strStreet",
      "Lat": _locationData.latitude,
      "Lng": _locationData.longitude
    };
    return objReturn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getLocationTask(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic objDataTask = snapshot.data!;

          return Container(
            child: Column(
              children: [
                Container(
                  color: AppTheme.warnaUngu,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        objDataTask["Address"],
                        style: AppTheme.OpenSans400LS(14, Colors.white, 0.19),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Expanded(
                    child: TaskListAdapter(
                      Status: "Open",
                      Lat: objDataTask["Lat"],
                      Lng: objDataTask["Lng"],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
            child: CircularProgressIndicator(
          color: AppTheme.warnaHijau,
        ));
      },
    );
  }
}
