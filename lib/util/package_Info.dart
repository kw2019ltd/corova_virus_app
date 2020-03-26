import 'package:package_info/package_info.dart';

String appName;
String packageName;
String version;
String buildNumber;

Future<void> initPackageInfo() async =>
    PackageInfo.fromPlatform().then((packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
