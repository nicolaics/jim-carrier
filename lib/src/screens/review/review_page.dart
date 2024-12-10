import 'package:flutter/material.dart';

import '../../api/review.dart';

class ReviewPage extends StatefulWidget {
  final Map<String, dynamic> carrier;

  const ReviewPage({super.key, required this.carrier});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<dynamic> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final carrier = widget.carrier;
      dynamic response = await getReceivedReviews(
        carrierId: carrier['carrierId'],
        api: '/review/received',
      );
      if (response['status'] == "success") {
        setState(() {
          reviews = response['message'] ?? [];
        });
      } else {
        print("Error fetching reviews: ${response['message']}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStars(double rating) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (starIndex) {
          if (starIndex < rating.floor()) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            );
          } else if (starIndex < rating && rating - starIndex >= 0.5) {
            return const Icon(
              Icons.star_half,
              color: Colors.amber,
              size: 16,
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: Colors.amber,
              size: 16,
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrier Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : reviews.isEmpty
            ? const Center(
          child: Text(
            'No reviews yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
            : ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            final rating = (review['rating'] ?? 0).toDouble();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Number and Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User #${review['reviewerId'] ?? 'Unknown'}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        _buildStars(rating),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Review Content
                    Text(
                      review['content'] ?? 'No content provided',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
