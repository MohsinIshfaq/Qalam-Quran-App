import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  static const String assetPath = 'assets/images/splash/qalam_splash.png';
  static const Color backgroundColor = Color(0xFF001D17);
  static const double artworkAspectRatio = 853 / 1844;

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(backgroundColor: backgroundColor, body: _SplashArtwork()),
    );
  }
}

class _SplashArtwork extends StatelessWidget {
  const _SplashArtwork();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportAspectRatio =
            constraints.maxWidth / constraints.maxHeight;
        final useContainedArtwork =
            viewportAspectRatio > SplashScreen.artworkAspectRatio * 1.22;

        return RepaintBoundary(
          child: SizedBox.expand(
            child: Image.asset(
              SplashScreen.assetPath,
              fit: useContainedArtwork ? BoxFit.contain : BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
              semanticLabel:
                  'Qalam. Your Quran. Your Connection. One Quran, three layouts.',
            ),
          ),
        );
      },
    );
  }
}
