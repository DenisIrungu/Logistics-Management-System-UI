import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/piedata.dart';
import 'package:logistcs/screens/deliveries/piechartindicator.dart';

class DeliveriesOverview extends StatefulWidget {
  const DeliveriesOverview({super.key});

  @override
  _DeliveriesOverviewState createState() => _DeliveriesOverviewState();
}

class _DeliveriesOverviewState extends State<DeliveriesOverview> {
  final TextEditingController searchDeliveryController =
      TextEditingController();
  int? touchIndex;
  int _selectedIndex = 0;

  List<PieChartSectionData> getSections() {
    return PieData.data
        .asMap()
        .map<int, PieChartSectionData>(
          (index, data) => MapEntry(
            index,
            PieChartSectionData(
              color: data.color,
              value: data.percent,
              title: '${data.percent}%',
              radius: index == touchIndex ? 70 : 60,
              titleStyle: TextStyle(
                fontSize: index == touchIndex ? 25 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Deliveries Overview',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: MyTextField(
                  controller: searchDeliveryController,
                  hintText: 'Search Delivery ID',
                  prefixIcon: const Icon(Icons.search),
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  width: 370,
                  height: 175,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Total Deliveries:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F0156),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "3000",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F0156),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 370,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status Breakdown",
                      style: TextStyle(
                        color: Color(0xFF0F0156),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const PieChartIndicator(),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          sections: getSections(),
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                touchIndex = pieTouchResponse
                                    ?.touchedSection?.touchedSectionIndex;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
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
                Navigator.pushNamed(context, '/pendingDeliveries');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_bottom), label: 'Processing'),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), label: 'Billing')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF0F0156),
          onPressed: () {},
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F0156), Color(0xFF1B0A91)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "lib/images/logo.jpeg",
                  fit: BoxFit.fill,
                )),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
