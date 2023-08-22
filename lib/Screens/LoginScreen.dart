// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RayaExpressDriver/API/API.dart';
import 'package:RayaExpressDriver/Models/UserModel.dart';
import 'package:RayaExpressDriver/Screens/MenuScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:RayaExpressDriver/Services/ServicesUtililty.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/Constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String error = "";
  bool _passwordVisibility = true;
  API api = API();
  ServicesUtility deviceID = ServicesUtility();
  String deviceId = "Get Device ID";

  @override
  void initState() {
    super.initState();
    _loadUserEmailPassword();
  }

  Future<bool> onWillPop() {
    SystemNavigator.pop();

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: customLinearGradient),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/RLogo.png',
                      width: 500.0,
                      height: 200.0,
                    ),
                    loginCard(context),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_shipping,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Raya Express Driver APP",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container loginCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_rounded),
                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: username,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white,
                    hintText: "اسم المستخدم",
                    prefixIcon: const Icon(Icons.email),
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
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: password,
                obscureText: _passwordVisibility,
                decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                  ),
                  hintText: "كلمة السر",
                  prefixIcon: const Icon(Icons.password),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (password) {
                  if (isPasswordValid(password!)) {
                    return null;
                  } else {
                    return 'كلمه السر يجب ان تكون اكبر من 7 حروف او ارقام';
                  }
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isloading = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    try {
                      final tokenFcm =
                          await FirebaseMessaging.instance.getToken();
                      String deviceid = await deviceID.getId();
                      UserModel user = await api.login(
                          username.text,
                          password.text,
                          tokenFcm,
                          deviceid,
                          await ServicesUtility().getPackageInfo());
                      if (user.headerInfo!.code == "00") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MenuScreen(
                                driverUsername: user.name!,
                                dUserID: user.dUserID!,
                                driverID: user.driverID!);
                          }),
                        );
                      } else {
                        setState(() {
                          _isloading = false;
                        });
                        Fluttertoast.showToast(
                            msg: user.headerInfo!.message ?? 'Error Connection',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } on Exception {
                      setState(() {
                        _isloading = false;
                      });
                      Fluttertoast.showToast(
                          msg: 'Error Connection',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    setState(() {
                      _isloading = false;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Icon(Icons.login),
                    const Text("تسجيل الدخول"),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  fixedSize: const Size.fromWidth(200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () async {
                    if (kDebugMode) {
                      print(ServicesUtility().getPackageInfo());
                    }
                    String deviceID1 = await deviceID.getId();
                    setState(() {
                      deviceId = deviceID1;
                    });
                  },
                  child: Text(deviceId)),
            ),
            Center(
                child: Text(
              error,
              style: const TextStyle(color: Colors.red),
            )),
            Center(
              child: TextButton(
                onPressed: _launchURL,
                child: const Text('Privacy Policy'),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isPasswordValid(String password) => password.length >= 6;

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("UserName");
      var _password = _prefs.getString("Password");
      if (kDebugMode) {
        print(_email);
      }
      if (kDebugMode) {
        print(_password);
      }
      username.text = _email ?? "";
      password.text = _password ?? "";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _launchURL() async {
    const url =
        'https://www.termsfeed.com/live/2a3115d5-068d-4022-932f-a218e3793d95';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
