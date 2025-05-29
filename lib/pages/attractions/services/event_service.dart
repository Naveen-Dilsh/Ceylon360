import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class EventService {
  final Random _random = Random();
  final String _apiKey = 'AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM';

  Future<List<Event>> fetchEvents() async {
    try {
      final placesResponse = await fetchSriLankanVenues();
      final allEvents = [..._getPreDefinedEvents(), ...placesResponse];
      allEvents.shuffle();
      return allEvents;
    } catch (e) {
      return _getPreDefinedEvents();
    }
  }

  Future<List<Event>> fetchSriLankanVenues() async {
    final venues = <Event>[];
    final searchQueries = [
      'event venue in Sri Lanka',
      'cultural center Sri Lanka',
      'theater Sri Lanka',
      'concert hall Sri Lanka',
      'exhibition Sri Lanka',
    ];

    final selectedQueries =
        {
          searchQueries[_random.nextInt(searchQueries.length)],
          searchQueries[_random.nextInt(searchQueries.length)],
        }.toList();

    for (final query in selectedQueries) {
      try {
        final response = await http.get(
          Uri.parse(
            'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$_apiKey',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'] != null) {
            for (var i = 0; i < min(5, data['results'].length); i++) {
              final place = data['results'][i];
              if (place['photos'] == null) continue;

              final photoReference = place['photos'][0]['photo_reference'];
              final photoUrl =
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_apiKey';
              final eventDate = DateTime.now().add(
                Duration(days: _random.nextInt(90) + 1),
              );
              final categories = [
                'Cultural',
                'Festivals',
                'Music',
                'Food',
                'Adventure',
              ];
              final category = categories[_random.nextInt(categories.length)];

              venues.add(
                Event(
                  id: 'venue_${venues.length + 1}',
                  title:
                      '${_generateEventPrefix(category)} at ${place['name']}',
                  date: eventDate,
                  location: place['formatted_address'] ?? 'Sri Lanka',
                  imageUrl: photoUrl,
                  description: _generateDescription(category, place['name']),
                  category: category,
                  price: _random.nextInt(5000) + 500,
                  rating: place['rating'] ?? (3.0 + _random.nextDouble() * 2.0),
                ),
              );
            }
          }
        }
      } catch (e) {
        print('Error fetching venues: $e');
      }
    }
    return venues;
  }

  String _generateEventPrefix(String category) {
    final prefixes = {
      'Cultural': [
        'Cultural Exhibition',
        'Heritage Tour',
        'Traditional Dance Show',
      ],
      'Festivals': [
        'Festival of Lights',
        'Annual Celebration',
        'Heritage Festival',
      ],
      'Music': ['Live Concert', 'Music Festival', 'Traditional Music Night'],
      'Food': ['Food Festival', 'Culinary Exhibition', 'Taste of Sri Lanka'],
      'Adventure': [
        'Adventure Weekend',
        'Outdoor Experience',
        'Nature Expedition',
      ],
    };
    return prefixes[category]![_random.nextInt(prefixes[category]!.length)];
  }

  String _generateDescription(String category, String venueName) {
    final descriptions = [
      'Join us for an unforgettable experience at $venueName with spectacular performances and activities for all ages.',
      'Discover the rich heritage and beauty of Sri Lanka at this special event hosted at $venueName.',
      'Experience the vibrant culture and traditions of Sri Lanka with this exclusive event at $venueName.',
    ];
    return descriptions[_random.nextInt(descriptions.length)];
  }

  List<Event> _getPreDefinedEvents() {
    final now = DateTime.now();
    return [
      Event(
        id: 'event1',
        title: 'Kandy Esala Perahera',
        date: DateTime(now.year, 8, 2),
        location: 'Kandy, Sri Lanka',
        imageUrl:
            'https://maps.googleapis.com/maps/api/place/js/PhotoService.GetPhoto?1sAUjq9jmO6XmiGbliRKTLRQcvHQh2I8BnZfkFZRTBQTZpVOsQ5Q9TBFyR0wZttsH9SzIXpHzexrMTZnYvYbxG3DFZXPCw6dWH_Ia8HjM3kQrQkRqhwLnLmLHq_mbx-x6U-OBFD6XJJXXmE_eXi9_0wJW31ZMJiOgw4C-nPfO9RHdJsmAUXYZ&3u800&5m1&2e1&callback=none&key=AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM&token=19184',
        description:
            'The Kandy Esala Perahera is a grand festival with elegant costumes, dancing, and decorated elephants. The festival honors the Sacred Tooth Relic of Lord Buddha, which is housed at the Sri Dalada Maligawa in Kandy.',
        category: 'Festivals',
        price: 0,
        rating: 4.9,
      ),
      Event(
        id: 'event2',
        title: 'Sinhala and Tamil New Year',
        date: DateTime(now.year + 1, 4, 14),
        location: 'Nationwide, Sri Lanka',
        imageUrl:
            'https://maps.googleapis.com/maps/api/place/js/PhotoService.GetPhoto?1sAUjq9jlvRv7S_EK5MVAMtAWbAk0qOwQDYyRNhYEnQECdlFKQDkEXJmU-k9KEdBvICuBEdhsGBx5kw9jWzKhPVpqmY2XgVaG1ILpXt-OPcZJ1dEkT_9I-0MtJIQOSrKlxk5CbPpLvdK3YBLFMrxS_Rj8n9vQBWVJW7LRDDiChXJnNOKC_Yxmz&3u3264&5m1&2e1&callback=none&key=AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM&token=49866',
        description:
            'The Sinhala and Tamil New Year is a major anniversary festival that celebrates the traditional New Year in Sri Lanka. It is generally celebrated on April 13 or 14, marking the end of the harvest season.',
        category: 'Cultural',
        price: 0,
        rating: 4.8,
      ),
      Event(
        id: 'event3',
        title: 'Colombo International Film Festival',
        date: DateTime(now.year, 11, 10),
        location: 'Colombo, Sri Lanka',
        imageUrl:
            'https://maps.googleapis.com/maps/api/place/js/PhotoService.GetPhoto?1sAUjq9jkxwCVgvRDVZgK4lLNXcQ8qRrJOGfOTDFDQOyOQcEzKFZhKY1GYsN2iswQ3D3kNT5mEWQUdPeodUGJmNKCXcT8KTgIeLSZJLwk3lVeNtE-vgvwST2EyTMZgYDFAUhNpKnZqKtlzXIj_UhwdJK2xw0eIUUGBQWH9x6D7Nj5ORj1_KfQ&3u1024&5m1&2e1&callback=none&key=AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM&token=16495',
        description:
            'The Colombo International Film Festival showcases outstanding international and Sri Lankan films. It brings together filmmakers, actors, and cinema enthusiasts for a week-long celebration of the art of cinema.',
        category: 'Cultural',
        price: 5000,
        rating: 4.5,
      ),
    ];
  }
}
