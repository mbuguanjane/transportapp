import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Future getCurrentLocation() async {
    bool ServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!ServiceEnabled) {
      print(Future.error("Location Service disabled"));
    }
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission == await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     print(Future.error("Location Permission Denied"));
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //   print(Future.error("Location Permission Denied"));
    // }
    // var location = await Geolocator.getCurrentPosition();
    // print(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
