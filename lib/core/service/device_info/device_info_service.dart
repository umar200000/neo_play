// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
//
// class DeviceInfoService {
//   static final DeviceInfoService _instance = DeviceInfoService._internal();
//   factory DeviceInfoService() => _instance;
//   DeviceInfoService._internal();
//
//   final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
//
//   Future<Map<String, dynamic>> getDeviceData() async {
//     try {
//       if (Platform.isAndroid) {
//         final info = await _deviceInfo.androidInfo;
//         return {
//           'platform': 'android',
//           'model': info.model,
//           'manufacturer': info.manufacturer,
//           'device': info.device,
//           'brand': info.brand,
//           'product': info.product,
//           'version_sdk': info.version.sdkInt,
//           'version_release': info.version.release,
//           'android_id': info.id,
//           'is_physical_device': info.isPhysicalDevice,
//         };
//       } else if (Platform.isIOS) {
//         final info = await _deviceInfo.iosInfo;
//         return {
//           'platform': 'ios',
//           'name': info.name,
//           'system_name': info.systemName,
//           'system_version': info.systemVersion,
//           'model': info.model,
//           'localized_model': info.localizedModel,
//           'identifier_for_vendor': info.identifierForVendor,
//           'is_physical_device': info.isPhysicalDevice,
//         };
//       } else {
//         return {
//           'platform': 'unknown',
//           'message': 'Platform not supported',
//         };
//       }
//     } catch (e) {
//       return {
//         'platform': 'error',
//         'error': e.toString(),
//       };
//     }
//   }
// }
