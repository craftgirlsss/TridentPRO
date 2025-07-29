import 'package:permission_handler/permission_handler.dart';

class PermissionHandlers {
  static Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = {};
    if ((await Permission.photos.status).isDenied || (await Permission.videos.status).isDenied) {
      statuses[Permission.photos] = await Permission.photos.request();
      statuses[Permission.videos] = await Permission.videos.request();
    } else if ((await Permission.storage.status).isDenied) {
      statuses[Permission.storage] = await Permission.storage.request();
    } else if ((await Permission.photos.status).isDenied) {
      statuses[Permission.photos] = await Permission.photos.request();
    }
    statuses[Permission.notification] = await Permission.notification.request();
    statuses[Permission.locationWhenInUse] = await Permission.locationWhenInUse.request();
  }
}