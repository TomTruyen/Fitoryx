import 'package:sqflite/sqflite.dart';

class SQLDatabase {
  Database db;

  Future<Database> setupDatabase() async {
    try {
      String dbPath = await getDatabasesPath();

      String path = dbPath + "fittrack.db";

      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE exercises (id INTEGER PRIMARY KEY UNIQUE, name TEXT, category TEXT, equipment TEXT, isUserCreated INTEGER)',
        );
      });

      return db;
    } catch (e) {
      return null;
    }
  }

  Future<Database> getDatabase() async {
    return db;
  }
}
/* Tables:
 - Exercise Table
    id INTEGER
    name TEXT
    category TEXT
    equipment TEXT
    isUserCreated INTEGER
*/
