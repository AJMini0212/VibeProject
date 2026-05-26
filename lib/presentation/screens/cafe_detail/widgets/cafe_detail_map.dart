import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../domain/entities/cafe.dart';

class CafeDetailMap extends StatefulWidget {
  final Cafe cafe;

  const CafeDetailMap({
    super.key,
    required this.cafe,
  });

  @override
  State<CafeDetailMap> createState() => _CafeDetailMapState();
}

class _CafeDetailMapState extends State<CafeDetailMap> {
  GoogleMapController? mapController;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.cafe.latitude, widget.cafe.longitude),
        zoom: 16,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      markers: {
        Marker(
          markerId: MarkerId(widget.cafe.id),
          position: LatLng(widget.cafe.latitude, widget.cafe.longitude),
          infoWindow: InfoWindow(
            title: widget.cafe.name,
            snippet: widget.cafe.address,
          ),
        ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
