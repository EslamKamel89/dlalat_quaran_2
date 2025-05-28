import 'package:dlalat_quaran_new/dialogs/custom_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';

Future getPermissionRequest() async {
  var status = await Permission.storage.request();
  handlePermission(status, 'Storage Permission');
  status = await Permission.sms.request();
  handlePermission(status, 'SMS Permission');
  status = await Permission.camera.request();
  handlePermission(status, 'Camera Permission');
  status = await Permission.mediaLibrary.request();
  handlePermission(status, 'Media Library Permission');
  status = await Permission.locationWhenInUse.request();
  handlePermission(status, 'Location When In Use Permission');
}

handlePermission(PermissionStatus status, title) {
  if (status.isGranted) {
    // Permission granted, proceed with your logic
    showCustomSnackBar(title: title, body: 'Access granted', isSuccess: true);
  } else if (status.isDenied) {
    showCustomSnackBar(title: title, body: 'Access Denied', isSuccess: false);
    // openAppSettings();
  } else if (status.isPermanentlyDenied) {
    showCustomSnackBar(title: title, body: 'Access Permanently Denied', isSuccess: false);
    openAppSettings();
  }
}
