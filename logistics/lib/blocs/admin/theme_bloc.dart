import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

// Events
abstract class ThemeEvent {
  const ThemeEvent();
}

class UpdateTheme extends ThemeEvent {
  final String theme;

  const UpdateTheme(this.theme);
}

// State
class ThemeState {
  final ThemeData themeData;

  const ThemeState(this.themeData);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(_buildThemeData('light'))) {
    on<UpdateTheme>(_onUpdateTheme);
  }

  static ThemeData _buildThemeData(String theme) {
    final isDark = theme == 'dark';
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: const Color(0xFF1E1E1E), // Darker primary for dark mode
              onPrimary: const Color(0xFFFF9500),
              secondary: const Color(0xFF616161), // Darker secondary
              onSecondary: Colors.white, // Lighter text for dark background
              error: Colors.red,
              onError: Colors.green,
              surface: const Color(
                  0xFF121212), // Dark surface (used by cards, dialogs)
              onSurface: Colors.white, // Black background for dark mode
            )
          : ColorScheme.light(
              primary: const Color(0xFFFFFFFF),
              onPrimary: const Color(0xFFFF9500),
              secondary: const Color(0xFFD9D9D8),
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.green,
              surface: const Color(0xFF0F0156),
              onSurface: Colors.white,
            ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF000000)
          : Colors.white, // Ensure Scaffold background changes
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF),
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Future<void> _onUpdateTheme(
      UpdateTheme event, Emitter<ThemeState> emit) async {
    print('ThemeBloc: Updating theme to ${event.theme}');
    emit(ThemeState(_buildThemeData(event.theme)));
  }
}
