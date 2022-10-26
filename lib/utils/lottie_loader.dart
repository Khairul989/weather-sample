import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatefulWidget {
  final String? text;
  final String lottieAsset;
  final double height;
  final double width;
  final bool? repeat;
  const LottieLoader(
      {Key? key,
      this.text,
      required this.lottieAsset,
      required this.height,
      required this.width,
      this.repeat})
      : super(key: key);

  @override
  State<LottieLoader> createState() => _LottieLoaderState();
}

class _LottieLoaderState extends State<LottieLoader> {
  late final Future<LottieComposition> _composition;
  @override
  void initState() {
    super.initState();

    _composition = _loadComposition();
  }

  Future<LottieComposition> _loadComposition() async {
    var assetData = await rootBundle.load(widget.lottieAsset);
    return await LottieComposition.fromByteData(assetData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        var composition = snapshot.data;
        if (composition != null) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(40),
              SizedBox(
                height: widget.height,
                width: widget.width,
                child: Lottie(
                  composition: composition,
                  repeat: widget.repeat == null ? false : true,
                ),
              ),
              if (widget.text != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.text!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
