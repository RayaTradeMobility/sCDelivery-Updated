// ignore_for_file: import_of_legacy_library_into_null_safe, file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:RayaExpressDriver/Screens/ReleaseDetails.dart';
import 'package:RayaExpressDriver/Services/ServicesUtililty.dart';
import '../API/API.dart';
import '../Models/PickupModel.dart';
import '../Screens/PickupScreen.dart';

const fontColor = Color(0xFF031639);

const LinearGradient customLinearGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Colors.white10,
    // Colors.lightBlueAccent,
    Colors.black12,
    Colors.white10
  ],
);

//////////////////////////////////////////////////////////////
//Releases
class ReleasesCard extends StatefulWidget {
  const ReleasesCard(
      {super.key,
      required this.dUserID,
      required this.driverID,
      required this.cAddress,
      required this.cMobileNumber1,
      required this.cName,
      required this.dNameAR,
      required this.oCreatedDate,
      required this.orderID,
      required this.releaseID,
      required this.rShipmentID,
      required this.driverUsername,
      required this.releasenew,
      required this.paymentstatus,
      required this.oSystemStatusID});

  final int? paymentstatus, oSystemStatusID;
  final String dUserID,
      cAddress,
      cMobileNumber1,
      cName,
      dNameAR,
      oCreatedDate,
      driverUsername,
      orderID;
  final int driverID, releaseID, rShipmentID;
  final bool releasenew;

  @override
  State<ReleasesCard> createState() => _ReleasesCardState();
}

class _ReleasesCardState extends State<ReleasesCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5.0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            if ((widget.paymentstatus != null || widget.paymentstatus != 4) &&
                widget.oSystemStatusID != 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ReleaseDetails(
                    releaseNew: widget.releasenew,
                    driverUsername: widget.driverUsername,
                    driverID: widget.driverID,
                    releaseID: widget.releaseID,
                    dUserID: widget.dUserID,
                    paymentStatus: widget.paymentstatus!,
                  );
                }),
              );
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if ((widget.paymentstatus == null ||
                          widget.paymentstatus == 4) &&
                      widget.oSystemStatusID == 4)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          " NOT Collected",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'رقم الاذن: ',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.releaseID.toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const Text(
                        'رقم الطلب: ',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.orderID.toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.8,
                    color: Color(0xFF3f8dfd),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(
                            widget.cName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox.fromSize(
                        size: const Size(90, 30), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: const Color(0xFF3f8dfd), // button color
                            child: InkWell(
                              splashColor: Colors.grey, // splash color
                              onTap: () {}, // button pressed
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ), // icon
                                  Text(
                                    " الخريطة",
                                    style: TextStyle(color: Colors.white),
                                  ), // text
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.dNameAR,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.cMobileNumber1,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.my_location,
                        color: Colors.grey,
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 100, maxWidth: 200),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.cAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
//PICKUP
class PickupCard extends StatefulWidget {
  const PickupCard(
      {super.key,
      required this.dUserID,
      required this.driverID,
      required this.driverUsername,
      required this.awb,
      required this.shipperMobileNumber,
      required this.shipperAddress,
      required this.shipperName,
      required this.scheduleID,
      required this.orderDetails,
      required this.oOrderNumber});

  final String dUserID, driverUsername;
  final String awb,
      shipperMobileNumber,
      shipperAddress,
      shipperName,
      oOrderNumber;
  final int driverID, scheduleID;
  final List<OrderDetails> orderDetails;

  @override
  State<PickupCard> createState() => _PickupCardState();
}

class _PickupCardState extends State<PickupCard> {
  API api = API();
  ServicesUtility servicesUtility = ServicesUtility();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5.0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: TextButton(
          onPressed: () {},
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'رقم الشحنه: ',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.awb,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.8,
                    color: Color(0xFF3f8dfd),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const Text(
                        'رقم الاوردر: ',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.oOrderNumber,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 0.8,
                    color: Color(0xFF3f8dfd),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(
                            widget.shipperName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // SizedBox.fromSize(
                      //   size: Size(90, 30), // button width and height
                      //   child: ClipOval(
                      //     child: Material(
                      //       color: Color(0xFF3f8dfd), // button color
                      //       child: InkWell(
                      //         splashColor: Colors.grey, // splash color
                      //         onTap: () {}, // button pressed
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: const <Widget>[
                      //             Icon(
                      //               CupertinoIcons.list_bullet,
                      //               color: Colors.white,
                      //             ), // icon
                      //             Text(
                      //               " التفاصيل",
                      //               style: TextStyle(color: Colors.white),
                      //             ), // text
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Icon(
                          //   Icons.location_on,
                          //   color: Colors.grey,
                          // ),
                          //
                          // Text(
                          //   widget.ShipperAddress,
                          //   style: TextStyle(
                          //       color: Colors.black, fontWeight: FontWeight.bold),
                          // ),
                          // SizedBox(
                          //   width: 10.0,
                          // ),
                          const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.shipperMobileNumber,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.my_location,
                        color: Colors.grey,
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 100, maxWidth: 250),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.shipperAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Position position =
                                  await servicesUtility.getLocation();
                              PickupModel acted = await api.putActionPick(
                                  '',
                                  widget.scheduleID,
                                  true,
                                  position.latitude.toString(),
                                  position.longitude.toString());
                              if (acted.headerInfo?.message == "Success") {
                                Fluttertoast.showToast(
                                    msg: 'Done',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return PickupScreen(
                                      driverUsername: widget.driverUsername,
                                      dUserID: widget.dUserID,
                                      driverID: widget.driverID,
                                      aWB: '',
                                    );
                                    // return QRViewExample();
                                  }),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: acted.headerInfo?.message.toString() ??
                                        'Error',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: const Center(
                                child: Text(
                              'قبول',
                              style: TextStyle(color: Colors.white),
                            )),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PickupDetails(
                                      orderDetails: widget.orderDetails,
                                    );
                                  });
                            },
                            child: const Center(
                                child: Text(
                              'التفاصيل',
                              style: TextStyle(color: Colors.white),
                            )),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PickupRejectionReason(
                                        scheduleID: widget.scheduleID,
                                        driverID: widget.driverID,
                                        dUserID: widget.driverID,
                                        driverUsername: widget.driverUsername);
                                  });
                            },
                            child: const Center(
                                child: Text(
                              'رفض',
                              style: TextStyle(color: Colors.white),
                            )),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PickupDetails extends StatefulWidget {
  const PickupDetails({Key? key, required this.orderDetails}) : super(key: key);

  final List<OrderDetails> orderDetails;

  @override
  State<PickupDetails> createState() => _PickupDetailsState();
}

class _PickupDetailsState extends State<PickupDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: Text("التفاصيل")),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var det in widget.orderDetails)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'رقم الاوردر:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(det.ohOrderId.toString())
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'كود المنتج :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(det.oraItemCode.toString())
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'عدد الوحدات :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(det.oraNumUnits.toString())
                        ],
                      ),
                      const Divider(color: Colors.black)
                    ],
                  ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('الرجوع'))
              ]),
        ));
  }
}

