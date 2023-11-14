// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:RayaExpressDriver/Models/response_message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:RayaExpressDriver/Models/PickupModel.dart';
import 'package:RayaExpressDriver/Models/ReleaseDetailsModel.dart';
import 'package:RayaExpressDriver/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/ReleasesModel.dart';
import '../Models/TasksModel.dart';
import '../Models/get_driver_model.dart';

class API {
  String url = 'http://www.rayatrade.com/RayaLogisticsAPI/api/Driver/';

  checkNetwork() async {
    try {
      final result = await InternetAddress.lookup(
          'http://www.rayatrade.com/RayaLogisticsAPI/Swagger/Index.html');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Fluttertoast.showToast(
        //     msg: "Loading",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(
      //     msg: "No Internet",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      return const AboutDialog(
        children: [Text('No Internet')],
      );
    }
  }

  login(String userName, String password, String? fcmToken, String deviceID,
      String deviceVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url + 'Login'));
    request.body = json.encode({
      "username": userName,
      "password": password,
      "DeviceID": deviceID,
      "FCM_Token": fcmToken,
      "DeviceVersion": deviceVersion
    });
    request.headers.addAll(headers);

    if (kDebugMode) {
      print(
          "Headers : " + request.headers.toString() + "Body : " + request.body);
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Token :" +
            fcmToken! +
            "Device ID : " +
            deviceID +
            "Device Version :" +
            deviceVersion);
      }
      sharedPreferences.setString('UserName', userName);
      sharedPreferences.setString('Password', password);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<ReleasesModel> getReleases(int driverID, bool releaseNew) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'DriverID': driverID.toString(),
      'releaseNew': releaseNew.toString()
    };
    var request = http.Request('GET', Uri.parse(url + 'GetReleases'));

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return ReleasesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<ReleaseDetailsModel> getReleaseDetails(int releaseID) async {
    var headers = {'Username': 'Logistics', 'Password': 'H51Qob<zRRQ/f@%^'};
    var request = http.Request(
        'GET',
        Uri.parse(
            url + 'GetReleaseDetails?ReleaseID=' + releaseID.toString() + ''));

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return ReleaseDetailsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  getOTP(String mobileNumber, int releaseID) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'MobileNumber': '' + mobileNumber + '',
      'ReleaseID': '' + releaseID.toString() + ''
    };
    var request = http.Request('GET', Uri.parse(url + 'GetOTP'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(await response.stream.bytesToString());
      }
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  postOTP(String otp, int releaseID, String userNameDriver) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'userNameDriver': '' + userNameDriver + '',
      'OTP': '' + otp + '',
      'ReleaseID': '' + releaseID.toString() + ''
    };
    var request = http.Request('PUT', Uri.parse(url + 'PostOTP'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print('OTP' + otp + ' ' + 'ReleaseID' + releaseID.toString() + ' ');
    }
    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  rejectDelivery(String driverUsername, int releaseID, String reason) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'releaseID': releaseID.toString(),
      'driverUsername': '12345'
    };
    var request = http.Request(
        'POST', Uri.parse(url + 'RejectDelivery?reason=' + reason + ''));
    if (kDebugMode) {
      print(request);
    }
    request.headers.addAll(headers);
    if (kDebugMode) {
      print(headers);
    }
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  doneDeliveryByUploadNote(
      String driverUsername,
      bool deliveryNote,
      String filepath,
      int releaseID,
      bool isRecieved,
      String latitude,
      String longitude) async {
    var headers = {
      'userNameDriver': driverUsername,
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'ReleaseID': releaseID.toString(),
      'DeliverNote': deliveryNote.toString(),
      'Content-Type': 'multipart/form-data',
      'IsRecieved': isRecieved.toString(),
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(url +
            'DoneDelivery?latitude=' +
            latitude +
            '&longitude=' +
            longitude +
            ''));
    request.files.add(await http.MultipartFile.fromPath('file', filepath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return response.stream.bytesToString();
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  callTrack(String submitter, int releaseId, String startAt, String endAt,
      String mobileNumber) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://www.rayatrade.com/RayaLogisticsAPI/api/CallTracking/AddCallTracking'));
    request.body = json.encode({
      "submitter": submitter,
      "releaseId": releaseId,
      "classificationId": 1,
      "startAt": startAt,
      "endAt": endAt,
      "comment": "",
      "recordPath": "",
      "mobileNumber": mobileNumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(await response.stream.bytesToString());
      }
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
  }

  Future<ReleasesModel> getReleasesByOrderNumber(
      String orderNumber, int driverID, bool releaseNew) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url + 'SearchByOrderNumber'));
    request.body = json.encode({
      "driverID": driverID,
      "truckID": 0,
      "releaseNew": releaseNew,
      "orderNumber": orderNumber
    });
    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return ReleasesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<ReleasesModel> getReleasesByAWB(
      String aWB, int driverID, bool releaseNew) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(url + 'SearchReleasesByAWBNumber'));
    request.body = json.encode({
      "driverID": driverID,
      "truckID": 0,
      "releaseNew": releaseNew,
      "awb": aWB
    });
    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return ReleasesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<PickupModel> getPickupsByAWB(String aWB, String driverID) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$url/SearchPickupsByAWB'));
    request.body = json.encode({"awb": aWB, "driverID": driverID});
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("searchpickup");

        print(response.body);
      }
      return PickupModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<PickupModel> getpickupsList(int driverID) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
    };
    var request = http.Request('GET',
        Uri.parse('$url/GetListOfPicks?DriverID=' + driverID.toString() + ''));

    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return PickupModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<PickupModel> putActionPick(String reason, int scheduleID, bool accept,
      String latitude, String longitude) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$url/PickAction'));
    request.body = json.encode({
      "reason": reason,
      "scheduleID": scheduleID,
      "accept": accept,
      "latitude": latitude,
      "longitude": longitude
    });
    if (kDebugMode) {
      print(request.body);
    }
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return PickupModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<TasksModel> getTasksList(int driverID) async {
    var headers = {'Username': 'Logistics', 'Password': 'H51Qob<zRRQ/f@%^'};
    var request = http.Request('GET',
        Uri.parse('$url/GetListOfTasks?DriverID=' + driverID.toString()));

    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      return TasksModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<List<GetDriverModel>> getDriver() async {
    var headers = {'Username': 'Logistics', 'Password': 'H51Qob<zRRQ/f@%^'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://www.rayatrade.com/RayaLogisticsAPI/api/Driver/GetDrivers'));

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<GetDriverModel> drivers = jsonResponse
          .map((driver) => GetDriverModel.fromJson(driver))
          .toList();
      return drivers;
    } else {
      throw Exception("Failed to load Data");
    }
  }

  Future<MessageResponse> transferOrder(String orderId, int fromShipmentNumber,
      int toDriverId, int toShipmentNumber) async {
    var headers = {
      'Username': 'Logistics',
      'Password': 'H51Qob<zRRQ/f@%^',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT',
        Uri.parse(
            'http://www.rayatrade.com/RayaLogisticsAPI/api/Driver/TransferOrders'));
    request.body = json.encode({
      "orderID": orderId,
      "fromShipmetNumber": fromShipmentNumber,
      "toDriverID": toDriverId,
      "toShipmentNumber": toShipmentNumber
    });
    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      return MessageResponse.fromJson(jsonDecode(response.body));
    } else {
      return MessageResponse.fromJson(jsonDecode(response.body));
    }
  }
}
