import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 3.0;
  String _selectedOption = '';
  String _selectedPlace = 'Shop 1';
  final List<String> _places = ['Shop 1', 'Shop 2', 'Cafeteria 1', 'Cafeteria 2'];
  final Map<String, List<double>> _reviews = {
    'Shop 1': [],
    'Shop 2': [],
    'Cafeteria 1': [],
    'Cafeteria 2': []
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose an option:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Post Review'),
              leading: Radio(
                value: 'post',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() => _selectedOption = value.toString());
                },
              ),
            ),
            ListTile(
              title: Text('Check Review'),
              leading: Radio(
                value: 'check',
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() => _selectedOption = value.toString());
                },
              ),
            ),
            if (_selectedOption == 'post') _buildPostReview(),
            if (_selectedOption == 'check') _buildCheckReview(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text('Select a place:', style: TextStyle(fontSize: 16)),
        DropdownButton<String>(
          value: _selectedPlace,
          items: _places.map((place) => DropdownMenuItem(value: place, child: Text(place))).toList(),
          onChanged: (value) {
            setState(() => _selectedPlace = value!);
          },
        ),
        Slider(
          value: _rating,
          min: 0,
          max: 5,
          divisions: 5,
          label: _rating.toString(),
          onChanged: (value) {
            setState(() => _rating = value);
          },
        ),
        ElevatedButton(
          onPressed: _submitReview,
          child: Text('Submit Review'),
        ),
      ],
    );
  }

  Widget _buildCheckReview() {
    return Expanded(
      child: ListView.builder(
        itemCount: _places.length,
        itemBuilder: (context, index) {
          String place = _places[index];
          double avgRating = _reviews[place]!.isEmpty
              ? 0
              : _reviews[place]!.reduce((a, b) => a + b) / _reviews[place]!.length;
          return ListTile(
            title: Text(place),
            subtitle: Text('Average Rating: ${avgRating.toStringAsFixed(1)}'),
          );
        },
      ),
    );
  }

  void _submitReview() {
    _reviews[_selectedPlace]!.add(_rating);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review submitted for $_selectedPlace!')),
    );
    setState(() => _selectedOption = '');
  }
}
