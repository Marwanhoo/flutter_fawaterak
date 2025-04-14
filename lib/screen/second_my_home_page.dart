import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/model/payment_method_model.dart';
import 'package:flutter_fawaterak/model/visa_response_model.dart';
import 'package:flutter_fawaterak/screen/payment_wallet_details_screen.dart';
import 'package:flutter_fawaterak/web_view_fawaterak.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SecondMyHomePage extends StatefulWidget {
  const SecondMyHomePage({super.key});

  @override
  State<SecondMyHomePage> createState() => _SecondMyHomePageState();
}

class _SecondMyHomePageState extends State<SecondMyHomePage> {
  bool isLoading = false;
  bool isGridView = false; // Toggle between list and grid
  PaymentMethodModel? paymentMethodModel;
  VisaResponseModel? visaResponseModel;

  String accessToken = 'd83a5d07aaeb8442dcbe259e6dae80a3f2e21a3a581e1a5acd';
  String apiUrlGetPaymentMethods = 'https://staging.fawaterk.com/api/v2/getPaymentmethods';
  String apiUrlProcessPaymentMethods = "https://staging.fawaterk.com/api/v2/invoiceInitPay";

  Future<void> getPaymentMethod() async {
    setState(() => isLoading = true);

    Dio dio = Dio(BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }));
    dio.interceptors.add(PrettyDioLogger());

    try {
      Response response = await dio.get(apiUrlGetPaymentMethods);
      paymentMethodModel = PaymentMethodModel.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
    setState(() => isLoading = false);
  }

  Future<void> processPaymentMethod(int paymentMethodId) async {
    Dio dio = Dio(BaseOptions(headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    }));
    dio.interceptors.add(PrettyDioLogger());

    try {
      final requestData = {
        'payment_method_id': paymentMethodId,
        'cartTotal': '500',
        'currency': 'EGP',
        'customer': {
          'first_name': 'test',
          'last_name': 'test',
          'email': 'test@test.test',
          'phone': '01000000000',
          'address': 'test address',
        },
        'redirectionUrls': {
          'successUrl': 'https://dev.fawaterk.com/success',
          'failUrl': 'https://dev.fawaterk.com/fail',
          'pendingUrl': 'https://dev.fawaterk.com/pending',
        },
        'cartItems': [
          {'name': 'test', 'price': '500', 'quantity': '1'},
        ],
      };

      Response response = await dio.post(apiUrlProcessPaymentMethods, data: requestData);
      visaResponseModel = VisaResponseModel.fromJson(response.data);

      if (paymentMethodId == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => WebViewFawaterak(
            url: "${visaResponseModel!.data!.paymentData!.redirectTo}",
          ),
        ));
      } else if (paymentMethodId == 4) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PaymentWalletDetailsScreen(
            meezaQrCode: "${response.data['data']['payment_data']['meezaQrCode']}",
            meezaReference: "${response.data['data']['payment_data']['meezaReference']}",
          ),
        ));
      }
    } on DioException catch (dioError) {
      debugPrint("Dio Error: ${dioError.response?.data ?? dioError.message}");
      throw Exception('Payment failed: ${dioError.message}');
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    final data = paymentMethodModel?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fawaterak"),
        centerTitle: true,

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isGridView
          ? GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3 / 3,
        ),
        itemBuilder: (context, index) {
          final item = data[index];
          return GestureDetector(
            onTap: () => processPaymentMethod(item.paymentId!),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(item.logo!, height: 50),
                  const SizedBox(height: 8),
                  Text(item.nameEn!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.nameAr!),
                ],
              ),
            ),
          );
        },
      )
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            onTap: () => processPaymentMethod(item.paymentId!),
            leading: Image.network(item.logo!),
            title: Text(item.nameEn!),
            subtitle: Text(item.nameAr!),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          isGridView = !isGridView;
        });
      },child: Icon(isGridView ? Icons.view_list : Icons.grid_view),),
    );
  }
}

