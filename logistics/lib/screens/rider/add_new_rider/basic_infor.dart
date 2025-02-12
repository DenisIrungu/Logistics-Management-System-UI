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
  final TextEditingController _emailController = TextEditingController();
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
              '1. Basic information',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MyTextField(
                controller: _firstNameController,
                hintText: '  First Name',
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
                controller: _lastNameController,
                hintText: '  Last Name',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(Icons.person_2, color: Color(0xFFFFFFFF)),
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
              background: Color(0xFF0F0156),
              controller: _emailController,
              hintText: '  Email',
              hintTextColor: Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon: Icon(Icons.mail, color: Color(0xFFFFFFFF)),
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
                text: 'Continue',
                onPress: () {
                  print('Button pressed!');
                  Navigator.pushNamed(context, '/riderbikeinfor');
                },
                color: Color(0xFF0F0156))
          ],
        ),
      ),
    );
  }
}
