import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/bluetooth_screen.dart';
import 'package:flutter_bluetooth/provider/bluetooth_provider.dart';
import 'package:provider/provider.dart';
GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => BluetoothProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const BluetoothScreen(),
    );
  }
}
