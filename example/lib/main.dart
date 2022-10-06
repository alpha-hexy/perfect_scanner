import 'package:flutter/material.dart';
import 'package:perfect_scanner/perfect_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    permissionHandler();
    super.initState();
  }

  permissionHandler() async {
    Permission status = Permission.camera;
    await status.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const CamView()));
              },
              child: const Text('Go to'),
            );
          }),
        ),
      ),
    );
  }
}

class CamView extends StatefulWidget {
  const CamView({super.key});

  @override
  State<CamView> createState() => _CamViewState();
}

class _CamViewState extends State<CamView> {
  bool isFlashOn = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final image = await ScannerController.getQrFromImage();
              debugPrint(image);
            },
            icon: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              ScannerController.resumeScanning();
              isFlashOn = await ScannerController.toggleFlash();
              setState(() {});
            },
            icon: Icon(
              isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ScannerView(
          qrOverlay: QrOverlay(
            borderColor: Colors.green,
            borderWidth: 15,
            borderRadius: 10,
            cutOutSize: 300,
          ),
          onScan: (image) {
            if (image.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('QR DATA : $image'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
