import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/info_row.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventService _eventService = EventService();
  List<Event> events = [];
  bool isLoading = true;
  String selectedCategory = 'All Events';
  final List<String> categories = [
    'All Events',
    'Festivals',
    'Cultural',
    'Music',
    'Food',
    'Adventure',
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => isLoading = true);
    try {
      final fetchedEvents = await _eventService.fetchEvents();
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load events: $e')));
    }
  }

  List<Event> getFilteredEvents() {
    if (selectedCategory == 'All Events') {
      return events;
    } else {
      return events
          .where((event) => event.category == selectedCategory)
          .toList();
    }
  }

  void _filterEventsByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = getFilteredEvents();

    return Scaffold(
      appBar: AppBar(title: const Text('Events in Sri Lanka')),
      body: Column(
        children: [
          // Category filters
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryChip(
                    category: category,
                    isSelected: selectedCategory == category,
                    onSelected: _filterEventsByCategory,
                  );
                },
              ),
            ),
          ),

          // Events list
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No ${selectedCategory != 'All Events' ? selectedCategory : ''} events found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _filterEventsByCategory('All Events'),
                              child: Text('View All Events'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadEvents,
                        child: ListView.builder(
                          itemCount: filteredEvents.length,
                          padding: EdgeInsets.all(16),
                          itemBuilder: (context, index) => EventCard(
                            event: filteredEvents[index],
                            onTap: () => _showEventDetails(
                              context,
                              filteredEvents[index],
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailsModal(event: event),
    );
  }
}

class EventDetailsModal extends StatelessWidget {
  final Event event;

  const EventDetailsModal({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final formattedDate = dateFormat.format(event.date);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.blue[100],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.blue[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(event.category),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.category,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        InfoRow(
                          icon: Icons.calendar_today,
                          text: formattedDate,
                        ),
                        InfoRow(icon: Icons.location_on, text: event.location),
                        InfoRow(
                          icon: Icons.monetization_on,
                          text: event.price > 0
                              ? 'LKR ${event.price.toString()}'
                              : 'Free Entry',
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ...List.generate(
                              event.rating.floor(),
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                            if ((event.rating - event.rating.floor()) > 0)
                              Icon(
                                Icons.star_half,
                                color: Colors.amber,
                                size: 20,
                              ),
                            SizedBox(width: 6),
                            Text(
                              event.rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'About This Event',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          event.description,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Share feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Share'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(event.category),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Festivals':
        return Colors.purple[700]!;
      case 'Cultural':
        return Colors.teal[700]!;
      case 'Music':
        return Colors.blue[700]!;
      case 'Food':
        return Colors.orange[700]!;
      case 'Adventure':
        return Colors.green[700]!;
      default:
        return Colors.indigo[700]!;
    }
  }
}
