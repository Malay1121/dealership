import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealership/screens/employee_home.dart';
import 'package:dealership/screens/get_started.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'home_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> shared() async {
    shared(BuildContext context) async {

      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      
      var _sharedPreferences = await SharedPreferences.getInstance();

      await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: _sharedPreferences.getString('username'))
          .get()
          .then((value) => {
                name = value.docs[0]['name'],
                password = value.docs[0]['password'],
                phone = value.docs[0]['phone'],
                uid = value.docs[0]['uid'],
                if (_sharedPreferences.getString('username') ==
                    value.docs[0]['name'])
                  {
                    if (_sharedPreferences.getString('password') ==
                        value.docs[0]['password'])
                      {
                        setState(() {
                          employee = value.docs[0]['employee'] == null
                              ? false
                              : value.docs[0]['employee'];
                        }),
                        WidgetsBinding.instance?.addPostFrameCallback((_) {
                          if (employee == false) {
                            setState(() {
                              home = true;
                            });
                          } else {
                            setState(() {
                              employeeHome = true;
                            });
                          }
                        }),
                      }
                  }
              });
    }

    await shared(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shared();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/background.png',
              ),
            ),
          ),
          child: AnimatedSplashScreen(
            splash: Image.asset('assets/car.png'),
            nextScreen: home == true
                ? HomePage()
                : employeeHome == true
                    ? EmployeeHome()
                    : GetStarted(),
            splashIconSize: MediaQuery.of(context).size.width / 2.69672131,
            backgroundColor: Color(0xFF1773FD),
            function: shared,
          ),
        ),
      ),
    );
  }
}
