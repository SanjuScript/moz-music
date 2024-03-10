// import 'dart:developer';

// import 'package:bluetooth_state/bluetooth_state.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:permission_handler/permission_handler.dart';

// class BluetoothFunction {
//   // static final BluetoothState bluetoothState = BluetoothState();
//   static final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
//   static Future<bool> get isBluetoothEnable async {
//     return true;
//   }

//   static Future<void> requestDisableBluetooth() async {}

//   static void requestBluetoothPermission() async {
//     PermissionStatus status = await Permission.bluetoothConnect.request();
//     if (status.isGranted) {
//       print('Bluetooth permission granted.');
//       // Perform Bluetooth operations here
//     } else {
//       print('Bluetooth permission denied.');
//       // Handle denied permission
//     }
//   }
// }
