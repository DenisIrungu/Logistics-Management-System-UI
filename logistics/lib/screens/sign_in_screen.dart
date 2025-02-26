import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/authorization/authentication_bloc.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/regexpressions.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = Icons.visibility;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0156),
        elevation: 0,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            // Navigate based on the user role
            if (state.role == 'admin') {
              Navigator.pushReplacementNamed(context, '/adminDashboard');
            } else if (state.role == 'rider') {
              Navigator.pushReplacementNamed(context, '/riderDashboard');
            } else if (state.role == 'agent') {
              Navigator.pushReplacementNamed(context, '/agentDashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/customerDashboard');
            }
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid email or password"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFF9500)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        Image.asset("lib/images/logo.jpeg", fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF0F0156)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  labelText: 'Password',
                  obscureText: obscurePassword,
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF0F0156)),
                  suffixIcon: IconButton(
                    icon: Icon(iconPassword, color: const Color(0xFF0F0156)),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        iconPassword = obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (!passWordRegExp.hasMatch(value)) {
                      return 'Invalid password format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    final isLoading =
                        state.status == AuthenticationStatus.loading;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null // Disable button while loading
                          : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isNotEmpty && password.isNotEmpty) {
                                context.read<AuthenticationBloc>().add(
                                      AuthLoginRequested(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F0156),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Sign In',
                              style: TextStyle(fontSize: 18)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
