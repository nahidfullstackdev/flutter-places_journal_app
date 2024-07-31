import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.loocation =
        const UserLocation(latitude: 37.22, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  final UserLocation loocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
          onTap: !widget.isSelecting
              ? null
              : (position) {
                  setState(() {
                    _pickedLocation = position;
                  });
                },
          initialCameraPosition: CameraPosition(
            target:
                LatLng(widget.loocation.latitude, widget.loocation.longitude),
            zoom: 16,
          ),
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: const MarkerId('m1'),
                    position:
                        _pickedLocation ?? // _pickedLocation != null? _pickedLocation!
                            LatLng(widget.loocation.latitude,
                                widget.loocation.longitude),
                  ),
                }),
    );
  }
}
