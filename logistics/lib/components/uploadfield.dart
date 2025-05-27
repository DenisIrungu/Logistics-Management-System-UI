import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class MyUploadField extends StatefulWidget {
  final String title;
  final Function(PlatformFile?) onFileSelected;

  const MyUploadField(
      {super.key, required this.title, required this.onFileSelected});

  @override
  _MyUploadFieldState createState() => _MyUploadFieldState();
}

class _MyUploadFieldState extends State<MyUploadField> {
  PlatformFile? _selectedFile;
  String? _errorMessage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _errorMessage = null;
      });
      widget.onFileSelected(_selectedFile); // Callback to parent
    } else {
      setState(() {
        _errorMessage = "Please select a PDF file";
      });
      widget.onFileSelected(null); // Notify parent of failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF0F0156),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _selectedFile != null
                        ? _selectedFile!.name
                        : 'Upload ${widget.title}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _pickFile,
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F0156),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
