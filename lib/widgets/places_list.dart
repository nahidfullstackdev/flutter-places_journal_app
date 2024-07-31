import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/screens/place_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No Places added yet, Ad Some!',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: places[index]),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                places[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              Text(
                places[index].location.address,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Card(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 15,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Image.file(
                      places[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //(context, index) => ListTile(
      //   title: Text(
      //     places[index].title,
      //     style: Theme.of(context)
      //         .textTheme
      //         .titleMedium!
      //         .copyWith(color: Theme.of(context).colorScheme.onBackground),
      //   ),
      //   onTap: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => PlaceDetailScreen(
      //         place: places[index],
      //       ),
      //     ));
      //   },
      // ),
    );
  }
}
