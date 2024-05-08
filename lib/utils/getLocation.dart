import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? lat;
  double? long;
  Location() {
    init();
  }
  init() async {
    await getLocation();
  }

  // Future<dynamic> getLatLong() async {
  //   Position _locationData = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   lat = _locationData.latitude;
  //   long = _locationData.longitude;
  //
  //   print("latlotng");
  //   print(lat);
  //   Map latLong = {"lat": lat, "long": long};
  //   return latLong;
  // }

  Future<bool> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // print("1");

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Future.error('Location services are disabled.');
      return false;
    } else {
      print("lokasi tidak ditemukan");
      print(serviceEnabled);
      permission = await Geolocator.checkPermission();
      print('permission');
      print(permission);
    }
// await Geolocator.
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print("permission");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Future.error('Location permissions are denied');
        // print(error('Location permissions are denied'));
        return false;
      }
    }
    // print("3");

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    permission = LocationPermission.always;
    // print("4");
    Position _locationData = await Geolocator.getCurrentPosition(
        // forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);
    lat = _locationData.latitude;
    long = _locationData.longitude;

    //============== geocoding ==============//
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    return true;
  }
}
