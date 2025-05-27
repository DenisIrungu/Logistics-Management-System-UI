import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/appView.dart';
import 'package:logistcs/blocs/admin/theme_bloc.dart';
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';
import 'package:logistcs/screens/admindashboarddrawer/feedbacks.dart';
import 'package:logistcs/screens/admindashboarddrawer/preferences.dart';
import 'package:logistcs/screens/admindashboarddrawer/profilescreen.dart';
import 'package:logistcs/screens/admindashboarddrawer/top_5_regions.dart';
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            Widget homeScreen;

            if (state.status == AuthenticationStatus.authenticated) {
              // Navigate based on user role
              switch (state.role) {
                case 'admin':
                  homeScreen = Admindashboard();
                  print('Navigating to Admindashboard');
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
              theme: themeState.themeData, // Use dynamic theme from ThemeBloc
              home: homeScreen,
              routes: {
                '/onboardingscreen': (context) => const OnBoardingScreen(),
                '/ridermanagement': (context) => const RiderManagement(),
                '/ridertracking': (context) => const RiderTracking(),
                '/riderbasicinfor': (context) => const RiderBasicInfor(),
                '/riderbikeinfor': (context) => const RiderBikeInfor(),
                '/documentsupload': (context) => const DocumentsUpload(),
                '/emergencycontacts': (context) => const EmergencyContacts(),
                '/usermanagement': (context) => const UserManagement(),
                '/accountsetup': (context) => const AccountSetup(),
                '/signinscreen': (context) => const SignInScreen(),
                '/adminDashboard': (context) => const Admindashboard(),
                '/riderDashboard': (context) => const RiderDashboard(),
                '/agentDashboard': (context) => const AgentDashboard(),
                '/customerDashboard': (context) => const CustomerDashboard(),
                '/deliveryOverview': (context) => const DeliveriesOverview(),
                '/pendingDeliveries': (context) => const PendingDeliveries(),
                '/assignedDeliveries': (context) => const AssignedDeliveries(),
                '/delivereddeliveries': (context) =>
                    const DeliveredDeliveriesScreen(),
                '/profilescreen': (context) => const ProfileScreen(),
                '/preferencescreen': (context) => const PreferencesScreen(),
                '/top5bestregions': (context) => const Top5Regions(),
                '/feedbacks': (context) => const FeedBacks()
              },
            );
          },
        );
      },
    );
  }
}
