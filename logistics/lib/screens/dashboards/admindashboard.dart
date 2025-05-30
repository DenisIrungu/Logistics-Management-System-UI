import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';
import 'package:logistcs/components/mygrid.dart';
import 'package:logistcs/components/drawer/custom_drawer.dart';
import 'package:logistcs/components/priority.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
  bool _hasFetchedData = false;

  // Function to determine the greeting based on the time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_hasFetchedData) {
      print('Admindashboard: Triggering data fetch events');
      context.read<AdminBloc>().add(FetchAdminProfile());
      context.read<AdminBloc>().add(FetchPriorities());
      context.read<AdminBloc>().add(FetchNotificationsCount());
      _hasFetchedData = true;
    }
  }

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
          iconTheme: IconThemeData(color: Colors.white),
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
          actions: [
            BlocBuilder<AdminBloc, AdminBlocState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        // Handle notifications tap (to be implemented)
                      },
                    ),
                    if (state.notificationsState is NotificationsSuccess &&
                        (state.notificationsState as NotificationsSuccess)
                                .count >
                            0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${(state.notificationsState as NotificationsSuccess).count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
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
                  child: BlocBuilder<AdminBloc, AdminBlocState>(
                    builder: (context, state) {
                      final greeting =
                          _getGreeting(); // Use the dynamic greeting
                      if (state.profileState is ProfileLoading) {
                        return Text(
                          '$greeting, Loading...',
                          style: TextStyle(
                            color: const Color(0xFF0F0156),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ).copyWith(
                            letterSpacing: 0.5,
                          ),
                        );
                      } else if (state.profileState is ProfileSuccess) {
                        final profile =
                            (state.profileState as ProfileSuccess).adminProfile;
                        return Text(
                          '$greeting, ${profile.name}',
                          style: TextStyle(
                            color: const Color(0xFF0F0156),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ).copyWith(
                            letterSpacing: 0.5,
                          ),
                        );
                      } else if (state.profileState is ProfileFailure) {
                        return Text(
                          '$greeting, Admin (Error)',
                          style: TextStyle(
                            color: const Color(0xFF0F0156),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ).copyWith(
                            letterSpacing: 0.5,
                          ),
                        );
                      }
                      return Text(
                        '$greeting, Admin',
                        style: TextStyle(
                          color: const Color(0xFF0F0156),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ).copyWith(
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
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
                      const Text(
                        'Priorities',
                        style: TextStyle(
                          color: Color(0xFF0F0156),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<AdminBloc, AdminBlocState>(
                        builder: (context, state) {
                          if (state.prioritiesState is PrioritiesLoading) {
                            return const SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state.prioritiesState
                              is PrioritiesSuccess) {
                            final priorities =
                                (state.prioritiesState as PrioritiesSuccess)
                                    .priorities;
                            if (priorities.isEmpty) {
                              return const SizedBox(
                                height: 120,
                                child:
                                    Center(child: Text('No priorities found')),
                              );
                            }
                            return SizedBox(
                              height: 120,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: priorities.length,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                itemBuilder: (context, index) {
                                  final issue = priorities[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: PriorityCard(
                                      title: issue.title,
                                      description: issue.description,
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state.prioritiesState
                              is PrioritiesFailure) {
                            return const SizedBox(
                              height: 120,
                              child: Center(
                                  child: Text('Error loading priorities')),
                            );
                          }
                          return const SizedBox(
                            height: 120,
                            child: Center(child: Text('No priorities found')),
                          );
                        },
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
