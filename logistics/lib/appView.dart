import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';
import 'package:logistcs/screens/dashboards/admindashboard.dart';
import 'package:logistcs/screens/dashboards/agentdashboard.dart';
import 'package:logistcs/screens/dashboards/customerdashboard.dart';
import 'package:logistcs/screens/dashboards/riderdashboard.dart';
import 'package:logistcs/screens/onboardingscreen.dart';
import 'package:logistcs/screens/splashscreen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.unknown ||
            state.status == AuthenticationStatus.unauthenticated) {
          return SplashScreen();
        } else if (state.status == AuthenticationStatus.authenticated) {
          switch (state.role) {
            case 'admin':
              return const Admindashboard();
            case 'agent':
              return const AgentDashboard();
            case 'rider':
              return const RiderDashboard();
            case 'customer':
              return const CustomerDashboard();
            default:
              return const SplashScreen();
          }
        } else {
          return OnBoardingScreen();
        }
      },
    );
  }
}
