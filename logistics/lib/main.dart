import 'package:auth_repository/auth_repository.dart';
import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/theme_bloc.dart';
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
        RepositoryProvider<AdminRepository>.value(value: adminRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(authRepository: authRepository)
                  ..add(AuthStatusChecked()),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(), // Add ThemeBloc provider
          ),
          BlocProvider(
            create: (context) => AdminBloc(
              adminRepository: adminRepository,
              themeBloc:
                  context.read<ThemeBloc>(), // Inject ThemeBloc into AdminBloc
            ),
          ),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              // Fetch admin profile when the user is authenticated
              context.read<AdminBloc>().add(FetchAdminProfile());
            }
          },
          child: const MyApp(),
        ),
      ),
    ),
  );
}
