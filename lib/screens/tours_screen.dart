import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../services/tour_service.dart';
import '../widgets/tour_card.dart';
import '../widgets/category_filter_chip.dart';
import 'tour_details_screen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  List<Tour> tours = [];
  bool isLoading = true;
  String selectedFilter = 'All Tours';
  final filters = [
    'All Tours',
    'Adventure',
    'Cultural',
    'Nature',
    'Beach',
    'Wildlife',
  ];

  @override
  void initState() {
    super.initState();
    fetchTours();
  }

  Future<void> fetchTours() async {
    setState(() => isLoading = true);

    try {
      final fetchedTours = await TourService.fetchTours();
      setState(() {
        tours = fetchedTours;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tours: $e');
      setState(() {
        tours = [];
        isLoading = false;
      });
    }
  }

  void _filterTours(String filter) {
    setState(() => selectedFilter = filter);
  }

  List<Tour> get filteredTours {
    if (selectedFilter == 'All Tours') {
      return tours;
    } else {
      return tours.where((tour) => tour.category == selectedFilter).toList();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Tours',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filters.map((filter) {
                  return CategoryFilterChip(
                    filter: filter,
                    isSelected: selectedFilter == filter,
                    onSelected: (_) {
                      _filterTours(filter);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Tours',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter chips
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      return CategoryFilterChip(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        onSelected: (_) => _filterTours(filter),
                      );
                    },
                  ),
                ),

                // Tour list
                Expanded(
                  child: filteredTours.isEmpty
                      ? const Center(
                          child: Text(
                            'No tours available for this category',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: filteredTours.length,
                          itemBuilder: (context, index) {
                            final tour = filteredTours[index];
                            return TourCard(
                              tour: tour,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TourDetailsScreen(tour: tour),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
