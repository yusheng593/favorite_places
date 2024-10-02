import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title) {
    final newPlace = Place(title: title);
    state = [newPlace, ...state];
  }

  void removePlace(Place place) {
    state = state.where((place) => place.id != place.id).toList();
  }

  void insertPlace(int index, Place place) {
    if (index < 0 || index > state.length) {
      throw RangeError('Index out of range');
    }
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
