import 'package:flutter/material.dart';
import 'db_helper.dart';

class CheckRatingScreen extends StatefulWidget {
  @override
  _CheckRatingScreenState createState() => _CheckRatingScreenState();
}

class _CheckRatingScreenState extends State<CheckRatingScreen> {
  String _category = 'Shops';
  String _selectedItem = '';
  final List<String> _categories = ['Shops', 'Cafeteria'];
  final List<String> _shops = ["Lafresco", "Ravechi", "Daily Needs", "Fruits Shop"];
  final List<String> _cafeterias = ["Nescafe", "Amul", "AS Canteen", "Shiru Cafe", "Juicilicious", "Village Cafe", "Zippy Cafe", "Central Dining Hall", "Dominos"];
  double _avgRating = 0.0;

  List<String> _getItems() {
    return _category == 'Shops' ? _shops : _cafeterias;
  }

  void _fetchAverageRating() async {
    if (_selectedItem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an item to check the rating!')),
      );
      return;
    }

    double avgRating = await DBHelper.getAverageRating(_category, _selectedItem);

    setState(() {
      _avgRating = avgRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Ratings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _category,
              items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                  _selectedItem = '';
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedItem.isNotEmpty ? _selectedItem : null,
              hint: Text('Select ${_category} Item'),
              items: _getItems().map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: (value) {
                setState(() => _selectedItem = value!);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAverageRating,
              child: Text('Check Rating'),
            ),
            SizedBox(height: 20),
            _avgRating > 0
                ? Text(
                    'Average Rating for $_selectedItem: ${_avgRating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    'No reviews available for $_selectedItem',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
          ],
        ),
      ),
    );
  }
}
