import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة الأحداث'),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          final markers = provider.events.map((event) {
            return Marker(
              markerId: MarkerId(event.title + event.timestamp),
              position: LatLng(event.latitude, event.longitude),
              infoWindow: InfoWindow(
                title: event.title,
                snippet: event.timestamp,
                onTap: () => _showEventDetails(context, event),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
            );
          }).toSet();

          return Padding(
            padding: const EdgeInsets.only(bottom: 100), // إزاحة للأعلى لمنع التداخل مع شريط التنقل
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.0, 45.0),
                zoom: 4,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: markers,
              style: _mapStyle,
              zoomControlsEnabled: true,
            ),
          );
        },
      ),
    );
  }

  void _showEventDetails(BuildContext context, EventModel event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.primaryDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: AppTheme.accentGold, width: 2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(event.timestamp, style: const TextStyle(color: AppTheme.accentGold)),
            const SizedBox(height: 16),
            Text(event.description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGold,
                foregroundColor: Colors.black,
              ),
              child: const Center(child: Text('إغلاق')),
            )
          ],
        ),
      ),
    );
  }

  // A simplified dark mode style for Google Maps
  final String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#212121"}]
  },
  {
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#212121"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#000000"}]
  }
]
''';
}
