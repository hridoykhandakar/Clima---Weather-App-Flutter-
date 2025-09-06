import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationMessage = "Location not fetched Yet";
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.lowest,
    distanceFilter: 1000,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text('Get Location'),
            ),
          ),
          Text(locationMessage),
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceENabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceENabled) {
        setState(() {
          locationMessage = "Location services are disable";
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationMessage = "Location permission denied";
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = 'Location permissions are permanently denied';
        });
        return;
      }
      // Get current position

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      setState(() {
        locationMessage =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = 'error';
      });
    }
  }
}

// ================================================
