import 'package:cosmetics/core/logic/helpers/app_navigator.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/check_out/pin_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectionGoogleMapsCard extends StatelessWidget {
  const SelectionGoogleMapsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.showDropdown,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool showDropdown;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFF73B9BB), width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 60.h,
            width: 100.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: GestureDetector(
                onTap: () {
                  AppNavigator.push(PinLocationView());
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(31.0379463, 31.3805701),
                      zoom: 10,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId('mansoura_location'),
                        position: LatLng(31.0379463, 31.3805701),
                        infoWindow: InfoWindow(
                          title: 'Home',
                          snippet: 'Mansoura, 14 Forsaid St',
                        ),
                      ),
                    },
                  ),
                ),
              ),
            ),
          ),
          12.w.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          if (showDropdown)
            const Icon(Icons.expand_more, color: Color(0xFFE91E63), size: 24),
        ],
      ),
    );
  }
}
