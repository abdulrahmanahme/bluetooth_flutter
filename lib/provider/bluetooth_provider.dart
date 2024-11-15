import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/model/message_model.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothProvider extends ChangeNotifier {
  StreamSubscription<BluetoothConnectionState>? subscription;
  String connectButtonText = 'Disconnect';
  String stateText = 'Connecting';
  BluetoothConnectionState deviceState = BluetoothConnectionState.disconnected;

  BluetoothCharacteristic? lastCharacterist;
  StreamSubscription<List<int>>? stream_sub;
  List<Message> buffer = [];
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;

  final TextEditingController controller = TextEditingController();

  void writeData(BluetoothDevice device, String text) async {
    List<BluetoothService> services = await device.discoverServices();

    BluetoothService lastservice = services.last;
    BluetoothCharacteristic lastCharacterist = lastservice.characteristics.last;
    if (controller.text.isNotEmpty || lastCharacterist.properties.write) {
      try {
        List<int> list = utf8.encode(text);

        await lastCharacterist.write(list);

        buffer.add(Message(text, 1));
        notifyListeners();
      } catch (e) {
        print('Error writing to characteristic: $e');
      }
    } else {
      print('This characteristic does not support writing.');
    }
  }

  void readData(BluetoothDevice device) async {
    buffer.clear();
    List<BluetoothService> services = await device.discoverServices();
    BluetoothService lastservice = services.last;
    BluetoothCharacteristic lastCharacterist = lastservice.characteristics.last;

    if ( lastCharacterist.properties.notify) {
        await lastCharacterist.setNotifyValue(true);
      stream_sub = lastCharacterist.onValueReceived.listen((value) async {
        if (value.isNotEmpty) {
          String s = String.fromCharCodes(value);
          buffer.add(Message(s, 0));
          notifyListeners();
        }
      });
    }
  }

  void connect(BluetoothDevice device) async {
    stateText = 'connected';
    connectButtonText = 'disconnect';
    await device.connect();
    notifyListeners();
  }

  void disConnect(BluetoothDevice device) async {
    stateText = 'Disconnected';
    connectButtonText = 'Connect';
    await device.disconnect();
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
  }

  void startScanning() async {
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 15));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          devices.add(result.device);
          notifyListeners();
        }
      }
    });
  }
}
