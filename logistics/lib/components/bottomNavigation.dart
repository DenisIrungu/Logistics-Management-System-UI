import 'package:flutter/material.dart';
import 'package:logistcs/screens/deliveries/assigneddeliveries.dart';
import 'package:logistcs/screens/deliveries/deliverederdeliveries.dart';
import 'package:logistcs/screens/deliveries/pendingdeliveries.dart';

class DeliveryScreens extends StatefulWidget {
  const DeliveryScreens({super.key});

  @override
  State<DeliveryScreens> createState() => _DeliveryScreensState();
}

class _DeliveryScreensState extends State<DeliveryScreens> {
  int _selectedIndex = 0;

  final List<Widget> _screeens = [
    PendingDeliveries(),
    AssignedDeliveries(),
    DeliveredDeliveriesScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
