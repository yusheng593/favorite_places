import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places_provider.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => PlacesScreenState();
}

class PlacesScreenState extends ConsumerState<PlacesScreen> {
  void _removeFavorite(Place favorite) {
    final currentIndex = ref.read(userPlacesProvider).indexOf(favorite);

    ref.read(userPlacesProvider.notifier).removePlace(favorite);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('刪除中'),
        action: SnackBarAction(
          label: '復原',
          onPressed: () async {
            ref
                .read(userPlacesProvider.notifier)
                .insertPlace(currentIndex, favorite);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Place'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPlaceScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlacesList(place: userPlaces, removeFavorite: _removeFavorite),
      ),
    );
  }
}
