import 'package:flutter/material.dart';
import 'package:logistcs/components/admin_dashboard/mygrid.dart';
import 'package:logistcs/components/mycontainer.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderManagement extends StatefulWidget {
  const RiderManagement({super.key});

  @override
  State<RiderManagement> createState() => _RiderManagementState();
}

class _RiderManagementState extends State<RiderManagement> {
  final TextEditingController findRiderController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Rider Management'),
        elevation: 0,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              MyTextField(
                controller: findRiderController,
                labelText: 'Find Rider',
                hintText: 'Find Rider',
                obscureText: false,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF0F0156),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 10,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 250,
                    child: MyContainer(
                      text: 'Total Riders',
                      color: const Color(0xFF0F0156),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    MyGrid(title: 'Track', color: Color(0xFF0F0156)),
                    MyGrid(title: 'Active', color: Color(0xFF0F0156)),
                    MyGrid(title: 'Inactive', color: Color(0xFF0F0156)),
                    MyGrid(title: 'Feedbacks', color: Color(0xFF0F0156)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Animated Bottom Navigation Bar
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F0156), Color(0xFF1B0A91)], // Gradient effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFFF9500),
          unselectedItemColor: Colors.white,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'ADD'),
            BottomNavigationBarItem(icon: Icon(Icons.update), label: 'UPDATE'),
            BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'DELETE'),
          ],
        ),
      ),
    );
  }
}
