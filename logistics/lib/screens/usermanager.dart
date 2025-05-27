import 'package:flutter/material.dart';
import 'package:logistcs/components/mygrid.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'User Management',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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

            // First two grids (Rider & Pick-Up Agent)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MyGrid(
                      icon: Icons.motorcycle,
                      title: 'Rider',
                      color: const Color(0xFF0F0156),
                      onTap: () {
                        Navigator.pushNamed(context, '/ridermanagement');
                      },
                    ),
                    MyGrid(
                      icon: Icons.store,
                      title: 'Pick-Up Agent',
                      color: const Color(0xFF0F0156),
                    ),
                  ],
                ),
              ),
            ),

            // Third Grid (Customers) - Kept Centered
            Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: MyGrid(
                    icon: Icons.people,
                    title: 'Customers',
                    color: const Color(0xFF0F0156),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
