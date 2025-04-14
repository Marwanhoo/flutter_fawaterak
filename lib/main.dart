import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/screen/my_home_page.dart';
import 'package:flutter_fawaterak/screen/second_my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SecondMyHomePage(),
    );
  }
}



/*
add permission
ios
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>

 */