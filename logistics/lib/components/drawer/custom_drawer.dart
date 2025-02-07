import 'package:flutter/material.dart';
import 'package:logistcs/components/drawer/drawer_items.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0F0156), // Dark blue background
      child: Column(
        children: [
          // Profile Section
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0F0156)),
            accountName:
                Text("View  Profile", style: TextStyle(color: Colors.white)),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0F0156)),
            ),
          ),

          // Menu Section
          Expanded(
            child: Container(
              color: Colors.grey[300], // Light grey background
              child: Column(
                children: [
                  DrawerItem(
                    icon: Icons.home,
                    text: "Home",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(icon: Icons.settings, text: "Preference"),
                  DrawerItem(
                      icon: Icons.insert_drive_file,
                      text: "Top 5 best Regions"),
                  DrawerItem(icon: Icons.feedback, text: "FeedBacks"),
                  Spacer(), // Push logout button to bottom
                  DrawerItem(
                      icon: Icons.logout, text: "Log Out", isLogout: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
