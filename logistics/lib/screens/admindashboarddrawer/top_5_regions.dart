import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';

class Top5Regions extends StatefulWidget {
  const Top5Regions({super.key});

  @override
  State<Top5Regions> createState() => _Top5RegionsState();
}

class _Top5RegionsState extends State<Top5Regions> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add( FetchTopRegions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Top 5 Best Regions',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'These are the best performing regions:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<AdminBloc, AdminBlocState>(
                builder: (context, state) {
                  if (state.topRegionsState is TopRegionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.topRegionsState is TopRegionsSuccess) {
                    final regions = (state.topRegionsState as TopRegionsSuccess).regions;
                    if (regions.isEmpty) {
                      return const Center(
                        child: Text(
                          'No regions available',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: regions.length,
                      itemBuilder: (context, index) {
                        final region = regions[index];
                        return SizedBox(
                          height: 140,
                          child: Card(
                            color: Theme.of(context).colorScheme.surface,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: Color(0xFFFF9500), width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Region: ${region.region}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Success Rate: ${(region.onTimeDeliveryRate * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    );
                  } else if (state.topRegionsState is TopRegionsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load regions: ${(state.topRegionsState as TopRegionsFailure).error}',
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              context.read<AdminBloc>().add( FetchTopRegions());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Something went wrong', style: TextStyle(color: Colors.white)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}