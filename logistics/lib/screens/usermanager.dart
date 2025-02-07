import 'package:flutter/material.dart';
import 'package:logistcs/components/admin_dashboard/mygrid.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.manage_accounts,
            color: Color(0xFF0F0156),
            size: 70,
          ),
          const SizedBox(height: 10),
          const Text(
            'User Management',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F0156),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please Add, Update or Remove,',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F0156),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F0156),
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  MyGrid(
                      icon: Icons.motorcycle,
                      title: 'Rider',
                      color: Color(0xFF0F0156)),
                  MyGrid(
                      icon: Icons.store,
                      title: 'Pick-Up Agent',
                      color: Color(0xFF0F0156)),
                  MyGrid(
                      icon: Icons.people,
                      title: 'Customer',
                      color: Color(0xFF0F0156)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
