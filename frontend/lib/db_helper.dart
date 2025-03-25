import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<void> initDb() async {
    if (_db != null) return;
    String path = join(await getDatabasesPath(), 'feedback.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE feedback (
            id INTEGER PRIMARY KEY,
            category TEXT,
            item TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  static Future<void> saveFeedback(String category, String item, double rating) async {
    await _db?.insert('feedback', {
      'category': category,
      'item': item,
      'rating': rating,
    });
  }

  static Future<double> getAverageRating(String category, String item) async {
    List<Map<String, dynamic>> results = await _db?.query(
      'feedback',
      where: 'category = ? AND item = ?',
      whereArgs: [category, item],
    ) ?? [];

    if (results.isEmpty) return 0.0;

    double total = results.fold(0.0, (sum, row) => sum + (row['rating'] as double));
    return total / results.length;
  }
}
