import 'dart:async';

import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/entity/favorite_character_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;

final class BehaviorSubject<T> {
  List<T> previousData = [];

  late final StreamSubscription<T> _sourceSubs;

  Stream<T> replayedStream() async* {
    for (var element in previousData) {
      yield element;
    }

    yield* _controller.stream.distinct();
  }

  Stream<T> get stream => replayedStream();
  final StreamController<T> _controller = StreamController.broadcast();

  BehaviorSubject({required Stream<T> source, required T initialData}) {
    _controller.sink.add(initialData);
    previousData.add(initialData);
    _sourceSubs = source.listen(
      (event) {
        previousData.add(event);
        _controller.sink.add(event);
      },
    );
  }

  void dispose() {
    _sourceSubs.cancel();
  }
}

class SqliteDatabase {
  static String getCurrent() => (path.current);
  late final Database db;
  static String? _databasePath;
  static Future<String> _getDatabasePath() async {
    if (_databasePath != null) return _databasePath!;

    final dir = await getApplicationDocumentsDirectory();
    _databasePath = path.join(dir.path, 'my_app.db');
    return _databasePath!;
  }

  Future<void> init() async {
    // Получение пути к базе
    db = sqlite3.open(await _getDatabasePath());
    db.execute(createTableSQL);
    // Query the sqlite_master system table

    favoriteChanges = BehaviorSubject<Iterable<FavoriteCharacterEntity>>(
      source: _favoritesController.stream,
      initialData: getFavorites(),
    );
    changes = BehaviorSubject<Iterable<CharacterEntity>>(
      source: _charactersController.stream,
      initialData: getCharacters(),
    );
  }

  late final BehaviorSubject<Iterable<CharacterEntity>>? changes;

  late final BehaviorSubject<Iterable<FavoriteCharacterEntity>>?
      favoriteChanges;

  final StreamController<Iterable<FavoriteCharacterEntity>>
      _favoritesController = StreamController.broadcast();

  final StreamController<Iterable<CharacterEntity>> _charactersController =
      StreamController(
    // onPause: () => print('Paused'),
    // onResume: () => print('Resumed'),
    // onCancel: () => print('Cancelled'),
    // onListen: () => print('Listens'),
  );

  final createTableSQL = '''
  CREATE TABLE IF NOT EXISTS favorite_characters (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      status TEXT NOT NULL,
      gender TEXT NOT NULL,
      photo_url TEXT NOT NULL,
      favorite BOOL
  );
''';

  void addFavorite(CharacterEntity entity) {
    final stmnt = db.prepare(''' UPDATE favorite_characters
              SET favorite = (CASE WHEN favorite = true THEN false ELSE true END)
              WHERE id = ? ''');
    try {
      stmnt.execute([
        entity.id,
      ]);
    } on Exception catch (_) {
    } finally {
      stmnt.dispose();
    }
    _favoritesController.add(getFavorites());
  }

  void createCharacters(Iterable<CharacterEntity> entities) {
    for (final entity in entities) {
      final stmnt = db.prepare(
          ''' INSERT OR IGNORE INTO favorite_characters (id, name, status, gender, photo_url, favorite)
                                VALUES (?, ?, ?, ?, ?,?)''');
      try {
        stmnt.execute([
          entity.id,
          entity.name,
          entity.status.name,
          entity.gender.name,
          entity.photoUrl,
          false,
        ]);
      } on Exception catch (_) {
      } finally {
        stmnt.dispose();
      }
    }

    _charactersController.add(getCharacters());
  }

  void deleteFavorite(int id) {
    final stmnt =
        db.prepare(''' DELETE FROM favorite_characters WHERE id = ?''');

    try {
      stmnt.execute([id]);
    } on Exception catch (_) {
    } finally {
      stmnt.dispose();
    }
    _favoritesController.add(getFavorites());
  }

  Iterable<FavoriteCharacterEntity> getFavorites() {
    final resultSet = db.select(
        '''SELECT * FROM favorite_characters WHERE favorite = true ORDER BY name''');
    final result = resultSet.rows.map(
      (e) => FavoriteCharacterEntity(
          id: e[0] as int,
          name: e[1] as String,
          status: Status.values.firstWhere(
            (element) => element.name == e[2] as String,
          ),
          gender: Gender.values
              .firstWhere((element) => element.name == e[3] as String),
          photoUrl: e[4] as String),
    );
    return result;
  }

  Iterable<CharacterEntity> getCharacters() {
    final resultSet = db.select('''SELECT * FROM favorite_characters ''');
    final result = resultSet.rows.map(
      (e) => CharacterEntity(
        id: e[0] as int,
        name: e[1] as String,
        status: Status.values.firstWhere(
          (element) => element.name == e[2] as String,
        ),
        gender: Gender.values
            .firstWhere((element) => element.name == e[3] as String),
        photoUrl: e[4] as String,
      ),
    );
    return result;
  }

  Stream<Iterable<CharacterEntity>> getCharactersStream() {
    return changes!.stream;
  }

  BehaviorSubject<Iterable<FavoriteCharacterEntity>> getFavoritesStream() {
    return favoriteChanges!;
  }

  Stream<Iterable<int>> getFavoritesIds() {
    return favoriteChanges!.stream.map(
      (event) => event.map(
        (e) => e.id,
      ),
    );
  }
}
