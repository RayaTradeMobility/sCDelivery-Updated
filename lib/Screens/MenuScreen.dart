// ignore_for_file: file_names

import 'package:RayaExpressDriver/Screens/TasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:RayaExpressDriver/Screens/HomeScreen.dart';
import 'LoginScreen.dart';
import 'PickupScreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen(
      {Key? key,
      required this.driverUsername,
      required this.dUserID,
      required this.driverID})
      : super(key: key);

  final String driverUsername, dUserID;
  final int driverID;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
        return true;
      },
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstOver),
              image: AssetImage("assets/background-Delivery.jpg"),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/RLogo.png',
                width: double.maxFinite,
                height: 200.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return HomeScreen(
                              driverUsername: widget.driverUsername,
                              dUserID: widget.dUserID,
                              driverID: widget.driverID);
                        }),
                      );
                    },
                    child: SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: Card(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/Delivery.png',
                              height: 80.0,
                              width: 80.0,
                            ),
                            const Text(
                              'Releases',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //pickup

                  TextButton(
                    onPressed: () {
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
                    },
                    child: SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: Card(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/Pickup (2).png',
                              height: 80.0,
                              width: 80.0,
                            ),
                            const Text(
                              'Pick UP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return TasksScreen(
                              driverUsername: widget.driverUsername,
                              dUserID: widget.dUserID,
                              driverID: widget.driverID);
                          // return QRViewExample();
                        }),
                      );
                    },
                    child: SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: Card(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/tasklist.png',
                              height: 80.0,
                              width: 80.0,
                            ),
                            const Text(
                              'Tasks',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
