class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String description;
  final String category;
  final double price;
  final double rating;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'price': price,
      'rating': rating,
    };
  }
}
