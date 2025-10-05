import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/mapbox_map_widget.dart';

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
  bool _isMapExpanded = false;

  // Mock nearby crisis centers data
  final List<CrisisCenter> _nearbyCenters = [
    CrisisCenter(
      name: "University Counseling Center",
      address: "123 Campus Drive, University City",
      distance: "0.5 miles",
      phone: "(555) 123-4567",
      type: "Counseling",
      isOpen: true,
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    CrisisCenter(
      name: "Crisis Support Center",
      address: "456 Main Street, Downtown",
      distance: "1.2 miles",
      phone: "(555) 987-6543",
      type: "Crisis Center",
      isOpen: true,
      latitude: 37.7849,
      longitude: -122.4094,
    ),
    CrisisCenter(
      name: "General Hospital Emergency",
      address: "789 Health Blvd, Medical District",
      distance: "2.1 miles",
      phone: "(555) 911-0000",
      type: "Emergency",
      isOpen: true,
      latitude: 37.7649,
      longitude: -122.4294,
    ),
    CrisisCenter(
      name: "Mental Health Clinic",
      address: "321 Wellness Ave, Midtown",
      distance: "1.8 miles",
      phone: "(555) 456-7890",
      type: "Crisis Center",
      isOpen: true,
      latitude: 37.7849,
      longitude: -122.4094,
    ),
    CrisisCenter(
      name: "Community Emergency Services",
      address: "987 Help Street, Downtown",
      distance: "2.5 miles",
      phone: "(555) 999-8888",
      type: "Emergency",
      isOpen: true,
      latitude: 37.7649,
      longitude: -122.4294,
    ),
  ];

  // Map functions will be handled by the MapboxMapWidget

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
          color: colorScheme.outline.withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
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
                child: MapboxMapWidget(
                  centers: _nearbyCenters,
                  onCenterSelected: (center) {
                    // Scroll to the selected center in the list
                    final index = _nearbyCenters.indexOf(center);
                    if (index != -1) {
                      // You might want to implement scrolling to the selected item
                    }
                  },
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
                        color: center.type == "Emergency"
                            ? colorScheme.error.withValues(alpha: 0.1)
                            : center.type == "Crisis Center"
                                ? Colors.orange.withValues(alpha: 0.1)
                                : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: center.type == "Emergency"
                              ? 'local_hospital'
                              : center.type == "Crisis Center"
                                  ? 'support_agent'
                                  : 'psychology',
                          color: center.type == "Emergency"
                              ? colorScheme.error
                              : center.type == "Crisis Center"
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
                                  center.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (center.isOpen) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        colorScheme.tertiary.withOpacity(0.1),
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
                            center.address,
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
                                center.distance,
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
                        onPressed: () async {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: center.phone.replaceAll(RegExp(r'[^\d]'), ''),
                          );
                          try {
                            if (await canLaunchUrl(launchUri)) {
                              await launchUrl(launchUri);
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Could not launch phone call'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        },
                        icon: CustomIconWidget(
                          iconName: 'phone',
                          color: colorScheme.primary,
                          size: 5.w,
                        ),
                        tooltip: 'Call ${center.name}',
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
