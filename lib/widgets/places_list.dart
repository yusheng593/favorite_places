import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList(
      {super.key, required this.place, required this.removeFavorite});

  final List<Place> place;
  final void Function(Place) removeFavorite;

  @override
  Widget build(BuildContext context) {
    return place.isEmpty
        ? const Stack(
            children: [
              Positioned(
                top: 8,
                right: 4,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.yellow,
                  size: 40,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Nothing here!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Try add something!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : ListView.builder(
            itemCount: place.length,
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(place[index].id),
              onDismissed: (direction) {
                removeFavorite(place[index]);
              },
              background: Container(
                color: Colors.amber,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(place[index].image),
                ),
                title: Text(
                  place[index].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (cxt) => PlaceDetail(place: place[index]),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
