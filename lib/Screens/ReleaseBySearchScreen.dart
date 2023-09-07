// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:flutter/material.dart';

import '../API/API.dart';
import '../Constants/Constants.dart';
import '../Models/ReleasesModel.dart';

class ReleaseBySearchScreen extends StatefulWidget {
  const ReleaseBySearchScreen(
      {super.key,
      required this.dUserID,
      required this.driverID,
      required this.driverUsername,
      required this.orderNumber,
      required this.awb});

  final String dUserID;
  final int driverID;
  final String driverUsername;
  final String orderNumber;
  final String awb;

  @override
  State<ReleaseBySearchScreen> createState() => _ReleaseBySearchScreenState();
}

class _ReleaseBySearchScreenState extends State<ReleaseBySearchScreen> {
  API api = API();
  late Future<ReleasesModel> releasesBySerach;

  @override
  void initState() {
    super.initState();
    if (widget.awb == null) {
      releasesBySerach = api.getReleasesByOrderNumber(
          widget.orderNumber, widget.driverID, true);
    } else {
      releasesBySerach =
          api.getReleasesByAWB(widget.awb, widget.driverID, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3f8dfd),
        title: Text(widget.awb),
        centerTitle: true,
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
                  FutureBuilder<ReleasesModel>(
                    future: releasesBySerach,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.releaseRequests != null) {
                          return Column(
                            children: [
                              for (var r in snapshot.data!.releaseRequests!)
                                ReleasesCard(
                                  releasenew: true,
                                  driverUsername: widget.driverUsername,
                                  cAddress: r.cAddress!,
                                  cMobileNumber1: r.cMobileNumber1!,
                                  cName: r.cName!,
                                  dNameAR: r.dNameAr!,
                                  oCreatedDate: r.oCreatedDate!,
                                  orderID: r.orderId!,
                                  releaseID: r.releaseId!,
                                  rShipmentID: r.rShipmentId!,
                                  driverID: widget.driverID,
                                  dUserID: widget.dUserID,
                                  paymentstatus: r.paymentStatusID,
                                  oSystemStatusID: r.oSystemStatusID,
                                  // isUseOTP: r.isUseOTP!,
                                ),
                            ],
                          );
                        } else {
                          return const Text(
                              "There is no Data For this QR Code");
                        }
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}'
                            "You don't have data in this time");
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
