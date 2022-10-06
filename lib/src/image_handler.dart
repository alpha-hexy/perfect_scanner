import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class ImageHandler {
  final BarcodeScanner barcodeScanner = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

  /// Process the captured image from camera or gallery
  ///
  /// It uses the google ml kit for process the image.
  Future<String> processImage(InputImage inputImage) async {
    final barcodes = await barcodeScanner.processImage(inputImage);

    String text = '';
    for (final barcode in barcodes) {
      text += barcode.rawValue ?? '';
    }
    return text;
  }
}
