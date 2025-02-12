import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logistcs/components/dropdownTextfield.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mycontainer.dart';
import 'package:logistcs/components/mytextfield.dart';

class RiderTracking extends StatefulWidget {
  const RiderTracking({super.key});

  @override
  State<RiderTracking> createState() => _RiderTrackingState();
}

class _RiderTrackingState extends State<RiderTracking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _riderSearchController = TextEditingController();
  final List<String> riders = [
    "Aaron",
    "Abigail",
    "Adam",
    "Adrian",
    "Aiden",
    "Alex",
    "Alice",
    "Amanda",
    "Amber",
    "Amelia",
    "Andre",
    "Angela",
    "Anthony",
    "Ariana",
    "Ashley",
    "Austin",
    "Ava",
    "Ben",
    "Benjamin",
    "Bethany",
    "Blake",
    "Brandon",
    "Brayden",
    "Brian",
    "Brianna",
    "Brody",
    "Brooklyn",
    "Caleb",
    "Cameron",
    "Carlos",
    "Carter",
    "Charles",
    "Charlotte",
    "Chase",
    "Chloe",
    "Christian",
    "Christopher",
    "Claire",
    "Connor",
    "Cooper",
    "Daniel",
    "David",
    "Delilah",
    "Dominic",
    "Dylan",
    "Eleanor",
    "Elijah",
    "Elizabeth",
    "Ella",
    "Emily",
    "Emma",
    "Ethan",
    "Evan",
    "Everly",
    "Ezekiel",
    "Faith",
    "Gabriel",
    "Gavin",
    "Genesis",
    "Grace",
    "Grayson",
    "Hailey",
    "Hannah",
    "Harper",
    "Hazel",
    "Henry",
    "Hudson",
    "Hunter",
    "Isaac",
    "Isabella",
    "Isabelle",
    "Jack",
    "Jackson",
    "Jacob",
    "James",
    "Jasmine",
    "Jason",
    "Jaxon",
    "Jayden",
    "Jeremiah",
    "Jessica",
    "Jocelyn",
    "John",
    "Jonathan",
    "Jordan",
    "Joseph",
    "Joshua",
    "Josiah",
    "Julia",
    "Julian",
    "Kai",
    "Kayla",
    "Kennedy",
    "Kevin",
    "Kimberly",
    "Landon",
    "Lauren",
    "Layla",
    "Leo",
    "Levi"
  ];
  bool active = false;
  bool onTask = false;
  bool inactive = false;
  bool specialDeliveries = false;
  bool standardDeliveries = false;
  bool expressDeliveries = false;
  bool doorStepDeliveries = false;
  bool customDeliveries = false;

  final List<String> availableRegions = [
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Uasin Gishu',
    'Kiambu',
    'Machakos',
    'Nyeri',
    'Kilifi',
    'Kakamega',
    'Meru',
    'Turkana',
    'Garissa',
    'Kitui',
    'Kajiado',
    'Bungoma',
    'Kwale',
    'Laikipia',
    'Siaya',
    'Trans Nzoia'
  ];
  void _clearFilters() {
    setState(() {
      active = false;
      onTask = false;
      inactive = false;
      specialDeliveries = false;
      standardDeliveries = false;
      expressDeliveries = false;
      doorStepDeliveries = false;
      customDeliveries = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Track Rider',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        backgroundColor: (Color(0xFFDFDEE8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xFF0F0156)),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Filter Rider By:',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Status: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF0F0156)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CheckboxListTile(
                        title: Text(
                          'Active',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: active,
                        onChanged: (val) => setState(() => active = val!)),
                    CheckboxListTile(
                        title: Text('OnTask',
                            style: TextStyle(color: Color(0xFF0F0156))),
                        value: onTask,
                        onChanged: (val) => setState(() => onTask = val!)),
                    CheckboxListTile(
                        title: Text('Inactive',
                            style: TextStyle(color: Color(0xFF0F0156))),
                        value: onTask,
                        onChanged: (val) => setState(() => inactive = val!)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Regions:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F0156)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyDropDownTextField(
                      labelText: 'Select Region',
                      borderColor: Color(0xFFFF9500),
                      borderWidth: 1,
                      options: availableRegions,
                      initialValue: 'Bungoma',
                      onChanged: (value) {
                        if (kDebugMode) {
                          print('Selected county: $value');
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Task Type',
                        style: TextStyle(
                            color: Color(0xFF0F0156),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    CheckboxListTile(
                        title: Text(
                          'Special Deliveries',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: specialDeliveries,
                        onChanged: (val) =>
                            setState(() => specialDeliveries = val!)),
                    CheckboxListTile(
                        title: Text(
                          'Standard Deliveries',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: standardDeliveries,
                        onChanged: (val) =>
                            setState(() => standardDeliveries = val!)),
                    CheckboxListTile(
                        title: Text(
                          'Express Deliveries',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: expressDeliveries,
                        onChanged: (val) =>
                            setState(() => expressDeliveries = val!)),
                    CheckboxListTile(
                        title: Text(
                          'DoorStep Deliveries',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: doorStepDeliveries,
                        onChanged: (val) =>
                            setState(() => doorStepDeliveries = val!)),
                    CheckboxListTile(
                        title: Text(
                          'Custom Deliveries',
                          style: TextStyle(color: Color(0xFF0F0156)),
                        ),
                        value: customDeliveries,
                        onChanged: (val) =>
                            setState(() => customDeliveries = val!)),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                            text: 'Apply',
                            onPress: () {},
                            color: Color(0xFF0F0156)),
                        MyButton(
                            text: 'Cancel',
                            onPress: _clearFilters,
                            color: Color(0xFF0F0156))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _riderSearchController,
                    hintText: 'Name or ID or Phone Number',
                    obscureText: false,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFFF9500)),
                  ),
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.tune),
                        iconSize: 30,
                        color: Colors.black,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(text: 'Search', onPress: () {}, color: Color(0xFF0F0156)),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFFF9500),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: ListView.builder(
                  itemCount: riders.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyContainer(
                        text: riders[index],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
