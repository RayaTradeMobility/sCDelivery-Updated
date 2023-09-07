// ignore_for_file: unnecessary_null_comparison, file_names

import 'package:flutter/material.dart';
import 'package:RayaExpressDriver/Models/PickupModel.dart';
import '../API/API.dart';
import '../Constants/Constants.dart';
import 'MenuScreen.dart';
import 'QRCodeScreen.dart';


class PickupScreen extends StatefulWidget {
  const PickupScreen(
      {super.key,
      required this.driverUsername,
      required this.dUserID,
      required this.driverID,
      required this.aWB});

  final String aWB;
  final String driverUsername, dUserID;
  final int driverID;

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen>
    with SingleTickerProviderStateMixin {
  API api = API();
  late Future<PickupModel> pickups;
  Widget customSearchBar = const Text("بحث برقم اذن الاستقبال");
  Icon customIcon = const Icon(Icons.search);
  TextEditingController searchController = TextEditingController();

  Future<bool> _onBackPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MenuScreen(
        driverUsername: widget.driverUsername,
        dUserID: widget.dUserID,
        driverID: widget.driverID,
      );
    }));
    return true;
  }

  @override
  void initState() {
    if (widget.aWB.isNotEmpty) {
      pickups = api.getPickupsByAWB(widget.aWB, widget.driverID.toString());
    } else {
      pickups = api.getpickupsList(widget.driverID);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF3f8dfd),
            title: const Text('تحميلات '),
            centerTitle: true),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: customLinearGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FutureBuilder<PickupModel>(
                      future: pickups,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.pickupVMs != null) {
                            return Column(
                              children: [
                                for (var i in snapshot.data!.pickupVMs!)
                                  PickupCard(
                                    dUserID: widget.dUserID,
                                    driverID: widget.driverID,
                                    driverUsername: widget.driverUsername,
                                    awb: i.awb!,
                                    shipperMobileNumber: i.shipperMobileNumber!,
                                    shipperAddress: i.shipperAddress!,
                                    shipperName: i.shipperName!,
                                    scheduleID: i.scheduleID!,
                                    orderDetails: i.orderDetails!,
                                    oOrderNumber: i.oOrderNumber!,
                                  )
                              ],
                            );
                          } else if (snapshot.data!.pickupVMs!.isEmpty) {
                            return const Text('لا يوجد تحميلات حتي الان');
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}'
                              "You don't have data in this time");
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                // return PickupScreen(driverUsername: widget.driverUsername,dUserID: widget.dUserID,driverID: widget.driverID);
                return QRViewExample(
                  release: false,
                  driverUsername: widget.dUserID,
                  dUserID: widget.dUserID,
                  driverID: widget.driverID,
                );
              }),
            );
          },
          child: const Icon(Icons.qr_code_2_rounded),
        ),
      ),
    );
  }
}
