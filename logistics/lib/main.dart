import 'package:auth_repository/auth_repository.dart';
import 'package:admin_repository/admin_repository.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart'; 
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';
import 'package:logistcs/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = DbAuthRepository();
  final adminRepository = DbAdminRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<AdminRepository>.value(value: adminRepository), // Added AdminRepository
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(authRepository: authRepository)
              ..add(AuthStatusChecked()),
          ),
          BlocProvider(
            create: (context) => AdminBloc(
              adminRepository: adminRepository,
            ),
          ), //I provide adminbloc
        ],
        child: const MyApp(),
      ),
    ),
  );
}