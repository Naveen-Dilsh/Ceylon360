class Review {
  final String authorName;
  final int rating;
  final String relativeTimeDescription;
  final String text;
  final String? profilePhotoUrl;
  final String placeName;
  final double placeRating;
  final String? photoReference;

  Review({
    required this.authorName,
    required this.rating,
    required this.relativeTimeDescription,
    required this.text,
    this.profilePhotoUrl,
    required this.placeName,
    required this.placeRating,
    this.photoReference,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'] ?? 'Anonymous',
      rating: json['rating'] ?? 0,
      relativeTimeDescription: json['relative_time_description'] ?? 'Recently',
      text: json['text'] ?? 'No review text',
      profilePhotoUrl: json['profile_photo_url'],
      placeName: json['place_name'] ?? 'Sri Lankan Attraction',
      placeRating: (json['place_rating'] ?? 0).toDouble(),
      photoReference: json['photo_reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author_name': authorName,
      'rating': rating,
      'relative_time_description': relativeTimeDescription,
      'text': text,
      'profile_photo_url': profilePhotoUrl,
      'place_name': placeName,
      'place_rating': placeRating,
      'photo_reference': photoReference,
    };
  }
}
