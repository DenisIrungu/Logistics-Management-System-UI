import 'package:flutter/material.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/uploadfield.dart';

class DocumentsUpload extends StatefulWidget {
  const DocumentsUpload({super.key});

  @override
  State<DocumentsUpload> createState() => _DocumentsUploadState();
}

class _DocumentsUploadState extends State<DocumentsUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
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
            SizedBox(
              height: 20,
            ),
            Text(
              '3. Identification & Documents',
              style: TextStyle(
                  color: Color(0xFF0F0156),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            MyUploadField(
              title: 'ID',
            ),
            SizedBox(
              height: 20,
            ),
            MyUploadField(title: 'Driving License'),
            SizedBox(
              height: 20,
            ),
            MyUploadField(title: 'Insurance'),
            SizedBox(
              height: 20,
            ),
            MyButton(
                text: 'Continue',
                onPress: () {
                  print('Button pressed!');
                  Navigator.pushNamed(context, '/emergencycontacts');
                },
                color: Color(0xFF0F0156))
          ],
        ),
      ),
    );
  }
}
