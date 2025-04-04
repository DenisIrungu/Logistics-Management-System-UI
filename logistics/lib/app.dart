import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/appView.dart';
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';
import 'package:logistcs/screens/dashboards/admindashboard.dart';
import 'package:logistcs/screens/dashboards/agentdashboard.dart';
import 'package:logistcs/screens/dashboards/customerdashboard.dart';
import 'package:logistcs/screens/dashboards/riderdashboard.dart';
import 'package:logistcs/screens/deliveries/assigneddeliveries.dart';
import 'package:logistcs/screens/deliveries/deliverederdeliveries.dart';
import 'package:logistcs/screens/deliveries/deliveries_overview.dart';
import 'package:logistcs/screens/deliveries/pendingdeliveries.dart';
import 'package:logistcs/screens/onboardingscreen.dart';
import 'package:logistcs/screens/rider/add_new_rider/accountsetup.dart';
import 'package:logistcs/screens/rider/add_new_rider/basic_infor.dart';
import 'package:logistcs/screens/rider/add_new_rider/bike_information.dart';
import 'package:logistcs/screens/rider/add_new_rider/documents.dart';
import 'package:logistcs/screens/rider/add_new_rider/emergencycontacts.dart';
import 'package:logistcs/screens/rider/rider_management.dart';
import 'package:logistcs/screens/rider/tracking/rider_tracking.dart';
import 'package:logistcs/screens/sign_in_screen.dart';
import 'package:logistcs/screens/usermanager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        Widget homeScreen;

        if (state.status == AuthenticationStatus.authenticated) {
          // Navigate based on user role
          switch (state.role) {
            case 'admin':
              homeScreen = Admindashboard();
              break;
            case 'rider':
              homeScreen = RiderDashboard();
              break;
            case 'agent':
              homeScreen = AgentDashboard();
              break;
            case 'customer':
              homeScreen = CustomerDashboard();
              break;
            default:
              homeScreen = SignInScreen();
          }
        } else if (state.status == AuthenticationStatus.loading) {
          homeScreen = const Center(child: CircularProgressIndicator());
        } else {
          homeScreen = AppView();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dropu Logistics',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFFFFFF),
              onPrimary: const Color(0xFFFF9500),
              secondary: const Color(0xFFD9D9D8),
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.green,
              surface: const Color(0xFF0F0156),
              onSurface: Colors.white,
            ),
          ),
          home: homeScreen,
          routes: {
            '/onboardingscreen': (context) => const OnBoardingScreen(),
            '/ridermanagement': (context) => const RiderManagement(),
            '/ridertracking': (context) => const RiderTracking(),
            '/riderbasicinfor': (context) => const RiderBasicInfor(),
            '/riderbikeinfor': (context) => const RiderBikeInfor(),
            '/documentsupload': (context) => DocumentsUpload(),
            '/emergencycontacts': (context) => EmergencyContacts(),
            '/usermanagement': (context) => UserManagement(),
            '/accountsetup': (context) => AccountSetup(),
            '/signinscreen': (context) => const SignInScreen(),
            '/adminDashboard': (context) => Admindashboard(),
            '/riderDashboard': (context) => RiderDashboard(),
            '/agentDashboard': (context) => AgentDashboard(),
            '/customerDashboard': (context) => CustomerDashboard(),
            '/deliveryOverview': (context) => DeliveriesOverview(),
            '/pendingDeliveries': (context) => PendingDeliveries(),
            '/assignedDeliveries': (context) => AssignedDeliveries(),
            'delivereddeliveries': (context) => DeliveredDeliveriesScreen()
          },
        );
      },
    );
  }
}
