import 'dart:async';
import 'package:e_commerce_app/providers/User.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConnectDatabase {
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await createDb();
    return _db;
  }

  createDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE users(id TEXT PRIMARY KEY, fullname TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<void> addUser(User user) async {
    // Get a reference to the database.
    final Database? database = await db;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    if (database == null) return;
    await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getCount() async {
    final Database? database = await db;

    // Query the table for all The Users.

    final List<Map<String, dynamic>> maps =
        await database!.rawQuery("SELECT COUNT(*) FROM users");
    return maps.length;
  }

  Future<List<dynamic>> fetchAllUsers() async {
    // Get a reference to the database.
    final Database? database = await db;

    // Query the table for all The Users.
    final List<Map<String, dynamic>> maps = await database!.query('users');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }
}
