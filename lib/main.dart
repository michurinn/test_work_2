import 'package:effective_test_work/src/database/sqlite_database.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = SqliteDatabase();
  await db.init();
  runApp(
    MyApp(
      db: db,
    ),
  );
}
