// ignore_for_file: file_names

import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ServicesUtility {
  getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    return version;
  }

  getLocation() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      if (kDebugMode) {
        print("GPS service is enabled");
      }
    } else {
      if (kDebugMode) {
        print("GPS service is disabled.");
      }
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('Location permissions are denied');
        }
      } else if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print("'Location permissions are permanently denied");
        }
      } else {
        if (kDebugMode) {
          print("GPS Location service is granted");
        }
      }
    } else {
      if (kDebugMode) {
        print("GPS Location permission granted.");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position; //Output: 29.6593457
  }
}
