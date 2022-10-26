import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:weather_sample_app/providers/auth_provider.dart';
import 'package:weather_sample_app/utils/lottie_loader.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(20),
            const LottieLoader(
              lottieAsset: "assets/lottie/logo.json",
              height: 300,
              width: 300,
              repeat: false,
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      color: Colors.redAccent,
                    )),
                onPressed: () => context.read<AuthProvider>().googleLogin(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Google Sign In",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Gap(10),
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.redAccent,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
