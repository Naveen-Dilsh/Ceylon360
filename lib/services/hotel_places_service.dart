import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/hotel_model.dart';

class PlacesService {
  /// Fetch nearby hotels (lodging) using lat,lng string
  Future<List<Hotel>> getNearbyHotels(String location) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=5000&type=lodging&key=${ApiKeys.googlePlacesApiKey}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final results = body['results'] as List;

      return results.map((hotel) => Hotel.fromJson(hotel)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  /// Fetch website for a given hotel using placeId
  Future<String> getHotelWebsite(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=website&key=${ApiKeys.googlePlacesApiKey}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResult = json.decode(response.body);
      final website = jsonResult['result']['website'];
      return website ?? '';
    } else {
      throw Exception('Failed to fetch hotel website');
    }
  }

  /// Helper for getting a photo URL from a photo reference
  static String? getPhotoUrl(String? photoReference) {
    if (photoReference == null) return null;
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${ApiKeys.googlePlacesApiKey}";
  }
}
