import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/uploadfield.dart';
import 'package:file_picker/file_picker.dart';

class DocumentsUpload extends StatefulWidget {
  const DocumentsUpload({super.key});

  @override
  State<DocumentsUpload> createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {
  final Map<String, PlatformFile?> _uploadedFiles = {
    'id': null,
    'driving_license': null,
    'insurance': null,
  };
  String? _errorMessage;
  Map<String, String>? riderData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    riderData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    print('Received riderData in DocumentsUpload: $riderData');
  }

  void _validateAndContinue() {
    bool allFilesUploaded = _uploadedFiles.values.every((file) => file != null);
    if (!allFilesUploaded) {
      setState(() {
        _errorMessage =
            "Please upload all required documents (ID, Driving License, Insurance)";
      });
      print('Validation failed in DocumentsUpload: Missing documents');
      return;
    }

    // Additional check for null paths
    bool allPathsValid =
        _uploadedFiles.values.every((file) => file!.path != null);
    if (!allPathsValid) {
      setState(() {
        _errorMessage = "One or more uploaded files have invalid paths";
      });
      print('Validation failed in DocumentsUpload: Invalid file paths');
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final updatedData = Map<String, String>.from(riderData ?? {});
    updatedData.addAll({
      'id_document': _uploadedFiles['id']!.path!,
      'driving_license': _uploadedFiles['driving_license']!.path!,
      'insurance': _uploadedFiles['insurance']!.path!,
    });

    print('Updated riderData in DocumentsUpload: $updatedData');
    print('Navigating to /emergencycontacts with data: $updatedData');
    Navigator.pushNamed(
      context,
      '/emergencycontacts',
      arguments: updatedData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Add New Rider',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              '3. Identification & Documents',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            MyUploadField(
              title: 'ID',
              onFileSelected: (file) =>
                  setState(() => _uploadedFiles['id'] = file),
            ),
            const SizedBox(height: 20),
            MyUploadField(
              title: 'Driving License',
              onFileSelected: (file) =>
                  setState(() => _uploadedFiles['driving_license'] = file),
            ),
            const SizedBox(height: 20),
            MyUploadField(
              title: 'Insurance',
              onFileSelected: (file) =>
                  setState(() => _uploadedFiles['insurance'] = file),
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
