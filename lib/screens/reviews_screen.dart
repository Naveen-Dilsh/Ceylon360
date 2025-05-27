import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/places_service.dart';
import '../widgets/review_card.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Review> reviews = [];
  bool isLoading = true;
  late PlacesService _placesService;

  @override
  void initState() {
    super.initState();
    _placesService = PlacesService(
      apiKey: 'AIzaSyBbLd67HZT9EYb8Xi7ySuVWJVBmLRFREjM',
    );
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedReviews = await _placesService.fetchReviews();

      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? _buildLoadingView() : _buildContentView();
  }

  Widget _buildLoadingView() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildContentView() {
    return RefreshIndicator(
      onRefresh: fetchReviews,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: reviews.isEmpty ? _buildEmptyView() : _buildReviewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Visitor Reviews from Sri Lanka',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No reviews available',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          TextButton(onPressed: fetchReviews, child: Text('Refresh')),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemCount: reviews.length,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewCard(
          review: review,
          photoUrl: _placesService.getPhotoUrl(review.photoReference),
        );
      },
    );
  }
}
