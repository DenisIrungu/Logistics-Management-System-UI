import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/regexpressions.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool accepttermsandcondition = false; // Default to false
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Add New Rider'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
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
              prefixIcon: const Icon(Icons.mail, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _passwordController,
              hintText: ' Password',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: obscurePassword,
              prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                color: const Color(0xFFFFFFFF),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    iconPassword = obscurePassword
                        ? CupertinoIcons.eye_fill
                        : CupertinoIcons.eye_slash_fill;
                  });
                },
                icon: Icon(iconPassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (!passWordRegExp.hasMatch(value)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _confirmPasswordController,
              hintText: ' Confirm Password',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: obscurePassword,
              prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: accepttermsandcondition,
                  activeColor: const Color(0xFF0F0156),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.orange),
                  onChanged: (bool? value) {
                    setState(() {
                      accepttermsandcondition = value ?? false;
                    });
                  },
                ),
                const SizedBox(width: 50),
                const Text(
                  'I agree to the terms & Conditions',
                  style: TextStyle(color: Color(0xFF0F0156)),
                )
              ],
            ),
            const SizedBox(height: 20),
            MyButton(
              text: 'Save & Submit',
              onPress: accepttermsandcondition ? () {} : () {},
              color: accepttermsandcondition
                  ? const Color(0xFF0F0156)
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
