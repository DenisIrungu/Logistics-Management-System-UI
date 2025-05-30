import 'package:flutter/material.dart';
import 'package:logistcs/components/mygrid.dart';
import 'package:logistcs/components/mycontainer.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/shared_rider.dart';

class RiderManagement extends StatefulWidget {
  const RiderManagement({super.key});

  @override
  State<RiderManagement> createState() => _RiderManagementState();
}

class _RiderManagementState extends State<RiderManagement> {
  final TextEditingController findRiderController = TextEditingController();
  bool isExpanded = false;
  int _selectedIndex = 0;
  int _currentSkip = 0;
  final int _limit = 10;
  int _totalRiders = 0;

  @override
  void initState() {
    super.initState();
    // Placeholder for initial data fetch (no BLoC)
    findRiderController.addListener(_filterRiders);
  }

  void _filterRiders() {
    final query = findRiderController.text.trim();
    setState(() {
      _currentSkip = 0; // Reset pagination on search
      // Placeholder for filtering logic (to be replaced with API call or mock data)
    });
  }

  @override
  void dispose() {
    findRiderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for riders (replace with actual data source later)
    final riders = [
      Rider(
        id: 1,
        name: "John Doe",
        email: "john@example.com",
        phoneNumber: "123-456-7890",
        bikeNumber: "B123",
        bikeModel: "Honda",
        bikeColor: "Red",
        license: "L12345",
        idDocument: "ID123",
        drivingLicense: "DL123",
        insurance: "INS123",
        emergencyContactName: "Jane Doe",
        emergencyContactPhone: "098-765-4321",
        emergencyContactRelationship: "Spouse",
        createdBy: 1,
        status: "active",
        createdAt: DateTime.now(),
      ),
      // Add more mock riders as needed
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Rider Management',
          style: TextStyle(color: Colors.white),
        ),
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
              const SizedBox(height: 10),
              // Display riders list with pagination
              SizedBox(
                height: 150, // Fixed height for the search results list
                child: riders.isEmpty
                    ? const Center(
                        child: Text(
                          'No riders found',
                          style: TextStyle(
                            color: Color(0xFF0F0156),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: riders.length,
                        itemBuilder: (context, index) {
                          final rider = riders[index];
                          return Card(
                            color: Theme.of(context).colorScheme.secondary,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                rider.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F0156),
                                ),
                              ),
                              subtitle: Text(
                                'ID: ${rider.id}',
                                style:
                                    const TextStyle(color: Color(0xFF0F0156)),
                              ),
                              onTap: () {
                                print(
                                    'Navigating to /updaterider with Rider: ${rider.name}');
                                Navigator.pushNamed(
                                  context,
                                  '/updaterider',
                                  arguments: rider,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              // Pagination controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentSkip == 0
                        ? null
                        : () {
                            setState(() {
                              _currentSkip -= _limit;
                              // Placeholder for pagination logic
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F0156),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    'Page ${_currentSkip ~/ _limit + 1}',
                    style: const TextStyle(color: Color(0xFF0F0156)),
                  ),
                  ElevatedButton(
                    onPressed: (_currentSkip + _limit) >= _totalRiders
                        ? null
                        : () {
                            setState(() {
                              _currentSkip += _limit;
                              // Placeholder for pagination logic
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F0156),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
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
                      text: 'Total Riders: $_totalRiders',
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
                    MyGrid(
                      title: 'Track',
                      color: const Color(0xFF0F0156),
                      onTap: () {
                        Navigator.pushNamed(context, '/ridertracking');
                      },
                    ),
                    MyGrid(title: 'Active', color: const Color(0xFF0F0156)),
                    MyGrid(title: 'Inactive', color: const Color(0xFF0F0156)),
                    MyGrid(title: 'Feedbacks', color: const Color(0xFF0F0156)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F0156), Color(0xFF1B0A91)],
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
                  case 1:
                    // Placeholder for delete action (no BLoC)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Delete functionality placeholder')),
                    );
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_add), label: 'ADD'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.delete), label: 'DELETE'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
