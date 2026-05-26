import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/cafe.dart';

class MapWidget extends StatefulWidget {
  final LatLng? currentLocation;
  final List<Cafe> cafes;
  final Function(Cafe) onCafeTapped;

  const MapWidget({
    super.key,
    required this.currentLocation,
    required this.cafes,
    required this.onCafeTapped,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;

  Set<Marker> _buildMarkers() {
    return widget.cafes
        .map((cafe) => Marker(
              markerId: MarkerId(cafe.id),
              position: LatLng(cafe.latitude, cafe.longitude),
              infoWindow: InfoWindow(
                title: cafe.name,
                snippet: '⭐ ${cafe.rating}',
              ),
              onTap: () => widget.onCafeTapped(cafe),
            ))
        .toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation =
        widget.currentLocation ?? const LatLng(37.5665, 126.9780);

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: initialLocation,
        zoom: 15,
      ),
      markers: _buildMarkers(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
