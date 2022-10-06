# perfect_scanner

scan qrcode in widget tree.

decode qrcode image from path.

### BEFORE USING THIS PACKAGE SET THE PERMISSION FOR CAMERA AND GALLERY.

### Features

- use `ScannerView` in widget tree to show scan view.
- custom identifiable area.
- decode qrcode from image path by `ScannerController.getQrFromImage`.

### prepare

##### ios
info.list
```
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```
##### android
```xml
<uses-permission android:name="android.permission.CAMERA" />

```

```yaml
perfect_scanner: ^newest
```

```dart
import 'package:perfect_scanner/perfect_scanner.dart';
```

### Usage

- show ScannerView in widget tree

```dart

Container(
  width: 250, 
  height: 250,
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
```
- you can use `ScannerController.resumeScanning()` and `ScannerController.pauseScanning()` resume/pause camera

```dart
ScannerController.resumeScanning();
ScannerController.pauseScanning()
```

- get qrcode string from image path

```dart
String result = await ScannerController.getQrFromImage(imagePath);
```

- toggle flash light
```dart
ScannerController.toggleFlash();
```

# License
MIT License

