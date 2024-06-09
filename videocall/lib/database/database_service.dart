import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';

class DatabaseService {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  // Get the full path for the database file
  Future<String> get fullPath async {
    const databaseName = 'videocall.db';
    final path = await getDatabasesPath();
    return p.join(path, databaseName);
  }

  // Initialize the database
  Future<Database> _initialize() async {
    final path = await fullPath;

    // Check if the database already exists in the internal storage
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      // If it doesn't exist, copy it from the assets
      await _copyDatabaseFromAssets(path);
    }

    // Open the database
    return await openDatabase(path);
  }

  // Copy the database from the assets to the internal storage
  Future<void> _copyDatabaseFromAssets(String path) async {
    // Load the database file from the assets
    ByteData data = await rootBundle.load('assets/videocall.db');

    // Create a list of bytes
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write the bytes to the file at the specified path
    await File(path).writeAsBytes(bytes);
  }
}
