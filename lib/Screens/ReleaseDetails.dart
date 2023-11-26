// ignore_for_file: unnecessary_null_comparison, file_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:RayaExpressDriver/Screens/transfer_order_screen.dart';

import '../Services/File.dart';
import 'package:collapsible/collapsible.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:RayaExpressDriver/API/api.dart';
import 'package:RayaExpressDriver/Screens/home_screen.dart';
import 'package:RayaExpressDriver/Services/service_utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:phone_state/phone_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/constants.dart';
import '../Models/ReleaseDetailsModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ReleaseDetails extends StatefulWidget {
  final int releaseID;
  final String dUserID, driverUsername;
  final int driverID;
  final bool releaseNew;

  final bool isUseOTP;
  final int paymentStatus;

  const ReleaseDetails({
    Key? key,
    required this.releaseID,
    required this.dUserID,
    required this.driverID,
    required this.driverUsername,
    required this.releaseNew,
    required this.paymentStatus,
    required this.isUseOTP,
  }) : super(key: key);

  @override
  State<ReleaseDetails> createState() => _ReleaseDetailsState();
}

class _ReleaseDetailsState extends State<ReleaseDetails> {
  late Future<ReleaseDetailsModel> releaseDetails;

  API api = API();
  bool _collapse = false,
      _collapse2 = false,
      _collapse3 = false,
      _collapse4 = false;

  PhoneState status = PhoneState.nothing();
  Duration callDuration = Duration.zero;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? callStartTime;
  DateTime? callEndTime;
  bool granted = false;
  bool isCallEnded = false;

