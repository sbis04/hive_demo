import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

main() async {
  // Initialize hive
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();
  final encryprionKey = await secureStorage.read(key: 'key');

  if (encryprionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }

  final key = await secureStorage.read(key: 'key');
  final encryptionKey = base64Url.decode(key!);
  print('Encryption key: $encryptionKey');

  await Hive.openBox<String>(
    'securedBox',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: EncryptedBoxTest(),
    );
  }
}

class EncryptedBoxTest extends StatefulWidget {
  const EncryptedBoxTest({Key? key}) : super(key: key);

  @override
  State<EncryptedBoxTest> createState() => _EncryptedBoxTestState();
}

class _EncryptedBoxTestState extends State<EncryptedBoxTest> {
  late final Box<String> encryptedBox;
  String? data = '';

  _getData() {
    setState(() {
      data = encryptedBox.get('secret');
    });
    log('Fetched data');
  }

  _putData() async {
    await encryptedBox.put('secret', 'Test secret key');
    log('Stored data');
  }

  @override
  void initState() {
    encryptedBox = Hive.box<String>('securedBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$data'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _getData,
                  child: Text('Get'),
                ),
                ElevatedButton(
                  onPressed: _putData,
                  child: Text('Store'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
