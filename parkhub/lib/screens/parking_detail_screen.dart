import 'package:flutter/material.dart';
import '../models/parking_spot_model.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

class ParkingDetailScreen extends StatefulWidget {
  final ParkingSpotModel spot;

  const ParkingDetailScreen({super.key, required this.spot});
 @override 
 State<ParkingDetailScreen> createState() => _ParkingDetailScreenState();
}
class _ParkingDetailScreenState extends State<ParkingDetailScreen> {

   @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    return Scaffold(
      appBar: AppBar(title: Text(spot.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SpotInfoCard(spot: spot),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.attach_money,
              label: 'Price',
              value: '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.directions_car,
              label: 'Availability',
              value: spot.isAvailable
                  ? '${spot.availableSpaces} of ${spot.totalSpaces} spaces available'
                  : 'Full',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.straighten,
              label: 'Distance',
              value: '${spot.distanceKm} km',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.timer,
              label: 'Time limit',
              value: spot.timeLimit,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.schedule,
              label: 'Peak times',
              value: spot.peakTimes,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.wb_sunny_outlined,
              label: 'Off-peak times',
              value: spot.offPeakTimes,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.trending_up,
              label: 'Predicted busy hours',
              value: spot.predictedBusyHours,
            ),
            const SizedBox(height: 20),
            //Rating
            const Text(
              'User Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Builder(builder: (context){
              final avg = ReviewService.getAverageRating(spot.id);
              final count = ReviewService.getReviewCount(spot.id);
              return Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 4),
                  Text(
                    avg > 0
                    ? '${avg.toStringAsFixed(1)} ($count reviews)'
                    : 'No reviews yet',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              );
            }), 
              const SizedBox(height: 16),

              // Reviews List
              ...ReviewService.getReviewsForParking(spot.id).map((review){
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          children: [
                            Text(review.userName, 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Icon(Icons.star, 
                                color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(review.rating.toStringAsFixed(1)),
                              ],
                          ),
                      ],
                        ),
                        const SizedBox(height: 4),
                        Text(review.comment),
                      ],
                    ),
                  ),
                );
              }),
              //submit review button
              const Text('Leave a Review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _ReviewForm(
                parkingId: spot.id,
                onSubmitted: () => setState(() {}),
              ),
            ],
          ),
        ),
      );
  }
}

class _SpotInfoCard extends StatelessWidget {
  final ParkingSpotModel spot;

  const _SpotInfoCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(spot.address, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 18),
                Text('\$${spot.pricePerHour.toStringAsFixed(2)}/hr'),
                const SizedBox(width: 16),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: spot.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  spot.isAvailable
                      ? '${spot.availableSpaces} spaces available'
                      : 'Full',
                  style: TextStyle(
                    color: spot.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewForm extends StatefulWidget {
  final String parkingId;
  final VoidCallback onSubmitted;

  const _ReviewForm({required this.parkingId, required this.onSubmitted});

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  double _rating = 3.0;
  final _commentController = TextEditingController();

  void _submit(){
    if (_commentController.text.trim().isEmpty) return;

    ReviewService.addReview(ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parkingId: widget.parkingId,
      userName: 'You', 
      rating: _rating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
    ));
    _commentController.clear();
    setState(() => _rating =3.0);
    widget.onSubmitted();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted!')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        const Icon(Icons.star, color: Colors.amber), 
        Expanded(child: Slider(
          value: _rating,
          min: 1.0,
          max: 5.0,
          divisions: 8,
          label: _rating.toStringAsFixed(1), 
          onChanged: (v) => setState(() => _rating = v),
        ), 
        ),
        Text(_rating.toStringAsFixed(1)), 
      ],
      ),
      TextField(
        controller: _commentController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Write your review here...',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit Review'),
        ),
      ),
    ],
    );
  }
}