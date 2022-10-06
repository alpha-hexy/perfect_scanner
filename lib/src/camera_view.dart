import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:perfect_scanner/src/image_handler.dart';
import 'package:perfect_scanner/src/scanner_controller.dart';
import 'overlay.dart';

/// Widget for scanner.
///
/// It uses `camera` package to capture the qr and google ml kit for process the image.
class ScannerView extends StatefulWidget {
  const ScannerView({
    Key? key,
    required this.onScan,
    this.qrOverlay,
  }) : super(key: key);

  /// Overlay for qr widget
  final QrOverlay? qrOverlay;

  /// This function will return a string from the captured qr code from camera.
  final Function(String inputImage) onScan;

  @override
  ScannerViewState createState() => ScannerViewState();
}

class ScannerViewState extends State<ScannerView> {
  List<CameraDescription> cameras = [];
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;

  CameraLensDirection cameraLensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    getCamera().then((value) {
      if (cameras.any(
        (element) => element.sensorOrientation == 90,
      )) {
        _cameraIndex = cameras.indexOf(
          cameras.firstWhere((element) => element.sensorOrientation == 90),
        );
      }
      startLiveFeed();
    });
  }

  @override
  void dispose() async {
    disposeControllers();
    super.dispose();
  }

  /// Disposing the camera controllers.
  void disposeControllers() async {
    try {
      await ScannerController.controller.dispose();
      await ImageHandler().barcodeScanner.close();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// To get the available cameras from camera library
  Future<void> getCamera() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(ScannerController.controller),
            ),
            if (widget.qrOverlay != null)
              Center(
                child: Container(
                  decoration: ShapeDecoration(
                    shape: widget.qrOverlay!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Starting the image process as soon as camera captured any barcode
  Future startLiveFeed() async {
    CameraDescription camera = cameras[_cameraIndex];
    ScannerController.controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    setState(() {});
    ScannerController.controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      ScannerController.controller.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      ScannerController.controller.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });

      setState(() {});
      ScannerController.controller.startImageStream((value) {
        processCameraImage(value);
      });
    });
  }

  /// Process the image from the camera and get the qr from it, and it will attach the detected qr to `onScan` function.
  Future processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return;

    final imageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (imageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final imageData = InputImageData(
      size: imageSize,
      imageRotation: rotation,
      inputImageFormat: imageFormat,
      planeData: planeData,
    );

    final img = InputImage.fromBytes(bytes: bytes, inputImageData: imageData);

    widget.onScan(await ImageHandler().processImage(img));
  }
}
