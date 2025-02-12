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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: Text('Add New Rider'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              '4. Emergency Contacts',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MyTextField(
                controller: _fullNameController,
                hintText: '  Full Name',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xFFFFFFFF),
                ),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: _phoneNumberController,
                hintText: '  Phone Number',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(Icons.phone, color: Color(0xFFFFFFFF)),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: _relationshipController,
                hintText: '  Relationship',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(Icons.group, color: Color(0xFFFFFFFF)),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 20,
            ),
            MyButton(
                text: 'Continue',
                onPress: () {
                  Navigator.pushNamed(context, '/accountsetup');
                },
                color: Color(0xFF0F0156))
          ],
        ),
      ),
    );
  }
}
