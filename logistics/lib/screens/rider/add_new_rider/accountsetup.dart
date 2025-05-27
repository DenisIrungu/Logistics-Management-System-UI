import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/regexpressions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final TextEditingController _emailController = TextEditingController();
  bool accepttermsandcondition = false;
  Map<String, String>? riderData;
  bool _isRegistrationSuccessful = false; // Track registration success

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    riderData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    print('Received riderData in AccountSetup: $riderData');
    riderData?.forEach((key, value) {
      print('Field $key type: ${value.runtimeType}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminBlocState>(
      listener: (context, state) {
        print('AdminBloc state changed: $state');
        if (state.riderRegistrationState is RiderRegistrationSuccess) {
          print('Rider registration successful');
          setState(() {
            _isRegistrationSuccessful = true; // Update state on success
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rider registered successfully!')),
          );
        } else if (state.riderRegistrationState is RiderRegistrationFailure) {
          print(
              'Rider registration failed: ${(state.riderRegistrationState as RiderRegistrationFailure).error}');
          setState(() {
            _isRegistrationSuccessful = false; // Reset on failure
          });
        }
      },
      child: BlocBuilder<AdminBloc, AdminBlocState>(
        builder: (context, state) {
          print('Building UI with state: $state');
          String? errorMsg;
          if (state.riderRegistrationState is RiderRegistrationFailure) {
            errorMsg =
                (state.riderRegistrationState as RiderRegistrationFailure)
                    .error;
          }

          // Schedule snackbar after build if needed
          if (state.riderRegistrationState is RiderRegistrationSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Verification email resent successfully!')),
              );
            });
          } else if (state.riderRegistrationState is RiderRegistrationFailure &&
              state.riderRegistrationState !=
                  const RiderRegistrationFailure('Email is required') &&
              state.riderRegistrationState !=
                  const RiderRegistrationFailure(
                      'Please accept the terms and conditions')) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Failed to resend email: ${errorMsg ?? 'Unknown error'}')),
              );
            });
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: const Text(
                'Add New Rider',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      '5. Account Set up',
                      style: TextStyle(
                          color: Color(0xFF0F0156),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _emailController,
                      hintText: ' Email',
                      hintTextColor: const Color(0xFFFFFFFF),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      prefixIcon:
                          const Icon(Icons.mail, color: Color(0xFFFFFFFF)),
                      background: const Color(0xFF0F0156),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "The rider will receive an email with a link to set their password.",
                      style: TextStyle(
                        color: Color(0xFF0F0156),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: accepttermsandcondition,
                          activeColor: const Color(0xFF0F0156),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.orange),
                          onChanged: (bool? value) {
                            setState(() {
                              accepttermsandcondition = value ?? false;
                              errorMsg = null;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'I agree to the terms & Conditions',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                      ],
                    ),
                    if (errorMsg != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMsg!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 20),
                    state.riderRegistrationState is RiderRegistrationLoading
                        ? const CircularProgressIndicator()
                        : MyButton(
                            text: 'Save & Submit',
                            onPress: () {
                              if (!accepttermsandcondition) {
                                setState(() {
                                  errorMsg =
                                      "Please accept the terms and conditions";
                                });
                                print('Validation failed: Terms not accepted');
                                return;
                              }

                              if (_emailController.text.isEmpty ||
                                  !emailRegExp
                                      .hasMatch(_emailController.text)) {
                                setState(() {
                                  errorMsg = "Please enter a valid email";
                                });
                                print('Validation failed: Invalid email');
                                return;
                              }

                              final updatedRiderData =
                                  Map<String, String>.from(riderData ?? {});
                              updatedRiderData['email'] = _emailController.text;

                              final validatedRiderData = <String, String>{};
                              updatedRiderData.forEach((key, value) {
                                validatedRiderData[key] = value.toString();
                              });
                              validatedRiderData['terms_accepted'] =
                                  accepttermsandcondition.toString();

                              validatedRiderData.forEach((key, value) {
                                print(
                                    'Validated field $key type: ${value.runtimeType}');
                              });
                              print(
                                  'Updated riderData before validation: $validatedRiderData');

                              const requiredFields = [
                                'first_name',
                                'last_name',
                                'phone_number',
                                'bike_model',
                                'bike_color',
                                'plate_number',
                                'license',
                                'emergency_contact_name',
                                'emergency_contact_phone',
                                'emergency_contact_relationship',
                                'email',
                                'terms_accepted',
                                'id_document',
                                'driving_license',
                                'insurance',
                              ];

                              String? missingField;
                              for (var field in requiredFields) {
                                if (!validatedRiderData.containsKey(field) ||
                                    validatedRiderData[field] == null ||
                                    validatedRiderData[field]!.isEmpty) {
                                  missingField = field;
                                  break;
                                }
                              }

                              if (missingField != null) {
                                setState(() {
                                  errorMsg =
                                      "Missing required field: $missingField";
                                });
                                print(
                                    'Validation failed: Missing field: $missingField');
                                return;
                              }

                              print(
                                  'Submitting rider data: $validatedRiderData');
                              context.read<AdminBloc>().add(
                                  RegisterRider(riderData: validatedRiderData));
                            },
                            color: accepttermsandcondition
                                ? const Color(0xFF0F0156)
                                : Colors.grey,
                          ),
                    if (_isRegistrationSuccessful) ...[
                      const SizedBox(height: 20),
                      MyButton(
                        text: 'Resend Email',
                        onPress: () {
                          final email = _emailController.text;
                          if (email.isNotEmpty) {
                            context
                                .read<AdminBloc>()
                                .add(ResendRiderEmail(email: email));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter an email to resend.')),
                            );
                          }
                        },
                        color: const Color(0xFF0F0156),
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        text: 'Go to Dashboard',
                        onPress: () {
                          Navigator.pushNamed(context, '/adminDashboard');
                        },
                        color: const Color(0xFF0F0156),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