class PickupRejectionReason extends StatefulWidget {
  const PickupRejectionReason(
      {Key? key,
      required this.scheduleID,
      required this.dUserID,
      required this.driverID,
      required this.driverUsername})
      : super(key: key);
  final int scheduleID, dUserID, driverID;
  final String driverUsername;

  @override
  State<PickupRejectionReason> createState() => _PickupRejectionReasonState();
}

class _PickupRejectionReasonState extends State<PickupRejectionReason> {
  final rejectionController = TextEditingController();
  API api = API();
  ServicesUtility servicesUtility = ServicesUtility();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Center(child: Text("سبب الرفض")),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: rejectionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      //<-- SEE HERE
                      fillColor: Colors.white,
                      hintText: "سبب الرفض",
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                ),
                ElevatedButton(
                    onPressed: () async {
                      Position pos = await servicesUtility.getLocation();
                      PickupModel acted = await api.putActionPick(
                          rejectionController.text,
                          widget.scheduleID,
                          false,
                          pos.latitude.toString(),
                          pos.longitude.toString());
                      if (acted.headerInfo?.message == "Success") {
                        Fluttertoast.showToast(
                            msg: 'Done',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return PickupScreen(
                              driverUsername: widget.driverUsername,
                              dUserID: widget.dUserID.toString(),
                              driverID: widget.driverID,
                              aWB: '',
                            );
                            // return QRViewExample();
                          }),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                acted.headerInfo?.message.toString() ?? 'Error',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text('تم'))
              ]),
        ));
  }
}
