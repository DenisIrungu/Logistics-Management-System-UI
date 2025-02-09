import 'package:flutter/material.dart';
import 'package:logistcs/appView.dart';
import 'package:logistcs/screens/add_new_rider/accountsetup.dart';
import 'package:logistcs/screens/add_new_rider/basic_infor.dart';
import 'package:logistcs/screens/add_new_rider/bike_information.dart';
import 'package:logistcs/screens/add_new_rider/documents.dart';
//import 'package:logistcs/screens/add_new_rider/emergencycontacts.dart';
import 'package:logistcs/screens/add_new_rider/emergencycontacts.dart';

import 'package:logistcs/screens/admindashboard.dart';
import 'package:logistcs/screens/onboardingscreen.dart';
import 'package:logistcs/screens/rider_management.dart';
import 'package:logistcs/screens/sign_in_screen.dart';
import 'package:logistcs/screens/usermanager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dropu Logistics',
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: Color(0xFFFFFFFF), // Texts on blue background
            onPrimary: Color(0xFFFF9500), // Border
            secondary: Color(0xFFD9D9D8), // Secondary color
            onSecondary: Colors.black, // Text/icon color on secondary
            error: Colors.red, // Error color
            onError: Colors.green,
            surface: Color(0xFF0F0156),
            onSurface: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        home: AppView(),
        routes: {
          '/onboaradingscreen': (context) => const OnBoardingScreen(),
          '/signinscreen': (context) => const SignInScreen(),
          '/admindashboard': (context) => Admindashboard(),
          '/usermanagement': (context) => UserManagement(),
          '/ridermanagement': (context) => RiderManagement(),
          '/riderbasicinfor': (context) => RiderBasicInfor(),
          '/riderbikeinfor': (context) => RiderBikeInfor(),
          '/documentsupload': (context) => DocumentsUpload(),
          '/emergencycontacts': (context) => EmergencyContacts(),
          '/accountsetup': (context)=> AccountSetup(),
        });
  }
}
