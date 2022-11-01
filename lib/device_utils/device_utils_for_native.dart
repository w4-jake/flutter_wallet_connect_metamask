class DeviceUtils {
  static bool isNative() => true;
  static bool isAndroidWeb() => false;
  static bool isIosWeb() => false;
  static bool isPcWeb() => false;
  static String deviceLabel() => 'Native Device';
}
