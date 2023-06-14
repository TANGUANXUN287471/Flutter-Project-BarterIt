import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barter_it/models/user.dart';
import 'myconfig.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/barter.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "BARTER IT",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              CircularProgressIndicator(),
              Text(
                "Version 0.1",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    bool isCheck = (prefs.getBool('checkbox')) ?? false;
    late User user;

    if (isCheck) {
      try {
        http.post(
            Uri.parse("${MyConfig().server}/barter_it/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            //debugPrint(response.body);
            //if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            /*}else {
            user = User(
              id: "N/A",
              name: "N/A",
              email: "N/A",
              phone: "N/A",
              password: "N/A",
              datereg: "N/A",
              otp: "N/A",
            );
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }*/
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
            user = User(
              id: "N/A",
              name: "N/A",
              email: "N/A",
              phone: "N/A",
              password: "N/A",
              datereg: "N/A",
              otp: "N/A",
            );
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {});
      } on TimeoutException catch (_) {
        debugPrint("Time Out");
      }
    } else {
      user = User(
        id: "N/A",
        name: "N/A",
        email: "N/A",
        phone: "N/A",
        password: "N/A",
        datereg: "N/A",
        otp: "N/A",
      );
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
