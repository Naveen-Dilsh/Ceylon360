class Tour {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final double price;
  final double rating;
  final int duration;
  final String category;
  final List<String> included;
  final Map<String, dynamic> tourOperator;

  Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.duration,
    required this.category,
    required this.included,
    required this.tourOperator,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      duration: json['duration'],
      category: json['category'],
      included: List<String>.from(json['included']),
      tourOperator: json['tourOperator'],
    );
  }
}
