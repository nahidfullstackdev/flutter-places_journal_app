import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';

import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath =
      await sql.getDatabasesPath(); //create a directory to create a database..
  final placeDb = await sql.openDatabase(
    // create a database with specific by name , here is 'places.db'..
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 2,
  );

  return placeDb;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  //...Loadinng data from SQL Database...................
  Future<void> loadPlaces() async {
    final db = await _getDatabase();

    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: UserLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        ).toList();

    state = places;
  }
  //................................................................//

  //..updating the state, because you couldn't add any data directly there
  void addPlace(String title, File image, UserLocation location) async {
    //........................................................................................//
    //........................................................................................//
    //... 1st step for storing the images in local device by sqflite package...here is copying the image into path...
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');
    //................................................................//

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

//........................................................................................//
//..Storing all data in SQL Database by Sqflite Package......

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    //................................................................//
    state = [
      newPlace,
      ...state
    ]; // ''...'' is spread operator to include old state list that shouldn't lose them.
  }
}

//... setup the provider..

final userPlacesprovider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
