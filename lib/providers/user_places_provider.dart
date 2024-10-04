import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(title: title, image: copiedImage);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });

    state = [newPlace, ...state];
  }

  void removePlace(Place placeToRemove) async {
    final db = await _getDatabase();
    await db
        .delete('user_places', where: 'id = ?', whereArgs: [placeToRemove.id]);

    state = state.where((place) => place.id != placeToRemove.id).toList();

    // 删除图片文件
    if (await placeToRemove.image.exists()) {
      await placeToRemove.image.delete();
    }
  }

  void insertPlace(int index, Place place) async {
    if (index < 0 || index > state.length) {
      throw RangeError('Index out of range');
    }

    // 如果该地点已经存在，则更新数据库记录
    final db = await _getDatabase();
    await db.insert(
        'user_places',
        {
          'id': place.id,
          'title': place.title,
          'image': place.image.path,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    state = [
      ...state.sublist(0, index),
      place,
      ...state.sublist(index),
    ];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>((rdf) {
  return UserPlacesNotifier();
});
