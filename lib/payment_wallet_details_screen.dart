import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentWalletDetailsScreen extends StatelessWidget {
  final String meezaQrCode;
  final String meezaReference;

  const PaymentWalletDetailsScreen({
    super.key,
    required this.meezaQrCode,
    required this.meezaReference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Scan this QR Code to Pay:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: meezaQrCode,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Text(
              'Meeza Reference: $meezaReference',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
