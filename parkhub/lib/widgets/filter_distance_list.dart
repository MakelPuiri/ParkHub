import 'package:flutter/material.dart';

class FilterDistanceListWidget extends StatefulWidget {
  final Function(String) onApply;

  const FilterDistanceListWidget({
    super.key,
    required this.onApply,
  });

  @override
  State<FilterDistanceListWidget> createState() =>
      _FilterDistanceListWidgetState();
}

class _FilterDistanceListWidgetState
    extends State<FilterDistanceListWidget> {
  final TextEditingController destinationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: destinationController,
            decoration: const InputDecoration(
              hintText: 'Search destination',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              widget.onApply(
                destinationController.text,
              );

              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}