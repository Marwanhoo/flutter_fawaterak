import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/model/payment_method_model.dart';
import 'package:flutter_fawaterak/model/visa_response_model.dart';
import 'package:flutter_fawaterak/screen/payment_wallet_details_screen.dart';
import 'package:flutter_fawaterak/web_view_fawaterak.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Payment Methods",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedMethod = null;
              });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pay Now!",
              style: GoogleFonts.poppins(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "Now you can pay through ",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                children: [
                  TextSpan(
                    text: "Fawaterak",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " or ",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: "\nCash",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Select Method",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            PaymentOptionCard(
              title: "Fawaterak",
              description:
                  "Fawaterak is a PCI Certified online payments \nplatform for MSMEs",
              imageUrl: 'assets/images/fawaterak.png',
              isSelected: selectedMethod == "Fawaterak",
              onTap: () {
                setState(() {
                  selectedMethod = "Fawaterak";
                });
              },
            ),
            const SizedBox(height: 10),
            PaymentOptionCard(
              title: "Cash",
              description: "Pay upon receipt",
              imageUrl: "assets/images/cash.png",
              isSelected: selectedMethod == "Cash",
              onTap: () {
                setState(() {
                  selectedMethod = "Cash";
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Select Payment Method"),
                      ),
                    );
                  } else {
                    if (selectedMethod == "Fawaterak") {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_)=> const FawaterakScreen()),
                      );
                    } else if (selectedMethod == "Cash") {
                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (_)=> const CashScreen()),
                     );
                    }
                  }
                },
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isSelected ? const Color(0xFF8B0000) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.network(
                "https://avatars.githubusercontent.com/u/125823028?v=4",
                height: 120,
                width: 120,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class CashScreen extends StatelessWidget {
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Payment"),
      ),
      body: const Center(
        child: Text("Cash Payment Screen"),
      ),
    );
  }
}






class FawaterakScreen extends StatefulWidget {
  const FawaterakScreen({super.key});

  @override
  State<FawaterakScreen> createState() => _FawaterakScreenState();
}

class _FawaterakScreenState extends State<FawaterakScreen> {
  final String accessToken =
      '42fa7d257e5896a28d9626197a5daa52eb87a1f96482ed468c';
  final String apiUrlGetPaymentMethods =
      'https://staging.fawaterk.com/api/v2/getPaymentmethods';
  final String apiUrlProcessPaymentMethods =
      'https://staging.fawaterk.com/api/v2/invoiceInitPay';


  @override
  void initState() {
    super.initState();
    _fetchAndPay();
  }

  Future<void> _getPaymentMethods() async {
    final dio = Dio(BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }))
      ..interceptors.add(PrettyDioLogger());
    await dio.get(apiUrlGetPaymentMethods);
  }

  Future<void> _processPayment() async {
    final dio = Dio(BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }))
      ..interceptors.add(PrettyDioLogger());

    final requestData = {
      'payment_method_id': 2, // Visa-Mastercard
      'cartTotal': '5000',
      'currency': 'EGP',
      'customer': {
        'first_name': 'Engy',
        'last_name': 'Abdelaziz',
        'email': 'engy@engy.com',
        'phone': '01114621092',
        'address': 'Cairo',
      },
      'redirectionUrls': {
        'successUrl': 'https://dev.fawaterk.com/success',
        'failUrl': 'https://dev.fawaterk.com/fail',
        'pendingUrl': 'https://dev.fawaterk.com/pending',
      },
      'cartItems': [
        {'name': 'Engy Abdelaziz', 'price': '1000', 'quantity': '5'},
      ],
    };

    final response =
    await dio.post(apiUrlProcessPaymentMethods, data: requestData);

    final redirectUrl = response.data['data']['payment_data']['redirectTo'];

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => WebViewFawaterak(url: redirectUrl),
      ),
    );
  }

  Future<void> _fetchAndPay() async {
    try {
      await _getPaymentMethods();
      await _processPayment();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حصل خطأ أثناء الدفع: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}