  @override
  void initState() {
    super.initState();
    releaseDetails = api.getReleaseDetails(widget.releaseID);
    setStream();
  }

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();
    return status.isGranted;
  }

  void setStream() {
    PhoneState.stream.listen((event) {
      setState(() {
        if (event.status == PhoneStateStatus.CALL_STARTED) {
          callStartTime = DateTime.now();
        } else if (event.status == PhoneStateStatus.CALL_ENDED) {
          if (callStartTime != null) {
            callDuration = DateTime.now().difference(callStartTime!);
            String end = callStartTime!.add(callDuration).toString();
            String start = callStartTime!.toString();
            api.callTrack(
                widget.dUserID, widget.releaseID, start, end, status.number!);
            if (kDebugMode) {
              print('userId: ${widget.dUserID}');
            }
            if (kDebugMode) {
              print('Release Id: ${widget.releaseID}');
            }
            if (kDebugMode) {
              print('call Duration:${callDuration.inSeconds}');
            }
            if (kDebugMode) {
              print('Start Time: $callStartTime');
            }
            if (kDebugMode) {
              print('EndTime: ${callStartTime!.add(callDuration)}');
            }
            if (kDebugMode) {
              print('phone Number: ${status.number}');
            }
            callStartTime = null;
          }
        }
        status = event;
      });
    });
  }

  void makePhoneCall(var phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      startTime = DateTime.now();
      await launchUrl(url);
      endTime = DateTime.now();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to make a phone call.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReleaseDetailsModel>(
      future: releaseDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('تفاصيل الطلب'),
              actions: [
                if (widget.releaseNew)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return TransferOrderScreen(
                                  awbNumber: snapshot
                                      .data!.releaseRequests!.oAwbUniqueNumber!,
                                  fromShipmentNumber: snapshot
                                      .data!.releaseRequests!.sShipmentNo!,
                                  driverUsername: widget.driverUsername,
                                  dUserID: widget.dUserID,
                                  driverID: widget.driverID,
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.compare_arrows_sharp,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return NotDileveredAlert(
                                  driverUsername: widget.driverUsername,
                                  driverId: widget.driverID,
                                  userID: widget.dUserID,
                                  releaseID: widget.releaseID,
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (widget.isUseOTP == true) {
                            api.getOTP(
                                snapshot.data!.releaseRequests!.cMobileNumber1!,
                                widget.releaseID);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return OTPAlertDialog(
                                    driverID: widget.driverID,
                                    dUserID: widget.dUserID,
                                    mobileNumber: snapshot
                                        .data!.releaseRequests!.cMobileNumber1!,
                                    releaseID: snapshot
                                        .data!.releaseRequests!.releaseId!,
                                    userNameDriver: widget.dUserID,
                                  );
                                });
                          } else {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return DeliveredAlertDialog(
                                    driverUsername: widget.dUserID,
                                    driverId: widget.driverID,
                                    userID: widget.dUserID,
                                    releaseID: widget.releaseID,
                                  );
                                });
                          }
                        },
                        icon: Icon(
                          Icons.done,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: customLinearGradient,
                // color: Color(0xFFf7f7f7)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Card(
                      elevation: 5.0,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'بيانات العميل ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_collapse == true) {
                                          _collapse = false;
                                        } else {
                                          _collapse = true;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                              color: Color(0xFF3f8dfd),
                            ),
                            Collapsible(
                              collapsed: _collapse,
                              axis: CollapsibleAxis.vertical,
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_circle,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'الاسم:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data!.releaseRequests!.cName ??
                                            ''.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone_android,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'رقم التليفون الاول:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data!.releaseRequests!
                                            .cMobileNumber1!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (Platform.isAndroid) {
                                            MaterialButton(
                                              onPressed: !granted
                                                  ? () async {
                                                      bool temp =
                                                          await requestPermission();
                                                      setState(() {
                                                        granted = temp;
                                                        if (granted) {
                                                          setStream();
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              child: const Text(
                                                  "Request permission of Phone"),
                                            );
                                          }
                                          final call = Uri.parse("tel:" +
                                              snapshot.data!.releaseRequests!
                                                  .cMobileNumber1!);

                                          if (await canLaunchUrl(call)) {
                                            launchUrl(call);
                                          } else {
                                            throw 'Could not launch $call';
                                          }
                                        },
                                        child: const Icon(
                                          Icons.call,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (status.status ==
                                              PhoneStateStatus.CALL_INCOMING ||
                                          status.status ==
                                              PhoneStateStatus.CALL_STARTED)
                                        GestureDetector(
                                          onTap: () {
                                            if (status.number != null) {
                                              makePhoneCall(status.number!);
                                            }
                                          },
                                          child: Text(
                                            "Number: ${status.number}",
                                            style: const TextStyle(
                                                fontSize: 24,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (snapshot.data!.releaseRequests!
                                          .cMobileNumber2 !=
                                      null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_android,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Text(
                                          'رقم التليفون الثاني:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          snapshot.data!.releaseRequests!
                                              .cMobileNumber2!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (Platform.isAndroid) {
                                              MaterialButton(
                                                onPressed: !granted
                                                    ? () async {
                                                        bool temp =
                                                            await requestPermission();
                                                        setState(() {
                                                          granted = temp;
                                                          if (granted) {
                                                            setStream();
                                                          }
                                                        });
                                                      }
                                                    : null,
                                                child: const Text(
                                                    "Request permission of Phone"),
                                              );
                                            }
                                            final call = Uri.parse("tel:" +
                                                snapshot.data!.releaseRequests!
                                                    .cMobileNumber2!);

                                            if (await canLaunchUrl(call)) {
                                              launchUrl(call);
                                            } else {
                                              throw 'Could not launch $call';
                                            }
                                          },
                                          child: const Icon(
                                            Icons.call,
                                            size: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (status.status ==
                                                PhoneStateStatus
                                                    .CALL_INCOMING ||
                                            status.status ==
                                                PhoneStateStatus.CALL_STARTED)
                                          GestureDetector(
                                            onTap: () {
                                              if (status.number != null) {
                                                makePhoneCall(status.number!);
                                              }
                                            },
                                            child: Text(
                                              "Number: ${status.number}",
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'المنطقه : ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot
                                            .data!.releaseRequests!.dNameAr!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'العنون بالكامل: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                          child: Text(
                                        snapshot
                                            .data!.releaseRequests!.cAddress!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'بيانات الدفع ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_collapse2 == true) {
                                          _collapse2 = false;
                                        } else {
                                          _collapse2 = true;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                              color: Color(0xFF3f8dfd),
                            ),
                            Collapsible(
                              collapsed: _collapse2,
                              axis: CollapsibleAxis.vertical,
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  if (snapshot.data!.releaseRequests!
                                          .paymentMethod! !=
                                      null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Text(
                                          'حالة الدفع:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          snapshot.data!.releaseRequests!
                                              .paymentMethod!,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'دفعة التسليم:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot
                                            .data!.releaseRequests!.oOrderPod!
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'بيانات الشحنة ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_collapse3 == true) {
                                          _collapse3 = false;
                                        } else {
                                          _collapse3 = true;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                              color: Color(0xFF3f8dfd),
                            ),
                            Collapsible(
                              collapsed: _collapse3,
                              axis: CollapsibleAxis.vertical,
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.warehouse,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'المخزن:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data!.releaseRequests!.wName!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.numbers,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'AWB:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data!.releaseRequests!
                                            .oAwbUniqueNumber!
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.numbers,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'رقم  الاوردر:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data!.releaseRequests!.orderId!
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.numbers,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text(
                                        'رقم الاذن : ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot
                                            .data!.releaseRequests!.releaseId
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'تفاصيل البضاعه ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_collapse4 == true) {
                                          _collapse4 = false;
                                        } else {
                                          _collapse4 = true;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_drop_down))
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                              color: Color(0xFF3f8dfd),
                            ),
                            Collapsible(
                              collapsed: _collapse4,
                              axis: CollapsibleAxis.vertical,
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  for (var i in snapshot
                                      .data!.releaseRequests!.itemsDriverVMs!)
                                    Row(children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.warehouse,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          const Text(
                                            'كود :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            i.oraItemCode!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.numbers,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          const Text(
                                            'عدد:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            i.rQuantity.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}' "You don't have data in this time");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class NotDileveredAlert extends StatefulWidget {
  const NotDileveredAlert(
      {Key? key,
      required this.driverUsername,
      required this.userID,
      required this.driverId,
      required this.releaseID})
      : super(key: key);

  final String driverUsername, userID;
  final int driverId;
  final int releaseID;

  @override
  State<NotDileveredAlert> createState() => _NotDileveredAlertState();
}

class _NotDileveredAlertState extends State<NotDileveredAlert> {
  bool _isloading = false;
  API api = API();
  String reason = 'All';
  var reasonList = [
    'العميل رفض',
    'حالة البضاعة',
    'مرتجع',
    'العميل غير متاح',
    'البضاعة تظل فى عهدة السائق',
    'اختلاف المنتج',
    'لم يتم الرد على الهاتف',
    'اختلاف بيانات التحصيل',
    'العميل يريد تاجيل استلام الاوردر لليوم التالي',
    'الاوردر مكرر',
    'العميل استلم من مكان اخر',
    'Customer request to open shipment/ العميل يريد فتح الشحنه',
    'Other / أخري',
    'طلب تجربة المنتج',
    'رفض بسبب السعر',
    'اختلاف بيانات العميل'
  ];
  String idValue = '';
  String rejectValue = "";
  List<String> rejectID = [''];
  List<String> rejectName = [''];

  Future<void> fetchRejectReason() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://www.rayatrade.com/RayaLogisticsAPI/api/shipmentStatus/All-Delivery-Rejection-Reason'));
    var headers = {'Username': 'Logistics', 'Password': 'H51Qob<zRRQ/f@%^'};
    request.headers.addAll(headers);

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonData = json.decode(await response.stream.bytesToString());

      if (kDebugMode) {
        print(jsonData);
      }
      setState(() {
        rejectName = List<String>.from(
            jsonData['reasons'].map((x) => x['reason'].toString()));
        rejectID = List<String>.from(
            jsonData['reasons'].map((x) => x['id'].toString()));
        rejectValue = rejectName.first;
        idValue = rejectID.first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRejectReason();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(
            child: Text(
          "اختر سبب الرفض",
          style: TextStyle(fontSize: 12.0),
        )),
        content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: rejectValue,
                  itemHeight: null,
                  menuMaxHeight: 292,
                  borderRadius: BorderRadius.circular(10),
                  alignment: AlignmentDirectional.center,
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  elevation: 0,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      rejectValue = newValue!;
                      idValue = rejectID[rejectName.indexOf(rejectValue)];
                    });
                  },
                  items: rejectName.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.59,
                          height: MediaQuery.of(context).size.height / 20,
                          child: Center(child: Text(value)),
                        ),
                      );
                    },
                  ).toList(),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (rejectValue != null && rejectValue != "") {
                        setState(() {
                          _isloading = true;
                        });
                        String res = await api.rejectDelivery(
                            widget.driverUsername,
                            widget.releaseID,
                            rejectValue);
                        try {
                          if (res == "Done") {
                            setState(() {
                              _isloading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return HomeScreen(
                                    driverUsername: widget.driverUsername,
                                    driverID: widget.driverId,
                                    dUserID: widget.userID);
                              }),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: res,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {
                              _isloading = false;
                            });
                          }
                        } on SocketException catch (_) {
                          rethrow;
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "اختر سبب الرفض",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: _isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('تم'))
              ]),
        ));
  }
}

class OTPAlertDialog extends StatefulWidget {
  final String mobileNumber, userNameDriver;
  final int releaseID;
  final String dUserID;
  final int driverID;

  const OTPAlertDialog(
      {Key? key,
      required this.mobileNumber,
      required this.releaseID,
      required this.userNameDriver,
      required this.dUserID,
      required this.driverID})
      : super(key: key);

  @override
  State<OTPAlertDialog> createState() => _OTPAlertDialogState();
}

class _OTPAlertDialogState extends State<OTPAlertDialog> {
  final oTP = TextEditingController();
  bool _isloading = false;

  API api = API();
  ServicesUtility servicesUtility = ServicesUtility();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("برجاء ادخال رمز التحقق المرسل الي العميل"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('رقم العميل :'),
              Text(widget.mobileNumber),
              TextFormField(
                controller: oTP,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "OTP",
                    prefixIcon: const Icon(Icons.format_list_numbered),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isloading = true;
                  });
                  String res = await api.postOTP(
                      oTP.text, widget.releaseID, widget.userNameDriver);
                  if (res != "Success") {
                    setState(() {
                      _isloading = false;
                    });
                    Fluttertoast.showToast(
                        msg: res,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      _isloading = false;
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) {
                    //     return  HomeScreen(driverID: widget.driverID,dUserID: widget.dUserID);
                    //   }),
                    // );
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return DeliveredAlertDialog(
                            driverUsername: widget.userNameDriver,
                            driverId: widget.driverID,
                            userID: widget.dUserID,
                            releaseID: widget.releaseID,
                          );
                        });
                  }
                },
                child: _isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('التالي'),
              )
            ],
          ),
        ));
  }
}

