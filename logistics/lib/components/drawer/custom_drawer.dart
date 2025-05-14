import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';
import '../../services/api_client.dart';
import 'drawer_items.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F0156),
      child: Column(
        children: [
          // Profile Section
          BlocBuilder<AdminBloc, AdminBlocState>(
            builder: (context, state) {
              String? profilePicture;
              String name = 'User';

              // Check the profileState within AdminBlocState
              if (state.profileState is ProfileSuccess) {
                final profileSuccess = state.profileState as ProfileSuccess;
                profilePicture = profileSuccess.adminProfile.profilePicture;
                name = profileSuccess.adminProfile.name ?? 'User';
              } else if (state.profileState is ProfileLoading) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profilescreen');
                },
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF0F0156)),
                  accountName: const Text(
                    "View Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    name,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: profilePicture != null
                        ? NetworkImage(
                            '${ApiClient.baseUrl}$profilePicture?t=${DateTime.now().millisecondsSinceEpoch}',
                          )
                        : null,
                    child: profilePicture == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF0F0156),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),

          // Menu Section
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  DrawerItem(
                    icon: Icons.home,
                    text: "Home",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    icon: Icons.settings,
                    text: "Preference",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/preferencescreen');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.insert_drive_file,
                    text: "Top 5 best Regions",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/top5bestregions');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.feedback,
                    text: "FeedBacks",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/feedbacks');
                    },
                  ),
                  const Spacer(),
                  DrawerItem(
                    icon: Icons.logout,
                    text: "Log Out",
                    isLogout: true,
                    onTap: () async {
                      await ApiClient().clearSessionCookie();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/signinscreen');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
