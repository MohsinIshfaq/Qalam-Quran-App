import 'dart:async';

import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  static const Duration minimumDisplayDuration = Duration(milliseconds: 1100);

  bool _isOpeningApp = false;

  @override
  void onReady() {
    super.onReady();
    unawaited(_openApp());
  }

  Future<void> _openApp() async {
    if (_isOpeningApp) {
      return;
    }

    _isOpeningApp = true;
    await Future<void>.delayed(minimumDisplayDuration);

    if (!isClosed) {
      await (Get.offAllNamed<dynamic>(AppRoutes.lineSelection) ??
          Future<dynamic>.value());
    }
  }
}
