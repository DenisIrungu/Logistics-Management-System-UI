import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';

class FeedBacks extends StatefulWidget {
  const FeedBacks({super.key});

  @override
  State<FeedBacks> createState() => _FeedBacksState();
}

class _FeedBacksState extends State<FeedBacks> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'date';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    // Trigger the FetchFeedbacks event when the screen loads with default sorting
    _applyFilters();
  }

  void _applyFilters() {
    context.read<AdminBloc>().add(FetchFeedbacks(
          region:
              _searchController.text.isNotEmpty ? _searchController.text : null,
          dateStart: _startDate?.toIso8601String().split('T').first,
          dateEnd: _endDate?.toIso8601String().split('T').first,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
        ));
  }

  void _showDatePicker({bool isStartDate = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _applyFilters();
      });
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by Date (Newest First)'),
              onTap: () {
                setState(() {
                  _sortBy = 'date';
                  _sortOrder = 'desc';
                });
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Date (Oldest First)'),
              onTap: () {
                setState(() {
                  _sortBy = 'date';
                  _sortOrder = 'asc';
                });
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Rating (High to Low)'),
              onTap: () {
                setState(() {
                  _sortBy = 'rating';
                  _sortOrder = 'desc';
                });
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sort by Rating (Low to High)'),
              onTap: () {
                setState(() {
                  _sortBy = 'rating';
                  _sortOrder = 'asc';
                });
                _applyFilters();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Users Feedbacks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: _showSortOptions,
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              // Add download functionality later
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar (Full Width)
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by region (e.g., "w" for Westlands)...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFFF9500)),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                _applyFilters();
              },
            ),
            const SizedBox(height: 8),
            // Date Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _showDatePicker(isStartDate: true),
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    _startDate != null
                        ? DateFormat('MMM d, yyyy').format(_startDate!)
                        : 'Start Date',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showDatePicker(isStartDate: false),
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    _endDate != null
                        ? DateFormat('MMM d, yyyy').format(_endDate!)
                        : 'End Date',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Feedback List
            BlocBuilder<AdminBloc, AdminBlocState>(
              buildWhen: (previous, current) =>
                  previous.feedbackState != current.feedbackState,
              builder: (context, state) {
                print('BlocBuilder: feedbackState = ${state.feedbackState}');

                if (state.feedbackState is FeedbackLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.feedbackState is FeedbackFailure) {
                  return Center(
                    child: Text(
                      'Error: ${(state.feedbackState as FeedbackFailure).error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (state.feedbackState is FeedbackSuccess) {
                  final feedbacks =
                      (state.feedbackState as FeedbackSuccess).feedbacks;
                  if (feedbacks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No feedbacks available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedbacks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final feedback = feedbacks[index];
                      return Card(
                        elevation: 2,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xFFFF9500), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ID and Submitter
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'ID: ${feedback.id}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${feedback.userType} #${feedback.userId}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // User Type and Region
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'User: ${feedback.userType}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Region: ${feedback.region}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Message
                              Text(
                                feedback.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Category and Status
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      feedback.category,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor:
                                        feedback.category == 'Negative'
                                            ? Colors.redAccent
                                            : Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      feedback.status,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: feedback.status == 'New'
                                        ? Colors.redAccent
                                        : Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Date and Rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Date: ${DateFormat('MMM d, yyyy').format(feedback.timestamp)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Rating: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            5,
                                            (starIndex) => Icon(
                                              starIndex < feedback.rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                // Fallback for unexpected state
                return const Center(
                  child: Text(
                    'Unexpected state. Please try again.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
