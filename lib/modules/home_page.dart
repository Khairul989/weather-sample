import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_sample_app/providers/auth_provider.dart';
import 'dart:async';

import 'package:weather_sample_app/providers/location_provider.dart';
import 'package:weather_sample_app/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  share({required String weather, required String state}) async {
    FlutterShare.share(
        title: "Weather report", text: "Weather in $state is $weather");
  }

  @override
  Widget build(BuildContext context) {
    final locationWatch = context.watch<LocationProvider>();
    final weatherWatch = context.watch<WeatherProvider>();
    final userProvider = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userProvider.currentUser.photoURL!),
            ),
            const Gap(10),
            Text('Welcome ${userProvider.currentUser.displayName}'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            splashRadius: 20,
            onPressed: () => showLogoutDialog(userProvider),
          )
        ],
      ),
      body: locationWatch.getCurrentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: context.read<WeatherProvider>().getCurrentWeather(
                  lat: context
                      .read<LocationProvider>()
                      .getCurrentPosition!
                      .latitude,
                  lng: context
                      .read<LocationProvider>()
                      .getCurrentPosition!
                      .longitude),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          locationWatch.getCurrentPosition!.latitude,
                          locationWatch.getCurrentPosition!.longitude,
                        ),
                        zoom: 17,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("me"),
                          position: LatLng(
                              locationWatch.getCurrentPosition!.latitude,
                              locationWatch.getCurrentPosition!.longitude),
                        ),
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade600.withOpacity(0.5),
                              ),
                              child: Text(
                                "${weatherWatch.weatherInfo['weather']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade600.withOpacity(0.5),
                              ),
                              child: Text(
                                "${weatherWatch.weatherInfo['weather_description']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade600.withOpacity(0.5),
                              ),
                              child: Text(
                                "${weatherWatch.weatherInfo['state']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => share(
            weather: weatherWatch.weatherInfo["weather"],
            state: weatherWatch.weatherInfo["state"]),
        child: const FaIcon(
          FontAwesomeIcons.share,
        ),
      ),
    );
  }

  showLogoutDialog(final userProvider) {
    return showDialog(
        context: context,
        builder: (newContext) {
          return AlertDialog(
            title: const Text(
              "Logout confirmation",
              textAlign: TextAlign.center,
            ),
            content: const Text(
              "Are sure to logout?",
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(newContext),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        userProvider.logout();
                        Navigator.pop(newContext);
                      },
                      child: const Text("Log Out"),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}
