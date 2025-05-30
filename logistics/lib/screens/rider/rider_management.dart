import 'package:flutter/material.dart';
import 'package:logistcs/blocs/admin/theme_bloc.dart';
import 'package:logistcs/components/mygrid.dart';
import 'package:logistcs/components/mycontainer.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/components/shared_rider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';
import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/services/api_client.dart';

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
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    print('RiderManagement: Initializing');
    _adminBloc = AdminBloc(
      adminRepository: DbAdminRepository(apiClient: ApiClient()),
      themeBloc: _tryGetThemeBloc(),
    );
    print('RiderManagement: Triggering initial FetchRiders');
    _adminBloc.add(const FetchRiders());
    print('RiderManagement: Adding listener to findRiderController');
    findRiderController.addListener(_filterRiders);
  }

  ThemeBloc? _tryGetThemeBloc() {
    try {
      return BlocProvider.of<ThemeBloc>(context, listen: false);
    } catch (e) {
      print('RiderManagement: ThemeBloc not found, proceeding without it: $e');
      return null;
    }
  }

  void _filterRiders() {
    if (!_adminBlocInitialized()) return;
    final query = findRiderController.text.trim();
    setState(() {
      _currentSkip = 0;
      print('RiderManagement: Filtering with query: $query');
      _adminBloc.add(FetchRiders(
        skip: _currentSkip,
        limit: _limit,
        searchQuery: query.isNotEmpty ? query : null,
      ));
    });
  }

  void _changePage(int delta) {
    if (!_adminBlocInitialized()) return;
    setState(() {
      _currentSkip += delta;
      print('RiderManagement: Changing page to skip: $_currentSkip');
      _adminBloc.add(FetchRiders(
        skip: _currentSkip,
        limit: _limit,
        searchQuery: findRiderController.text.trim().isNotEmpty
            ? findRiderController.text.trim()
            : null,
      ));
    });
  }

  bool _adminBlocInitialized() {
    try {
      _adminBloc.state;
      return true;
    } catch (e) {
      print('RiderManagement: _adminBloc not initialized yet: $e');
      return false;
    }
  }

  @override
  void dispose() {
    findRiderController.dispose();
    _adminBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('RiderManagement: Building widget with context: $context');
    return BlocProvider.value(
      value: _adminBloc,
      child: Scaffold(
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
            child: BlocBuilder<AdminBloc, AdminBlocState>(
              builder: (context, state) {
                print('RiderManagement: BlocBuilder state: $state');
                if (state.ridersState is RidersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.ridersState is RidersSuccess) {
                  final ridersState = state.ridersState as RidersSuccess;
                  final riders = ridersState.riders;
                  _totalRiders = ridersState.total;
                  _currentSkip = ridersState.skip;
                  print(
                      'RiderManagement: Rendering ${riders.length} riders, total: $_totalRiders');

                  return Column(
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
                      Expanded(
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
                                  print(
                                      'RiderManagement: Rendering rider: ${rider.name}');
                                  return Card(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
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
                                        style: const TextStyle(
                                            color: Color(0xFF0F0156)),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _currentSkip == 0
                                ? null
                                : () => _changePage(-ridersState.limit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F0156),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            'Page ${(_currentSkip / ridersState.limit) + 1}',
                            style: const TextStyle(color: Color(0xFF0F0156)),
                          ),
                          ElevatedButton(
                            onPressed: (_currentSkip + ridersState.limit) >=
                                    _totalRiders
                                ? null
                                : () => _changePage(ridersState.limit),
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
                            MyGrid(
                                title: 'Active',
                                color: const Color(0xFF0F0156)),
                            MyGrid(
                                title: 'Inactive',
                                color: const Color(0xFF0F0156)),
                            MyGrid(
                                title: 'Feedbacks',
                                color: const Color(0xFF0F0156)),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state.ridersState is RidersFailure) {
                  final failure = state.ridersState as RidersFailure;
                  return Center(
                    child: Text(
                      'Error: ${failure.error}',
                      style: const TextStyle(color: Color(0xFF0F0156)),
                    ),
                  );
                }
                return const Center(
                    child: Text(
                  'Initial state or no data, triggering fetch...',
                  style: TextStyle(color: Color(0xFF0F0156)),
                ));
              },
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
      ),
    );
  }
}
