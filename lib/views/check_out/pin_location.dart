import 'dart:async';

import 'package:cosmetics/core/logic/helpers/snackbar_helper.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/ui/theme/app_texts/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PinLocationView extends StatefulWidget {
  const PinLocationView({super.key});

  @override
  State<PinLocationView> createState() => _PinLocationViewState();
}

class _PinLocationViewState extends State<PinLocationView> {
  Set<Marker> _markers = {};

  final controller = Completer<GoogleMapController>();

  @override
  void initState() {
    _determinePosition();

    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackbarHelper.showErrorSnackbar('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    final pos = await Geolocator.getCurrentPosition();
    _markers.add(
      Marker(
        markerId: MarkerId('selected_location'),
        position: LatLng(pos.latitude, pos.longitude),
      ),
    );
    setState(() {});
    final googleMapController = await controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.altitude, pos.longitude), zoom: 14),
      ),
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(pos.latitude, pos.longitude),
        ),
      );
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightAppColors.primary800,
        title: Text(
          'Pin Location',
          style: AppTextStyles.font16Medium.copyWith(
            color: LightAppColors.grey0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: LightAppColors.grey0),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          this.controller.complete(controller);
        },
        markers: _markers,
        onTap: (argument) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('selected_location'),
                position: argument,
              ),
            );
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(31.0379463, 31.3805701),
          zoom: 10,
        ),
      ),
    );
  }
}
