import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';

class EmergencyContacts extends StatefulWidget {
  const EmergencyContacts({super.key});

  @override
  State<EmergencyContacts> createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  String? _errorMessage;
  Map<String, String>? riderData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    riderData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    print('Received riderData in EmergencyContacts: $riderData');
  }

  void _validateAndContinue() {
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _relationshipController.text.isEmpty) {
      setState(() {
        _errorMessage = "All fields are required";
      });
      print('Validation failed in EmergencyContacts: All fields are required');
      return;
    }

    if (!_phoneNumberController.text.startsWith("07") ||
        _phoneNumberController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(_phoneNumberController.text)) {
      setState(() {
        _errorMessage = "Please enter a valid phone number (e.g., 07XXXXXXXX)";
      });
      print('Validation failed in EmergencyContacts: Invalid phone number');
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final updatedData = Map<String, String>.from(riderData ?? {});
    updatedData.addAll({
      'emergency_contact_name': _fullNameController.text,
      'emergency_contact_phone': _phoneNumberController.text,
      'emergency_contact_relationship': _relationshipController.text,
    });

    print('Updated riderData in EmergencyContacts: $updatedData');
    print('Navigating to /accountsetup with data: $updatedData');
    Navigator.pushNamed(
      context,
      '/accountsetup',
      arguments: updatedData,
    );
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
              '4. Emergency Contacts',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _fullNameController,
              hintText: '  Full Name',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon: const Icon(Icons.person, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _phoneNumberController,
              hintText: '  Phone Number',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon: const Icon(Icons.phone, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _relationshipController,
              hintText: '  Relationship',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon: const Icon(Icons.group, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
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
              color: const Color(0xFF0F0156),
            ),
          ],
        ),
      ),
    );
  }
}
