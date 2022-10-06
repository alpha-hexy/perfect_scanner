import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfect_scanner/src/image_handler.dart';

class ScannerController {
  static bool _flash = false;

  /// DON'T USE THIS CONTROLLER IN YOUR CODE THIS CONTROLLER IS FOR INTERNAL USE.
  static CameraController controller = CameraController(
    const CameraDescription(
      lensDirection: CameraLensDirection.back,
      name: 'Perfect Scanner',
      sensorOrientation: 90,
    ),
    ResolutionPreset.high,
    enableAudio: false,
  );

  /// Pick the image from gallery and get qr from that.
  ///
  /// Before calling this method gallery permission must be provided, otherwise permission exception will be thrown .
  ///
  /// This function will return a future string as a result
  static Future<String> getQrFromImage() async {
    String qrData = '';
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        final inputImage = InputImage.fromFilePath(file.path);
        return await ImageHandler().processImage(inputImage);
      } else {
        return '';
      }
    } catch (e) {
      log(
        e.toString(),
        name: 'SCANNER',
      );
    }
    return qrData;
  }

  ///Toggle the flash light while scanning.
  ///
  ///It will return a future bool value to know the flash status.
  static Future<bool> toggleFlash() async {
    try {
      if (_flash == false) {
        _flash = true;
        await controller.setFlashMode(FlashMode.torch);
      } else {
        _flash = false;
        await controller.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      log(
        e.toString(),
        name: 'SCANNER',
      );
    }
    return _flash;
  }

  ///It will pause the camera from scanning
  static void pauseScanning() async {
    try {
      await controller.pausePreview();
    } catch (e) {
      log(
        e.toString(),
        name: 'SCANNER',
      );
    }
  }

  ///It will resume the camera from scanning
  static void resumeScanning() async {
    try {
      await controller.resumePreview();
    } catch (e) {
      log(
        e.toString(),
        name: 'SCANNER',
      );
    }
  }
}
