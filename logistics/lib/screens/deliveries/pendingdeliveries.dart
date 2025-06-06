import 'package:flutter/material.dart';
import 'package:logistcs/components/mytextfield.dart';

class PendingDeliveries extends StatefulWidget {
  const PendingDeliveries({super.key});

  @override
  _PendingDeliveriesState createState() => _PendingDeliveriesState();
}

class _PendingDeliveriesState extends State<PendingDeliveries> {
  TextEditingController searchPendingDeliveryController =
      TextEditingController();
  String? selectedLocation;
  bool isExpanded = false;
  String? selectedRider;
  int _selectedItem = 0;
  List<String> destinations = ['Kasarani', 'Santon', 'K-West'];
  List<String> riders = ['Ken', 'Akumu', 'Nene'];
  List<String> isChecked = []; // Tracks the DeliveryIDs of checked deliveries
  List<Map<String, String>> deliveries = [
    {
      "DeliveryID": "12345",
      "Customer": "John Doe",
      "Address": "123 Main St",
      "Destination": "Kasarani"
    },
    {
      "DeliveryID": "67890",
      "Customer": "Jane Smith",
      "Address": "456 Elm St",
      "Destination": "Santon"
    },
    {
      "DeliveryID": "11111",
      "Customer": "Alice Johnson",
      "Address": "789 Pine Rd",
      "Destination": "K-West"
    },
    {
      "DeliveryID": "22222",
      "Customer": "Bob Wilson",
      "Address": "101 Oak Ave",
      "Destination": "Kasarani"
    },
    // Added more entries to simulate dynamic data
  ];

  @override
  void dispose() {
    searchPendingDeliveryController.dispose();
    super.dispose();
  }

  void toggleCheck(String deliveryId) {
    setState(() {
      if (isChecked.contains(deliveryId)) {
        isChecked.remove(deliveryId); // Uncheck (remove from list)
      } else {
        isChecked.add(deliveryId); // Check (add to list)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/deliveryOverview');
            },
            icon: Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        title: const Text(
          'Pending Deliveries',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar with Dropdown for Destination
            MyTextField(
              controller: searchPendingDeliveryController,
              hintText: 'Destination',
              hintTextColor: Color(0xFF0F0156),
              labelTextColor: Color(0xFF0F0156),
              obscureText: false,
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF0F0156),
              ),
              suffixIcon: DropdownButton<String>(
                value: selectedLocation,
                items: destinations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                    searchPendingDeliveryController.text = newValue ?? '';
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.orange,
                  size: 40,
                ),
                underline: SizedBox(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value?.isNotEmpty ?? false ? value : null;
                });
                return null;
              },
            ),
            SizedBox(height: 16),
            // List of Pending Deliveries (Now the Only Scrollable Element with Checkboxes)
            Expanded(
              child: ListView.builder(
                physics:
                    ClampingScrollPhysics(), // Makes the ListView scrollable
                itemCount: deliveries.length,
                itemBuilder: (context, index) {
                  final delivery = deliveries[index];
                  if (selectedLocation != null &&
                      delivery["Destination"]!.toLowerCase() !=
                          selectedLocation!.toLowerCase()) {
                    return SizedBox.shrink();
                  }
                  final deliveryId = delivery["DeliveryID"]!;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    child: SizedBox(
                      height: 130,
                      child: ListTile(
                        title: Text('DeliveryID: ${delivery["DeliveryID"]}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Address: ${delivery["Address"]}'),
                            Text('Customer Name: ${delivery["Customer"]}'),
                            Text('Destination: ${delivery["Destination"]}'),
                          ],
                        ),
                        trailing: Checkbox(
                          value: isChecked.contains(deliveryId),
                          onChanged: (bool? value) {
                            toggleCheck(deliveryId);
                          },
                          activeColor: Colors.orange,
                          checkColor: Colors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Rider Selection Dropdown (Updated with Orange Borders)
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Rider',
                hintText: 'Select Rider',
                hintStyle: TextStyle(
                    color: Color(0xFF0F0156), fontWeight: FontWeight.bold),
                labelStyle: TextStyle(
                    color: Color(0xFF0F0156), fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.orange, // Orange border when not focused
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.orange, // Orange border when focused
                    width: 2.0,
                  ),
                ),
              ),
              value: selectedRider,
              items: riders.map((rider) {
                return DropdownMenuItem<String>(
                  value: rider,
                  child: Text(rider),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRider = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Assign Button (Updated to work with checked deliveries)
            ElevatedButton(
              onPressed: () {
                if (selectedRider != null && isChecked.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Deliveries assigned to $selectedRider: ${isChecked.join(", ")}')),
                  );
                  setState(() {
                    isChecked
                        .clear(); // Optionally clear checked items after assignment
                  });
                } else if (selectedRider == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a rider')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please select at least one delivery')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0F0156),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text('ASSIGN', style: TextStyle(color: Colors.white)),
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
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
      )),
    );
  }
}
