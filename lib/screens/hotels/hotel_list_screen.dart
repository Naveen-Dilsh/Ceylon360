import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import '../../services/places_service.dart';
import '../../widgets/hotel_card.dart';
import 'hotel_detail_screen.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({Key? key}) : super(key: key);

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  final PlacesService _placesService = PlacesService();
  List<Hotel> _allHotels = [];
  List<Hotel> _filteredHotels = [];

  String _searchQuery = '';
  String _selectedSort = 'None';
  String _selectedProvince = 'All';

  final Map<String, String> _provinceLocations = {
    'Western': '6.9271,79.8612',  // Colombo
    'Southern': '6.0535,80.2210', // Galle
    'Central': '7.2906,80.6337',  // Kandy
  };

  @override
  void initState() {
    super.initState();
    _fetchHotelsForProvince(_selectedProvince);
  }

  Future<void> _fetchHotelsForProvince(String province) async {
    setState(() {
      _allHotels = [];
      _filteredHotels = [];
    });

    try {
      List<Hotel> hotels = [];

      if (province == 'All') {
        for (String loc in _provinceLocations.values) {
          final results = await _placesService.getNearbyHotels(loc);
          hotels.addAll(results);
        }
      } else {
        final loc = _provinceLocations[province]!;
        hotels = await _placesService.getNearbyHotels(loc);
      }

      setState(() {
        _allHotels = hotels;
        _filteredHotels = hotels;
      });
    } catch (e) {
      print('Failed to load hotels for $province: $e');
    }
  }

  void _applyFilters() {
    List<Hotel> filtered = _allHotels;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((hotel) => hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedSort == 'Rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      _filteredHotels = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hotels in Sri Lanka")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by hotel name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedProvince,
                    decoration: InputDecoration(
                      labelText: 'Select Province',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['All', ..._provinceLocations.keys]
                        .map((province) => DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _selectedProvince = value;
                        _searchQuery = '';
                        _selectedSort = 'None';
                        _fetchHotelsForProvince(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
                    decoration: InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: ['None', 'Rating']
                        .map((sort) => DropdownMenuItem(
                      value: sort,
                      child: Text(sort),
                    ))
                        .toList(),
                    onChanged: (value) {
                      _selectedSort = value!;
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredHotels.isEmpty
                ? const Center(child: Text('No hotels found.'))
                : ListView.builder(
              itemCount: _filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = _filteredHotels[index];
                return HotelCard(
                  hotel: hotel,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetailScreen(hotel: hotel),
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
