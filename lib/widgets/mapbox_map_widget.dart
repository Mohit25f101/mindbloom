import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisCenter {
  final String name;
  final String address;
  final String distance;
  final String phone;
  final String type;
  final bool isOpen;
  final double latitude;
  final double longitude;

  CrisisCenter({
    required this.name,
    required this.address,
    required this.distance,
    required this.phone,
    required this.type,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
  });

  LatLng get position => LatLng(latitude, longitude);
}

class MapboxMapWidget extends StatefulWidget {
  final List<CrisisCenter>? centers;
  final void Function(CrisisCenter)? onCenterSelected;
  final String mapStyle;

  const MapboxMapWidget({
    super.key,
    this.centers,
    this.onCenterSelected,
    this.mapStyle = 'streets-v11',
  });

  @override
  State<MapboxMapWidget> createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  late final MapController _mapController;
  LatLng? _currentLocation;
  bool _isLoading = false;
  Timer? _locationUpdateTimer;

  Color _getMarkerColor(String type) {
    switch (type.toLowerCase()) {
      case 'emergency':
        return Colors.red;
      case 'crisis center':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getMarkerIcon(String type) {
    switch (type.toLowerCase()) {
      case 'emergency':
        return Icons.local_hospital;
      case 'crisis center':
        return Icons.support_agent;
      default:
        return Icons.psychology;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone call'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPopup(CrisisCenter center) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(center.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(center.address),
            Text('Distance: ${center.distance}'),
            if (center.isOpen)
              const Text(
                'Open Now',
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _makePhoneCall(center.phone),
              icon: const Icon(Icons.phone),
              label: Text(center.phone),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _hideAllPopups() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position with timeout
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentLocation!, _mapController.camera.zoom);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      setState(() {
        _currentLocation = const LatLng(28.6139, 77.2090); // Default to New Delhi
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    // Periodically update location every 30 seconds
    _locationUpdateTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _getCurrentLocation(),
    );
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation ?? const LatLng(28.6139, 77.2090),
            initialZoom: 13.0,
            onTap: (_, __) => _hideAllPopups(),
          ),
          children: [
            // Base map layer
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
              additionalOptions: {
                'accessToken': const String.fromEnvironment('MAPBOX_ACCESS_TOKEN'),
                'id': widget.mapStyle,
              },
            ),
            // Current location marker
            if (_currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation!,
                    width: 30,
                    height: 30,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ],
              ),
            // Crisis centers markers
            if (widget.centers != null)
              MarkerLayer(
                markers: widget.centers!.map((center) {
                  return Marker(
                    point: center.position,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        widget.onCenterSelected?.call(center);
                        _showPopup(center);
                      },
                      child: Icon(
                        _getMarkerIcon(center.type),
                        color: _getMarkerColor(center.type),
                        size: 30,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
        // Map controls
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                mini: true,
                heroTag: 'location',
                onPressed: _getCurrentLocation,
                child: const Icon(Icons.my_location),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                heroTag: 'zoomIn',
                onPressed: () {
                  var camera = _mapController.camera;
                  _mapController.move(
                    camera.center,
                    camera.zoom + 1,
                  );
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                mini: true,
                heroTag: 'zoomOut',
                onPressed: () {
                  var camera = _mapController.camera;
                  _mapController.move(
                    camera.center,
                    camera.zoom - 1,
                  );
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        // Loading indicator
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}