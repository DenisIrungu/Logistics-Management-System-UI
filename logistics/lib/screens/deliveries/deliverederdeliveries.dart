import 'package:flutter/material.dart';
import 'package:logistcs/components/mytextfield.dart';

class DeliveredDeliveriesScreen extends StatefulWidget {
  const DeliveredDeliveriesScreen({super.key});

  @override
  State<DeliveredDeliveriesScreen> createState() =>
      _DeliveredDeliveriesScreenState();
}

class _DeliveredDeliveriesScreenState extends State<DeliveredDeliveriesScreen> {
  final TextEditingController _searchDeliveredDeliveries = TextEditingController();
  int _selectedItem = 2;
  bool isExpanded = false;
  final List<Map<String, String>> deliveries = [
    {
      'id': '001',
      'address': '123 Street, City',
      'customer': 'John Doe',
      'assignedTo': 'Rider A',
      'destination': 'Warehouse B',
      'dateTime': '2025-03-06 10:00 AM',
    },
    {
      'id': '002',
      'address': '456 Avenue, City',
      'customer': 'Jane Smith',
      'assignedTo': 'Rider B',
      'destination': 'Warehouse C',
      'dateTime': '2025-03-06 11:30 AM',
    },
    {
      'id': '003',
      'address': '789 Road, City',
      'customer': 'Alice Johnson',
      'assignedTo': 'Rider C',
      'destination': 'Warehouse A',
      'dateTime': '2025-03-06 01:15 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Delivered Deliveries'),
          backgroundColor: Color(0xFF0F0156),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyTextField(
                controller: _searchDeliveredDeliveries,
                hintText: ' Search Delivery',
                hintTextColor: Color(0xFF0F0156),
                obscureText: false,
                prefixIcon: Icon(Icons.search),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: deliveries.length,
                  itemBuilder: (context, index) {
                    final delivery = deliveries[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.orange, width: 1),
                      ),
                      color: Color(0xFF0F0156),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          'DeliveryID: ${delivery['id']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Address: ${delivery['address']}'),
                            Text('Customer Name: ${delivery['customer']}'),
                            Text('Assigned to: ${delivery['assignedTo']}'),
                            Text('Destination: ${delivery['destination']}'),
                            Text('Date & Time: ${delivery['dateTime']}'),
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            duration: Duration(milliseconds: 300),
            height: isExpanded ? 120 : 60,
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF0F0156), Color(0xFF1B0A91)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedItemColor: Color(0xFFFF9500),
                unselectedItemColor: Colors.white,
                elevation: 0,
                currentIndex: _selectedItem,
                onTap: (index) {
                  setState(() {
                    _selectedItem = index;
                  });
                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, '/pendingDeliveries');
                      break;
                    case 1:
                      Navigator.pushNamed(context, '/assignedDeliveries');
                      break;
                    case 2:
                      Navigator.pushNamed(context, 'delivereddeliveries');
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.access_time), label: 'Pending'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.local_shipping), label: 'Assigned'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.inventory), label: 'Delivered')
                ]),
          ),
        )));
  }
}
