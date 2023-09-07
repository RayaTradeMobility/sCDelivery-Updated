// ignore_for_file: file_names

import 'package:RayaExpressDriver/Screens/MenuScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../API/API.dart';
import '../Constants/Constants.dart';
import '../Models/ReleasesModel.dart';
import 'QRCodeScreen.dart';
import 'ReleaseBySearchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key,
      required this.dUserID,
      required this.driverID,
      required this.driverUsername})
      : super(key: key);
  final String dUserID;
  final int driverID;
  final String driverUsername;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Widget customSearchBar = const Text("بحث برقم اذن التسليم");
  Icon customIcon = const Icon(Icons.search);
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  late Future<ReleasesModel> releasesNew, releasesOld, releasesBySerach;
  API api = API();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey2 =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    releasesNew = api.getReleases(widget.driverID, true);
    releasesOld = api.getReleases(widget.driverID, false);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<bool> _onBackPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MenuScreen(
        driverUsername: widget.driverUsername,
        dUserID: widget.dUserID,
        driverID: widget.driverID,
      );
    }));
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3f8dfd),
          title: customSearchBar,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('${widget.driverID} ${widget.dUserID}');
                }
                if (customIcon.icon == Icons.search) {
                  setState(() {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ReleaseBySearchScreen(
                                dUserID: widget.dUserID,
                                driverID: widget.driverID,
                                driverUsername: widget.driverUsername,
                                orderNumber: searchController.text,
                                awb: '',
                              );
                            }),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'رقم اذن التسليم...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  });
                } else {
                  setState(() {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('اذونات التسليم');
                  });
                }
              },
              icon: customIcon,
            )
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
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    isScrollable: false,
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: const Color(0xFF3f8dfd),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,

                    tabs: const [
                      // first tab [you can add a n icon using the icon property]
                      Tab(
                        text: 'الطلبات الجديدة',
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'الطلبات المكتملة',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // first tab bar view widget
                      RefreshIndicator(
                        key: _refreshIndicatorKey2,
                        onRefresh: () async {
                          _refreshIndicatorKey2.currentState!.show();
                          setState(() {
                            releasesNew =
                                api.getReleases(widget.driverID, true);
                          });
                        },
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              FutureBuilder<ReleasesModel>(
                                future: releasesNew,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        for (var r
                                            in snapshot.data!.releaseRequests!)
                                          ReleasesCard(
                                              releasenew: true,
                                              driverUsername:
                                                  widget.driverUsername,
                                              cAddress: r.cAddress!,
                                              cMobileNumber1: r.cMobileNumber1!,
                                              cName: r.cName!,
                                              dNameAR: r.dNameAr!,
                                              oCreatedDate: r.oCreatedDate!,
                                              orderID: r.orderId!,
                                              releaseID: r.releaseId!,
                                              rShipmentID: r.rShipmentId!,
                                              // isUseOTP: r.isUseOTP!,
                                              driverID: widget.driverID,
                                              dUserID: widget.dUserID,
                                              paymentstatus: r.paymentStatusID,
                                              oSystemStatusID:
                                                  r.oSystemStatusID),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}'
                                        "You don't have data in this time");
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            ],
                          ),
                        )),
                      ),
                      // second tab bar view widget
                      RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          _refreshIndicatorKey.currentState!.show();
                          setState(() {
                            releasesOld =
                                api.getReleases(widget.driverID, false);
                          });
                        },
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              FutureBuilder<ReleasesModel>(
                                future: releasesOld,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.releaseRequests !=
                                        null) {
                                      return Column(
                                        children: [
                                          for (var r in snapshot
                                              .data!.releaseRequests!)
                                            ReleasesCard(
                                              releasenew: false,
                                              driverUsername:
                                                  widget.driverUsername,
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
                                              paymentstatus: 0,
                                              oSystemStatusID: 0,
                                              // isUseOTP: r.isUseOTP!,
                                              
                                            ),
                                        ],
                                      );
                                    } else {
                                      return const Text('No Data');
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}'
                                        "You don't have data in this time");
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            ],
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
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
                  driverID: widget.driverID,
                  dUserID: widget.dUserID,
                  driverUsername: widget.driverUsername,
                  release: true,
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
