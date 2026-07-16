import 'dart:async';

import 'package:flutter/material.dart';

import 'app/qalam_app.dart';
import 'features/splash/presentation/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _warmSplashArtwork();
  runApp(const QalamApp());
}

Future<void> _warmSplashArtwork() async {
  const provider = AssetImage(SplashScreen.assetPath);
  final stream = provider.resolve(ImageConfiguration.empty);
  final completer = Completer<void>();
  late final ImageStreamListener listener;

  listener = ImageStreamListener(
    (image, synchronousCall) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      stream.removeListener(listener);
    },
    onError: (Object error, StackTrace? stackTrace) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      stream.removeListener(listener);
    },
  );

  stream.addListener(listener);
  await completer.future.timeout(
    const Duration(seconds: 2),
    onTimeout: () => stream.removeListener(listener),
  );
}
