import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/main.dart';
import 'package:flutter_bluetooth/provider/bluetooth_provider.dart';
import 'package:flutter_bluetooth/widget/widget.dart';
import 'package:provider/provider.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenTwoState();
}

class _DeviceScreenTwoState extends State<DeviceScreen> {
  late BluetoothProvider bluetoothProvider;

  @override
  void initState() {
    super.initState();
    bluetoothProvider = Provider.of(navKey.currentContext!);
    bluetoothProvider.connect(widget.device);
    bluetoothProvider.readData(widget.device);
  }

  @override
  void dispose() {
    super.dispose();
    bluetoothProvider.subscription!.cancel();
    bluetoothProvider.stream_sub!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<BluetoothProvider>(
          builder: (BuildContext context, bluetoothProvider, Widget? child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${bluetoothProvider.stateText}'),
                    OutlinedButton(
                      onPressed: () {
                        widget.device.connectionState.listen((value) async {
                          if (value == BluetoothConnectionState.connected) {
                            bluetoothProvider.disConnect(widget.device);
                          } else if (value ==
                              BluetoothConnectionState.disconnected) {
                            bluetoothProvider.connect(widget.device);
                          }
                        });
                      },
                      child: Text(
                        bluetoothProvider.connectButtonText,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: bluetoothProvider.buffer.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          color: bluetoothProvider.buffer[index].sender == 1
                              ? Colors.green
                              : Colors.lightBlueAccent,
                          text: bluetoothProvider.buffer[index].text!,
                          isSender: bluetoothProvider.buffer[index].sender == 1
                              ? true
                              : false,
                          textStyle: TextStyle(color: Colors.black),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: bluetoothProvider.controller,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          bluetoothProvider.writeData(
                              widget.device, bluetoothProvider.controller.text);
                          bluetoothProvider.controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
