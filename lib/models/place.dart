class Place {
  final String id;
  final String name;
  final double rating;
  final String? photoReference;

  Place({
    required this.id,
    required this.name,
    required this.rating,
    this.photoReference,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final String? photoRef = json['photos'] != null && json['photos'].isNotEmpty
        ? json['photos'][0]['photo_reference']
        : null;

    return Place(
      id: json['place_id'] ?? '',
      name: json['name'] ?? 'Unknown Place',
      rating: (json['rating'] ?? 0).toDouble(),
      photoReference: photoRef,
    );
  }
}
