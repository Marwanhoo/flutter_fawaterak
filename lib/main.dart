import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/screen/my_home_page.dart';
import 'package:flutter_fawaterak/screen/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentScreen(),
    );
  }
}
