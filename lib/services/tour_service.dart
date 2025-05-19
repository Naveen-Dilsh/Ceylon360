import '../models/tour.dart';

class TourService {
  static List<Tour> getPreDefinedTours() {
    final toursData = [
      {
        'id': 'tour1',
        'title': '7-Day Cultural Heritage Tour',
        'description':
            'Experience the rich cultural heritage of Sri Lanka with visits to ancient temples, historical sites, and traditional villages.',
        'location': 'Colombo, Kandy, Sigiriya',
        'imageUrl': 'https://picsum.photos/seed/cultural/600/400',
        'price': 45000,
        'rating': 4.8,
        'duration': 7,
        'category': 'Cultural',
        'included': [
          'Hotel accommodation',
          'Breakfast and dinner',
          'English-speaking guide',
        ],
        'tourOperator': {
          'name': 'Ceylon Heritage Tours',
          'logo': 'https://picsum.photos/seed/ceylon/200',
        },
      },
      {
        'id': 'tour2',
        'title': '5-Day Wildlife Safari',
        'description':
            'Discover Sri Lanka\'s incredible wildlife on this safari adventure. Visit Yala and Udawalawe National Parks.',
        'location': 'Yala, Udawalawe',
        'imageUrl': 'https://picsum.photos/seed/wildlife/600/400',
        'price': 35000,
        'rating': 4.7,
        'duration': 5,
        'category': 'Wildlife',
        'included': [
          'Hotel accommodation',
          'Safari jeep',
          'National park fees',
        ],
        'tourOperator': {
          'name': 'Wild Ceylon Safaris',
          'logo': 'https://picsum.photos/seed/wild/200',
        },
      },
      {
        'id': 'tour3',
        'title': '3-Day Beach Retreat',
        'description':
            'Relax and unwind on the pristine beaches of southern Sri Lanka. Includes stays at luxury beachfront resorts.',
        'location': 'Mirissa, Unawatuna',
        'imageUrl': 'https://picsum.photos/seed/beach/600/400',
        'price': 28000,
        'rating': 4.6,
        'duration': 3,
        'category': 'Beach',
        'included': [
          'Beachfront accommodation',
          'Beach activities',
          'Sunset cruise',
        ],
        'tourOperator': {
          'name': 'Ocean Lanka Travels',
          'logo': 'https://picsum.photos/seed/ocean/200',
        },
      },
      {
        'id': 'tour4',
        'title': '6-Day Adventure Tour',
        'description':
            'For thrill-seekers, this adventure tour offers white-water rafting, rock climbing, hiking, and ziplining.',
        'location': 'Kitulgala, Ella, Haputale',
        'imageUrl': 'https://picsum.photos/seed/adventure/600/400',
        'price': 50000,
        'rating': 5.0,
        'duration': 6,
        'category': 'Adventure',
        'included': [
          'Activity fees',
          'Safety equipment',
          'Adventure insurance',
        ],
        'tourOperator': {
          'name': 'Thrill Lanka Adventures',
          'logo': 'https://picsum.photos/seed/thrill/200',
        },
      },
      {
        'id': 'tour5',
        'title': '4-Day Nature Escape',
        'description':
            'Immerse yourself in Sri Lanka\'s breathtaking natural landscapes with this eco-friendly tour.',
        'location': 'Sinharaja, Horton Plains',
        'imageUrl': 'https://picsum.photos/seed/nature/600/400',
        'price': 32000,
        'rating': 4.5,
        'duration': 4,
        'category': 'Nature',
        'included': [
          'Eco-friendly accommodation',
          'Guided nature walks',
          'National park fees',
        ],
        'tourOperator': {
          'name': 'Green Lanka Eco Tours',
          'logo': 'https://picsum.photos/seed/green/200',
        },
      },
    ];

    return toursData.map((data) => Tour.fromJson(data)).toList();
  }

  static Future<List<Tour>> fetchTours() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return getPreDefinedTours();
  }
}
