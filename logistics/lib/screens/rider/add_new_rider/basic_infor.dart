import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderBasicInfor extends StatefulWidget {
  const RiderBasicInfor({super.key});

  @override
  State<RiderBasicInfor> createState() => _RiderBasicInforState();
}

class _RiderBasicInforState extends State<RiderBasicInfor> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _errorMessage;

  void _validateAndContinue() {
    print('Validating basic info...');
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      setState(() {
        _errorMessage = "All fields are required";
      });
      print('Validation failed: All fields are required');
      return;
    }

    if (!_phoneNumberController.text.startsWith("07") ||
        _phoneNumberController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(_phoneNumberController.text)) {
      setState(() {
        _errorMessage = "Please enter a valid phone number (e.g., 07XXXXXXXX)";
      });
      print('Validation failed: Invalid phone number');
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final riderData = <String, String>{
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone_number': _phoneNumberController.text,
    };

    print('Collected basic info: $riderData');
    print('Navigating to /riderbikeinfor with data: $riderData');
    Navigator.pushNamed(context, '/riderbikeinfor', arguments: riderData);
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              '1. Basic information',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            MyTextField(
                controller: _firstNameController,
                hintText: '  First Name',
                hintTextColor: const Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: const Icon(Icons.person, color: Color(0xFFFFFFFF)),
                background: const Color(0xFF0F0156)),
            const SizedBox(height: 10),
            MyTextField(
                controller: _lastNameController,
                hintText: '  Last Name',
                hintTextColor: const Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon:
                    const Icon(Icons.person_2, color: Color(0xFFFFFFFF)),
                background: const Color(0xFF0F0156)),
            const SizedBox(height: 10),
            MyTextField(
                controller: _phoneNumberController,
                hintText: '  Phone Number',
                hintTextColor: const Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFFFFFFF)),
                background: const Color(0xFF0F0156),
                keyboardType: TextInputType.phone),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            MyButton(
                text: 'Continue',
                onPress: _validateAndContinue,
                color: const Color(0xFF0F0156)),
          ],
        ),
      ),
    );
  }
}
