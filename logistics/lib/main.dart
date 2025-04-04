import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 
  final authRepository = DbAuthRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(authRepository: authRepository)
                  ..add(AuthStatusChecked()), 
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
