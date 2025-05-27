import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          rating.floor(),
          (index) => Icon(Icons.star, color: color, size: size),
        ),
        if ((rating % 1) > 0) Icon(Icons.star_half, color: color, size: size),
        SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size - 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
