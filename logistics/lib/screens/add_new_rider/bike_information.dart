import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderBikeInfor extends StatefulWidget {
  const RiderBikeInfor({super.key});

  @override
  State<RiderBikeInfor> createState() => _RiderBasicInforState();
}

class _RiderBasicInforState extends State<RiderBikeInfor> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
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
              '2. Bike information',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            MyTextField(
                controller: _modelController,
                hintText: '  Model',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(
                  Icons.pedal_bike,
                  color: Color(0xFFFFFFFF),
                ),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: _colorController,
                hintText: '  Color',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon: Icon(Icons.color_lens, color: Color(0xFFFFFFFF)),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: _plateNumberController,
                hintText: '  Plate Number',
                hintTextColor: Color(0xFFFFFFFF),
                obscureText: false,
                prefixIcon:
                    Icon(Icons.confirmation_num, color: Color(0xFFFFFFFF)),
                background: Color(0xFF0F0156)),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              background: Color(0xFF0F0156),
              controller: _licenseController,
              hintText: '  License',
              hintTextColor: Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon: Icon(Icons.assignment, color: Color(0xFFFFFFFF)),
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
                text: 'Continue',
                onPress: () {
                  Navigator.pushNamed(context, '/documentsupload');
                },
                color: Color(0xFF0F0156))
          ],
        ),
      ),
    );
  }
}
