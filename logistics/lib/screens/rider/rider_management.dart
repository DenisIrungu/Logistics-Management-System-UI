import 'package:flutter/material.dart';
import 'package:logistcs/components/mygrid.dart';
import 'package:logistcs/components/mycontainer.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderManagement extends StatefulWidget {
  const RiderManagement({super.key});

  @override
  State<RiderManagement> createState() => _RiderManagementState();
}

class _RiderManagementState extends State<RiderManagement> {
  final TextEditingController findRiderController = TextEditingController();
  bool isExpanded = false;
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
                    children: [
                      //rider tracking
                      MyGrid(
                        title: 'Track',
                        color: Color(0xFF0F0156),
                        onTap: () {
                          Navigator.pushNamed(context, '/ridertracking');
                        },
                      ),
                      //Active riders
                      MyGrid(title: 'Active', color: Color(0xFF0F0156)),
                      //Inactive riders
                      MyGrid(title: 'Inactive', color: Color(0xFF0F0156)),
                      //FeeedBacks
                      MyGrid(title: 'Feedbacks', color: Color(0xFF0F0156)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Animated Bottom Navigation Bar
        bottomNavigationBar: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? 120 : 60,
              curve: Curves.easeInOut,
              //padding: const EdgeInsets.z,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F0156),
                    Color(0xFF1B0A91)
                  ], // Gradient effect
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
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, '/riderbasicinfor');
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_add), label: 'ADD'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.update), label: 'UPDATE'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.delete), label: 'DELETE'),
                ],
              ),
            ),
          ),
        ));
  }
}
