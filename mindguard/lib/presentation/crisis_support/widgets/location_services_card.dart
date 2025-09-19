import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationServicesCard extends StatefulWidget {
  final VoidCallback? onFindNearbyHelp;

  const LocationServicesCard({
    super.key,
    this.onFindNearbyHelp,
  });

  @override
  State<LocationServicesCard> createState() => _LocationServicesCardState();
}

class _LocationServicesCardState extends State<LocationServicesCard> {
  GoogleMapController? _mapController;
  bool _isMapExpanded = false;

  // Mock nearby crisis centers data
  final List<Map<String, dynamic>> _nearbyCenters = [
    {
      "name": "University Counseling Center",
      "address": "123 Campus Drive, University City",
      "distance": "0.5 miles",
      "phone": "(555) 123-4567",
      "type": "Counseling",
      "isOpen": true,
      "position": const LatLng(37.7749, -122.4194),
    },
    {
      "name": "Crisis Support Center",
      "address": "456 Main Street, Downtown",
      "distance": "1.2 miles",
      "phone": "(555) 987-6543",
      "type": "Crisis Center",
      "isOpen": true,
      "position": const LatLng(37.7849, -122.4094),
    },
    {
      "name": "General Hospital Emergency",
      "address": "789 Health Blvd, Medical District",
      "distance": "2.1 miles",
      "phone": "(555) 911-0000",
      "type": "Emergency",
      "isOpen": true,
      "position": const LatLng(37.7649, -122.4294),
    },
  ];

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> _createMarkers() {
    return _nearbyCenters.map((center) {
      return Marker(
        markerId: MarkerId(center["name"] as String),
        position: center["position"] as LatLng,
        infoWindow: InfoWindow(
          title: center["name"] as String,
          snippet: center["address"] as String,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          center["type"] == "Emergency"
              ? BitmapDescriptor.hueRed
              : center["type"] == "Crisis Center"
                  ? BitmapDescriptor.hueOrange
                  : BitmapDescriptor.hueBlue,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find Nearby Help",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        "Crisis centers and emergency services",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Toggle Map Button
                IconButton(
                  onPressed: () {
                    setState(() => _isMapExpanded = !_isMapExpanded);
                    widget.onFindNearbyHelp?.call();
                  },
                  icon: CustomIconWidget(
                    iconName: _isMapExpanded ? 'expand_less' : 'map',
                    color: colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Map View (when expanded)
          if (_isMapExpanded) ...[
            Container(
              height: 30.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.7749, -122.4194),
                    zoom: 13.0,
                  ),
                  markers: _createMarkers(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Nearby Centers List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _nearbyCenters.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final center = _nearbyCenters[index];
              return Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Type Icon
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: center["type"] == "Emergency"
                            ? colorScheme.error.withValues(alpha: 0.1)
                            : center["type"] == "Crisis Center"
                                ? Colors.orange.withValues(alpha: 0.1)
                                : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: center["type"] == "Emergency"
                              ? 'local_hospital'
                              : center["type"] == "Crisis Center"
                                  ? 'support_agent'
                                  : 'psychology',
                          color: center["type"] == "Emergency"
                              ? colorScheme.error
                              : center["type"] == "Crisis Center"
                                  ? Colors.orange
                                  : colorScheme.primary,
                          size: 5.w,
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Center Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  center["name"] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (center["isOpen"] as bool) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    "Open",
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.tertiary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            center["address"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'directions',
                                color: colorScheme.primary,
                                size: 3.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                center["distance"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Call Button
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Handle call action
                        },
                        icon: CustomIconWidget(
                          iconName: 'phone',
                          color: colorScheme.primary,
                          size: 5.w,
                        ),
                        tooltip: 'Call ${center["name"]}',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
