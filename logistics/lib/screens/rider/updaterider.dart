import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/shared_rider.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added for BLoC
import 'package:logistcs/blocs/admin/admin_bloc.dart'; // Added for AdminBloc
import 'package:logistcs/blocs/admin/admin_event.dart'; // Added for AdminEvent
import 'package:logistcs/blocs/admin/admin_state.dart'; // Added for AdminState

class RiderUpdateScreen extends StatefulWidget {
  final Rider rider;

  const RiderUpdateScreen({super.key, required this.rider});

  @override
  State<RiderUpdateScreen> createState() => _RiderUpdateScreenState();
}

class _RiderUpdateScreenState extends State<RiderUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bikeModelController = TextEditingController();
  final _bikeColorController = TextEditingController();
  final _bikeNumberController = TextEditingController();
  final _licenseController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  PlatformFile? _drivingLicenseFile;
  PlatformFile? _insuranceFile;

  Future<void> _pickFile(String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (field == 'driving_license') {
          _drivingLicenseFile = result.files.single;
        } else if (field == 'insurance') {
          _insuranceFile = result.files.single;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(
        'Received Rider in RiderUpdateScreen: ${widget.rider.name}, ID: ${widget.rider.id}');
    final nameParts = widget.rider.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _emailController.text = widget.rider.email;
    _phoneController.text = widget.rider.phoneNumber;
    _bikeModelController.text = widget.rider.bikeModel;
    _bikeColorController.text = widget.rider.bikeColor;
    _bikeNumberController.text = widget.rider.bikeNumber;
    _licenseController.text = widget.rider.license;
    _emergencyNameController.text = widget.rider.emergencyContactName;
    _emergencyPhoneController.text = widget.rider.emergencyContactPhone;
    _relationshipController.text = widget.rider.emergencyContactRelationship;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bikeModelController.dispose();
    _bikeColorController.dispose();
    _bikeNumberController.dispose();
    _licenseController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Prepare fields map (only include non-empty fields)
      final fields = <String, String>{};
      if (_firstNameController.text.isNotEmpty &&
          _firstNameController.text != widget.rider.name.split(' ').first) {
        fields['first_name'] = _firstNameController.text;
      }
      if (_lastNameController.text.isNotEmpty &&
          _lastNameController.text !=
              widget.rider.name.split(' ').sublist(1).join(' ')) {
        fields['last_name'] = _lastNameController.text;
      }
      if (_emailController.text.isNotEmpty &&
          _emailController.text != widget.rider.email) {
        fields['email'] = _emailController.text;
      }
      if (_phoneController.text.isNotEmpty &&
          _phoneController.text != widget.rider.phoneNumber) {
        fields['phone_number'] = _phoneController.text;
      }
      if (_bikeModelController.text.isNotEmpty &&
          _bikeModelController.text != widget.rider.bikeModel) {
        fields['bike_model'] = _bikeModelController.text;
      }
      if (_bikeColorController.text.isNotEmpty &&
          _bikeColorController.text != widget.rider.bikeColor) {
        fields['bike_color'] = _bikeColorController.text;
      }
      if (_bikeNumberController.text.isNotEmpty &&
          _bikeNumberController.text != widget.rider.bikeNumber) {
        fields['bike_number'] = _bikeNumberController.text;
      }
      if (_licenseController.text.isNotEmpty &&
          _licenseController.text != widget.rider.license) {
        fields['license'] = _licenseController.text;
      }
      if (_emergencyNameController.text.isNotEmpty &&
          _emergencyNameController.text != widget.rider.emergencyContactName) {
        fields['emergency_contact_name'] = _emergencyNameController.text;
      }
      if (_emergencyPhoneController.text.isNotEmpty &&
          _emergencyPhoneController.text != widget.rider.emergencyContactPhone) {
        fields['emergency_contact_phone'] = _emergencyPhoneController.text;
      }
      if (_relationshipController.text.isNotEmpty &&
          _relationshipController.text != widget.rider.emergencyContactRelationship) {
        fields['emergency_contact_relationship'] = _relationshipController.text;
      }

      // Prepare files map
      final files = <String, File>{};
      if (_drivingLicenseFile != null) {
        files['driving_license'] = File(_drivingLicenseFile!.path!);
      }
      if (_insuranceFile != null) {
        files['insurance'] = File(_insuranceFile!.path!);
      }

      // Dispatch UpdateRider event
      BlocProvider.of<AdminBloc>(context).add(UpdateRider(
        riderId: widget.rider.id,
        fields: fields,
        files: files,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const textFieldStyle = TextStyle(color: Color(0xFF0F0156));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Update Rider Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Rider Information',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F0156)),
              ),
              const SizedBox(height: 16),
              const Text('Personal Information',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0156))),
              const SizedBox(height: 8),
              MyTextField(
                controller: _firstNameController,
                background: const Color(0xFF0F0156),
                hintText: 'First Name',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _lastNameController,
                background: const Color(0xFF0F0156),
                hintText: 'Last Name',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _emailController,
                background: const Color(0xFF0F0156),
                hintText: "Email",
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _phoneController,
                background: const Color(0xFF0F0156),
                hintText: 'Phone Number',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Bike Details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0156))),
              const SizedBox(height: 8),
              MyTextField(
                controller: _bikeModelController,
                background: const Color(0xFF0F0156),
                hintText: 'Model',
                hintTextColor: Colors.white,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _bikeColorController,
                background: const Color(0xFF0F0156),
                hintText: 'Color',
                hintTextColor: Colors.white,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _bikeNumberController,
                background: const Color(0xFF0F0156),
                hintText: 'Bike Number',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _licenseController,
                background: const Color(0xFF0F0156),
                hintText: 'License',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Emergency Contact',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0156))),
              const SizedBox(height: 8),
              MyTextField(
                controller: _emergencyNameController,
                background: const Color(0xFF0F0156),
                hintText: 'Full Name',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _emergencyPhoneController,
                background: const Color(0xFF0F0156),
                hintText: 'Phone Number',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _relationshipController,
                background: const Color(0xFF0F0156),
                hintText: 'Relationship',
                hintTextColor: Colors.white,
                obscureText: false,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Documents',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F0156))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _drivingLicenseFile != null
                          ? 'Selected: ${_drivingLicenseFile!.path!.split('/').last}'
                          : 'Current: ${widget.rider.drivingLicense ?? "None"}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F0156)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _pickFile('driving_license'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F0156),
                    ),
                    child: const Text('Replace License',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _insuranceFile != null
                          ? 'Selected: ${_insuranceFile!.path!.split('/').last}'
                          : 'Current: ${widget.rider.insurance ?? "None"}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F0156)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _pickFile('insurance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F0156),
                    ),
                    child: const Text('Replace Insurance',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              BlocBuilder<AdminBloc, AdminBlocState>(
                builder: (context, state) {
                  if (state.riderUpdateState is RiderUpdateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F0156),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Handle success and failure states
              BlocListener<AdminBloc, AdminBlocState>(
                listener: (context, state) {
                  if (state.riderUpdateState is RiderUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rider updated successfully')),
                    );
                    Navigator.pop(context);
                  } else if (state.riderUpdateState is RiderUpdateFailure) {
                    final failure = state.riderUpdateState as RiderUpdateFailure;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update rider: ${failure.error}')),
                    );
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}