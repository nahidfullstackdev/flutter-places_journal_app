import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/provider/user_places.dart';
import 'package:places/screens/add_place.dart';
import 'package:places/widgets/places_list.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key});

  @override
  ConsumerState<PlaceScreen> createState() {
    return _PlaceScreenState();
  }
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesprovider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Places',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddPlaceScreen(),
              ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PlacesList(
                    places: userPlaces,
                  ),
      ),
    );
  }
}
