class Hotel {
  final String name;
  final String? photoReference;
  final String placeId;
  final double lat;
  final double lng;
  final double rating;
  final String address;



  Hotel({
    required this.name,
    required this.photoReference,
    required this.placeId,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.address,

  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] ?? 'Unknown',
      photoReference: json['photos'] != null && json['photos'].isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
      placeId: json['place_id'],
      lat: json['geometry']['location']['lat'],
      lng: json['geometry']['location']['lng'],
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['vicinity'] ?? 'No address available',

    );
  }
}
