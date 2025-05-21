import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class PlacesService {
  final String apiKey;

  // Popular places in Sri Lanka
  final List<String> popularPlaceIds = [
    'ChIJgV4zX_Fc4ToROx5puZ0DB9U', // Sigiriya
    'ChIJl0tIB4Fc4ToRtS_fLJSbP8Q', // Temple of the Tooth
    'ChIJlWZ2DWAf4zoR3o8wDCOYjtk', // Galle Fort
    'ChIJ-wbECCJ94joRH_5UvHFqU6E', // Yala National Park
    'ChIJCQwKiPld4ToRH2EdLhJDOQA', // Polonnaruwa
  ];

  PlacesService({required this.apiKey});

  Future<List<Review>> fetchReviews() async {
    final reviewsList = <Review>[];

    // Use 3 random popular places to fetch reviews
    final random = Random();
    final selectedPlaces =
        List.generate(
          min(3, popularPlaceIds.length),
          (_) => popularPlaceIds[random.nextInt(popularPlaceIds.length)],
        ).toSet().toList();

    for (final placeId in selectedPlaces) {
      try {
        final response = await http.get(
          Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,reviews,photos&key=$apiKey',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['result'] != null && data['result']['reviews'] != null) {
            final placeName = data['result']['name'];
            final placeRating = data['result']['rating'];
            final photoReference =
                data['result']['photos'] != null &&
                        data['result']['photos'].isNotEmpty
                    ? data['result']['photos'][0]['photo_reference']
                    : null;

            for (final review in data['result']['reviews']) {
              reviewsList.add(
                Review.fromJson({
                  ...review,
                  'place_name': placeName,
                  'place_rating': placeRating,
                  'photo_reference': photoReference,
                }),
              );
            }
          }
        }
      } catch (e) {
        print('Error fetching reviews for place $placeId: $e');
      }
    }

    // Fallback data if no reviews were fetched
    if (reviewsList.isEmpty) {
      reviewsList.addAll([
        Review.fromJson({
          'author_name': 'Tharusha Rasath',
          'rating': 5,
          'relative_time_description': '2 weeks ago',
          'text':
              'Absolutely breathtaking place! The climb to the top was well worth it for the panoramic views. One of Sri Lanka\'s must-visit destinations.',
          'profile_photo_url': 'https://picsum.photos/seed/sarah/200',
          'place_name': 'Sigiriya Rock Fortress',
          'place_rating': 4.8,
        }),
        Review.fromJson({
          'author_name': 'Tharindu Dissanayake',
          'rating': 4,
          'relative_time_description': '1 month ago',
          'text':
              'Beautiful beaches and friendly locals. The food was amazing and very affordable. Would definitely come back!',
          'profile_photo_url': 'https://picsum.photos/seed/mike/200',
          'place_name': 'Unawatuna Beach',
          'place_rating': 4.5,
        }),
        Review.fromJson({
          'author_name': 'Pabasara Ashen',
          'rating': 5,
          'relative_time_description': '3 days ago',
          'text':
              'The Temple of the Sacred Tooth Relic was a spiritual experience like no other. The architecture and atmosphere were incredibly moving.',
          'profile_photo_url': 'https://picsum.photos/seed/emma/200',
          'place_name': 'Temple of the Sacred Tooth Relic',
          'place_rating': 4.7,
        }),
      ]);
    }

    // Shuffle to display in random order
    reviewsList.shuffle();

    return reviewsList;
  }

  String? getPhotoUrl(String? photoReference) {
    if (photoReference == null) return null;
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }
}
