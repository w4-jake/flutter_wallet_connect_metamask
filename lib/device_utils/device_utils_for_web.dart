// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart';

// NOTE: `defaultTargetPlatform` evaluates to `TargetPlatform.linux` for some
// cases of browser use on an Android device.
final RegExp androidCaseInsensitiveRegExp = RegExp(
  'Android',
  caseSensitive: false,
);

class DeviceUtils {
  static bool isNative() => false;

  static bool isAndroidWeb() =>
      defaultTargetPlatform == TargetPlatform.android ||
      androidCaseInsensitiveRegExp.hasMatch(window.navigator.userAgent);

  static bool isIosWeb() => defaultTargetPlatform == TargetPlatform.iOS;

  static bool isPcWeb() =>
      !DeviceUtils.isAndroidWeb() && !DeviceUtils.isIosWeb();

  static String deviceLabel() => isAndroidWeb()
      ? 'Web browser (Android)'
      : isIosWeb()
          ? 'Web browser (iOS)'
          : 'Web browser (PC)';
}
