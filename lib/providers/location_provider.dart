import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _position;
  bool locationPermissionStatus = false;
  bool isloading = false;

  init() {
    initPosition();
  }

  Position? get getCurrentPosition => _position;

  Future initPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    isloading = true;
    notifyListeners();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isloading = false;
        notifyListeners();
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        locationPermissionStatus = true;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      isloading = false;
      notifyListeners();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      locationPermissionStatus = true;
    }

    _position = await Geolocator.getCurrentPosition();
    isloading = false;
    notifyListeners();
  }

  openSetting() async {
    await Geolocator.openAppSettings();
  }

  setPermissionStatus() {
    Geolocator.checkPermission().then((val) async {
      if (val == LocationPermission.denied &&
          val == LocationPermission.deniedForever) {
        locationPermissionStatus = false;
      } else {
        locationPermissionStatus = true;
        _position = await Geolocator.getCurrentPosition();
      }
      notifyListeners();
    });
  }
}