class DeliveredAlertDialog extends StatefulWidget {
  const DeliveredAlertDialog(
      {Key? key,
      required this.driverUsername,
      required this.releaseID,
      required this.driverId,
      required this.userID})
      : super(key: key);
  final String driverUsername, userID;
  final int releaseID;
  final int driverId;

  @override
  State<DeliveredAlertDialog> createState() => _DeliveredAlertDialogState();
}

class _DeliveredAlertDialogState extends State<DeliveredAlertDialog> {
  int _releaseDeliveredYes = 0, _releaseDeliveredNo = 0;
  API api = API();
  final oTP = TextEditingController();
  String fileType = 'ALL';
  var fileTypeList = ['ALL'];
  FilePickerResult? result;
  String res = '';
  PlatformFile? file;
  ServicesUtility servicesUtility = ServicesUtility();
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("برجاء الاجابه عن الاسئله الاتيه"),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('هل تم تسليم الفاتورة'),
                  Column(
                    children: [
                      ListTile(
                        title: const Text("نعم"),
                        leading: Radio(
                          value: 1,
                          groupValue: _releaseDeliveredYes,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _releaseDeliveredYes = value!;
                              _releaseDeliveredNo = 0;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("لا"),
                        leading: Radio(
                          value: 1,
                          groupValue: _releaseDeliveredNo,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              _releaseDeliveredNo = value!;
                              _releaseDeliveredYes = 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              pickFiles(fileType);
                              // await availableCameras().then((value) => Navigator.push(context,
                              //     MaterialPageRoute(builder: (_) => CameraScreen(cameras: value))));
                            },
                            child: const Text('ارفع صوره اذن التسليم'),
                          ),
                          if (file != null) fileDetails(file!),
                          if (file != null)
                            ElevatedButton(
                              onPressed: () {
                                viewFile(file!);
                              },
                              child: const Text('اظهار الصورة المرفوعة'),
                            ),
                          if (file != null)
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isloading = true;
                                });
                                // String res ;
                                if (_releaseDeliveredYes == 1) {
                                  Position position =
                                      await servicesUtility.getLocation();
                                  res = await api.doneDeliveryByUploadNote(
                                      widget.driverUsername,
                                      true,
                                      file!.path!,
                                      widget.releaseID,
                                      true,
                                      position.latitude.toString(),
                                      position.longitude.toString());
                                } else if (_releaseDeliveredNo == 1) {
                                  Position position =
                                      await servicesUtility.getLocation();
                                  res = await api.doneDeliveryByUploadNote(
                                      widget.driverUsername,
                                      true,
                                      file!.path!,
                                      widget.releaseID,
                                      false,
                                      position.latitude.toString(),
                                      position.longitude.toString());
                                }
                                if (res == "Done") {
                                  setState(() {
                                    _isloading = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return HomeScreen(
                                          driverUsername: widget.driverUsername,
                                          driverID: widget.driverId,
                                          dUserID: widget.userID);
                                    }),
                                  );
                                } else {
                                  setState(() {
                                    _isloading = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: res,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: _isloading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('تم'),
                            )
                        ],
                      ),
                    ],
                  ),

                  // TextButton(
                  //   child: const Text("تم"),
                  //   onPressed: (){
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) {
                  //         return  HomeScreen(driverUsername: widget.driverUsername,driverID: widget.driverId,dUserID: widget.userID);
                  //       }),
                  //     );
                  //   },
                  // )
                ]),
          ),
        ));
  }

  Widget fileDetails(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('File Name: ${file.name}'),
          Text('File Size: $size'),
          Text('File Extension: ${file.extension}'),
          Text('File Path: ${file.path}'),
        ],
      ),
    );
  }

  void pickFiles(String filetype) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
      if (kDebugMode) {
        print(statuses[Permission.camera]);
      } // it should print PermissionStatus.granted
    }

    final result = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);
    if (result == null) return;
    final file = File(result.path);
    final fileSize =
        await file.length(); // Retrieve file size using the File class
    final platformFile = PlatformFile(
      name: result.name,
      size: fileSize,
      path: result.path,
      bytes: await result.readAsBytes(),
    );
    setState(() {
      // Save the selected image file in the "file" variable
      this.file = platformFile;
    });
    loadSelectedFiles([platformFile]);
  }

  void loadSelectedFiles(List<PlatformFile> files) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FileList(files: files, onOpenedFile: viewFile)));
  }

  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}
