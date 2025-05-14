import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? _currentTheme;
  bool? _currentNotifications;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Fetch preferences on screen load
    context.read<AdminBloc>().add(FetchAdminPreferences());
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disable Notifications'),
          content:
              const Text('Are you sure you want to disable all notifications?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without changing
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  _currentNotifications = false;
                  _hasChanges = _currentTheme !=
                          (context.read<AdminBloc>().state.preferencesState
                                  as PreferencesSuccess)
                              .theme ||
                      _currentNotifications !=
                          (context.read<AdminBloc>().state.preferencesState
                                  as PreferencesSuccess)
                              .notifications;
                });
                Navigator.of(context).pop(); // Close dialog and update state
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminBlocState>(
      listener: (context, state) {
        // Handle update state for save operation
        if (state.updateState is UpdateSuccess) {
          _showSnackBar('Preferences updated successfully', Colors.green);
          setState(() {
            _hasChanges = false;
          });
        } else if (state.updateState is UpdateFailure) {
          final error = (state.updateState as UpdateFailure).error;
          String errorMessage;
          if (error.contains('403')) {
            errorMessage =
                'Saving preferences failed: You are not authorized. Please log in again.';
          } else if (error.contains('404')) {
            errorMessage =
                'Saving preferences failed: User not found. Please try logging in again.';
          } else if (error.contains('Failed to update preferences')) {
            errorMessage =
                'Saving preferences failed: Unable to connect to the server. Please check your internet connection.';
          } else {
            errorMessage =
                'Saving preferences failed: An unexpected error occurred. Please try again later.';
          }
          _showSnackBar(errorMessage, Colors.red);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text(
            'Preferences',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<AdminBloc, AdminBlocState>(
          builder: (context, state) {
            // Handle loading state
            if (state.preferencesState is PreferencesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle error state
            if (state.preferencesState is PreferencesFailure) {
              final error =
                  (state.preferencesState as PreferencesFailure).error;
              String errorMessage;
              if (error.contains('403')) {
                errorMessage =
                    'Loading preferences failed: You are not authorized. Please log in again.';
              } else if (error.contains('404')) {
                errorMessage =
                    'Loading preferences failed: User not found. Please try logging in again.';
              } else if (error.contains('Failed to fetch preferences')) {
                errorMessage =
                    'Loading preferences failed: Unable to connect to the server. Please check your internet connection.';
              } else {
                errorMessage =
                    'Loading preferences failed: An unexpected error occurred. Please try again later.';
              }
              return Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            }

            // Handle success state
            final preferencesState =
                state.preferencesState as PreferencesSuccess;
            final theme = preferencesState.theme;
            final notifications = preferencesState.notifications;

            // Initialize current values if not set
            _currentTheme ??= theme;
            _currentNotifications ??= notifications;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Preferences',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF0F0156),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize your app experience',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF0F0156),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Theme Toggle
                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color(0xFFFF9500), width: 2), // Orange border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.brightness_6,
                            color: Colors.white, // Always white
                          ),
                          const SizedBox(width: 12),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Theme',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Light / Dark',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Switch(
                                      value: _currentTheme == 'dark',
                                      onChanged: (value) {
                                        setState(() {
                                          _currentTheme =
                                              value ? 'dark' : 'light';
                                          _hasChanges =
                                              _currentTheme != theme ||
                                                  _currentNotifications !=
                                                      notifications;
                                        });
                                      },
                                      activeColor: Colors.white,
                                      activeTrackColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white30
                                              : Colors.white70,
                                      inactiveTrackColor:
                                          const Color(0xFFFF9500),
                                      inactiveThumbColor:
                                          const Color(0xFFFF9500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Notifications Master Toggle
                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color(0xFFFF9500), width: 2), // Orange border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Colors.white, // Always white
                          ),
                          const SizedBox(width: 12),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Notifications',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Enable Notifications',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Switch(
                                      value: _currentNotifications!,
                                      onChanged: (value) {
                                        if (!value) {
                                          _showConfirmationDialog();
                                        } else {
                                          setState(() {
                                            _currentNotifications = value;
                                            _hasChanges =
                                                _currentTheme != theme ||
                                                    _currentNotifications !=
                                                        notifications;
                                          });
                                        }
                                      },
                                      activeColor: Colors.white,
                                      activeTrackColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white30
                                              : Colors.white70,
                                      inactiveTrackColor:
                                          const Color(0xFFFF9500),
                                      inactiveThumbColor:
                                          const Color(0xFFFF9500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Save Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _hasChanges &&
                                state.updateState is! UpdateLoading
                            ? () {
                                context.read<AdminBloc>().add(
                                      UpdateAdminPreferences(
                                        theme: _currentTheme!,
                                        notifications: _currentNotifications!,
                                      ),
                                    );
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF0F0156),
                            width: 2.0,
                          ),
                          foregroundColor: const Color(0xFFFF9500),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: state.updateState is UpdateLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0F0156),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                    color: Color(0xFFFF9500),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
