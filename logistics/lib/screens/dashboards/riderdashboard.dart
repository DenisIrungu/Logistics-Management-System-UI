import 'package:flutter/material.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: Text(
          'Rider Dashboard',
          style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF)),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'Welcome to rider dashboard',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
