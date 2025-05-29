import 'package:flutter/material.dart';
import '../models/review.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final String? photoUrl;

  const ReviewCard({super.key, required this.review, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildPlaceHeader(), _buildReviewContent(context)],
      ),
    );
  }

  Widget _buildPlaceHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Background image
          SizedBox(
            height: 80,
            width: double.infinity,
            child: photoUrl != null
                ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.blueGrey[200]);
                    },
                  )
                : Container(color: Colors.blueGrey[200]),
          ),
          // Gradient overlay
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          // Place name and rating
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.placeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                RatingStars(rating: review.placeRating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review header with user info
          Row(
            children: [
              _buildAuthorAvatar(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      review.relativeTimeDescription,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              // User rating
              _buildUserRatingBadge(),
            ],
          ),
          Divider(height: 24),
          // Review text
          Text(
            review.text,
            style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
          ),
          SizedBox(height: 16),
          // Review actions
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildAuthorAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: review.profilePhotoUrl != null
          ? NetworkImage(review.profilePhotoUrl!)
          : null,
      child: review.profilePhotoUrl == null
          ? Text(
              review.authorName.substring(0, 1),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  Widget _buildUserRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRatingColor(review.rating),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            '${review.rating}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          icon: Icon(Icons.thumb_up_outlined, size: 16),
          label: Text('Helpful'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thank you for your feedback!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blueGrey[600]),
        ),
        SizedBox(width: 8),
        TextButton.icon(
          icon: Icon(Icons.share_outlined, size: 16),
          label: Text('Share'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Share feature coming soon!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          style: TextButton.styleFrom(foregroundColor: Colors.blueGrey[600]),
        ),
      ],
    );
  }

  Color _getRatingColor(num rating) {
    if (rating >= 4.5) return Colors.green[700]!;
    if (rating >= 4) return Colors.green[500]!;
    if (rating >= 3) return Colors.orange[700]!;
    return Colors.red[700]!;
  }
}
