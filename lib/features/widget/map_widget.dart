import 'dart:async';

import 'package:evently/core/constants/app_colors.dart';
import 'package:evently/features/cubit/Event_Cubit.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class MapWidget extends StatefulWidget {
  final EventCubit eventCubit;
  const MapWidget({super.key, required this.eventCubit});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    getLocation()
        .then((value) {
          if (mounted) setState(() {});
        })
        .catchError((e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error loading map: $e')));
          }
        });
    super.initState();
  }

  bool isDetect = false;
  LocationData? locationData;
  Set<Marker> markers = {};
  late GoogleMapController googleMapController;
  LatLng? selectedPosition;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: $errorMessage',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        errorMessage = null;
                        locationData = null;
                      });
                      getLocation().then((value) {
                        if (mounted) setState(() {});
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : locationData == null
          ? Center(child: CircularProgressIndicator(color: AppColors.purple))
          : Stack(
              children: [
                GoogleMap(
                  markers: markers,
                  onMapCreated: (controller) {
                    googleMapController = controller;
                  },
                  onTap: (position) {
                    try {
                      googleMapController.animateCamera(
                        CameraUpdate.newLatLng(position),
                      );
                      markers.clear();
                      markers.add(
                        Marker(markerId: MarkerId('1'), position: position),
                      );
                      selectedPosition = position;
                      widget.eventCubit.changeLocation(position);
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      locationData!.latitude!,
                      locationData!.longitude!,
                    ),
                    zoom: 15,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            errorMessage = 'Location service is disabled';
          });
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            errorMessage = 'Location permission denied';
          });
          return;
        }
      }

      isDetect = true;
      locationData = await location.getLocation();

      if (locationData != null &&
          locationData!.latitude != null &&
          locationData!.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(locationData!.latitude!, locationData!.longitude!),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Could not retrieve location data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
}
