import 'package:flutter/material.dart';
import 'package:logistcs/components/mygrid.dart';
import 'package:logistcs/components/drawer/custom_drawer.dart';
import 'package:logistcs/components/priority.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  final List<Map<String, String>> priorities = [
    {
      'title': 'Delivery Delay in Nairobi',
      'description': '20 packages delayed due to weather'
    },
    {
      'title': 'System Update Required',
      'description': 'New security patch available'
    },
    {
      'title': 'Pending Approvals',
      'description': '5 requests need your attention'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor.clamp(1.0, 1.0);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: TextScaler.linear(textScaleFactor),
      ),
      child: Scaffold(
        backgroundColor:
            Theme.of(context).colorScheme.secondary.withOpacity(1.0),
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(1.0),
          title: const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Good Morning, Denis',
                    style: TextStyle(
                      color: const Color(0xFF0F0156),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ).copyWith(
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Priorities',
                        style: TextStyle(
                          color: Color(0xFF0F0156),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 120, // Ensures scrolling stays inside the box
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: priorities.length,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: PriorityCard(
                                title: priorities[index]['title']!,
                                description: priorities[index]['description']!,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MyGrid(
                        icon: Icons.person,
                        title: 'User Management',
                        color: const Color(0xFF0F0156),
                        onTap: () {
                          Navigator.pushNamed(context, '/usermanagement');
                        },
                      ),
                      MyGrid(
                        onTap: () {
                          Navigator.pushNamed(context, '/deliveryOverview');
                        },
                        icon: Icons.local_shipping,
                        title: 'Deliveries',
                        color: const Color(0xFF0F0156),
                      ),
                      MyGrid(
                        icon: Icons.report,
                        title: 'Reports',
                        color: const Color(0xFF0F0156),
                      ),
                      MyGrid(
                        icon: Icons.bar_chart,
                        title: 'Sales & Analytics',
                        color: const Color(0xFF0F0156),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
