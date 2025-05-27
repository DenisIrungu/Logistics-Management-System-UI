import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderBikeInfor extends StatefulWidget {
  const RiderBikeInfor({super.key});

  @override
  State<RiderBikeInfor> createState() => _RiderBikeInforState();
}

class _RiderBikeInforState extends State<RiderBikeInfor> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  String? _errorMessage;
  Map<String, String>? riderData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    riderData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    print('Received riderData in RiderBikeInfor: $riderData');
  }

  void _validateAndContinue() {
    if (_modelController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _plateNumberController.text.isEmpty ||
        _licenseController.text.isEmpty) {
      setState(() {
        _errorMessage = "All fields are required";
      });
      print('Validation failed in RiderBikeInfor: All fields are required');
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final updatedData = Map<String, String>.from(riderData ?? {});
    updatedData.addAll({
      'bike_model': _modelController.text,
      'bike_color': _colorController.text,
      'plate_number': _plateNumberController.text,
      'license': _licenseController.text,
    });

    print('Updated riderData in RiderBikeInfor: $updatedData');
    print('Navigating to /documentsupload with data: $updatedData');
    Navigator.pushNamed(
      context,
      '/documentsupload',
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
              '2. Bike information',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _modelController,
              hintText: '  Model',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon:
                  const Icon(Icons.pedal_bike, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _colorController,
              hintText: '  Color',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon:
                  const Icon(Icons.color_lens, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _plateNumberController,
              hintText: '  Plate Number',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon:
                  const Icon(Icons.confirmation_num, color: Color(0xFFFFFFFF)),
              background: const Color(0xFF0F0156),
            ),
            const SizedBox(height: 10),
            MyTextField(
              background: const Color(0xFF0F0156),
              controller: _licenseController,
              hintText: '  License',
              hintTextColor: const Color(0xFFFFFFFF),
              obscureText: false,
              prefixIcon:
                  const Icon(Icons.assignment, color: Color(0xFFFFFFFF)),
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
