import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/device_screan.dart';
import 'package:flutter_bluetooth/main.dart';
import 'package:flutter_bluetooth/provider/bluetooth_provider.dart';
import 'package:provider/provider.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenTwoState();
}

class _BluetoothScreenTwoState extends State<BluetoothScreen> {
  late BluetoothProvider bluetoothProvider;
  
  @override
  void initState() {
    super.initState();
    bluetoothProvider = Provider.of(navKey.currentContext!);
    bluetoothProvider.startScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('BLE Scanner'),
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
        },
        child: Consumer<BluetoothProvider>(
          builder: (BuildContext context, bluetooth, Widget? child) {
            return ListView.builder(
              itemCount: bluetooth.devices.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceScreen(
                          device: bluetooth.devices[index],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(bluetooth.devices[index].platformName.isNotEmpty
                        ? bluetooth.devices[index].platformName
                        : "Unknown Device"),
                    subtitle: Text(
                      bluetooth.devices[index].remoteId.toString(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
