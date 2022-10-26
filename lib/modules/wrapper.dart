import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:weather_sample_app/modules/home_page.dart';
import 'package:weather_sample_app/modules/sign_in.dart';
import 'package:weather_sample_app/providers/location_provider.dart';

//this is wrapper class for
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            } else if (snapshot.hasData) {
              return const Wrapper2();
            } else {
              return const SignIn();
            }
          }),
    );
  }
}

//this is wrapper class for the location status
class Wrapper2 extends StatefulWidget {
  const Wrapper2({Key? key}) : super(key: key);
  @override
  State<Wrapper2> createState() => _Wrapper2State();
}

class _Wrapper2State extends State<Wrapper2> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationProvider>().setPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    return Scaffold(
      body: locationProvider.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : locationProvider.locationPermissionStatus
              ? const HomePage()
              : Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Please enable your location setting ${locationProvider.locationPermissionStatus}"),
                          const Gap(10),
                          ElevatedButton(
                            onPressed: () => locationProvider.openSetting(),
                            child: const Text("Click here to enable"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
