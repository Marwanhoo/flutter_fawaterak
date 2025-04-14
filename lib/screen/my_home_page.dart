import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/model/payment_method_model.dart';
import 'package:flutter_fawaterak/model/visa_response_model.dart';
import 'package:flutter_fawaterak/screen/payment_wallet_details_screen.dart';
import 'package:flutter_fawaterak/web_view_fawaterak.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  PaymentMethodModel? paymentMethodModel;
  VisaResponseModel? visaResponseModel;
  String accessToken = 'd83a5d07aaeb8442dcbe259e6dae80a3f2e21a3a581e1a5acd';
  //String accessToken = '5f950a6aa7c732822d40fccf84c6cbeea417d5410e8e525c92';
  String apiUrlGetPaymentMethods =
      'https://staging.fawaterk.com/api/v2/getPaymentmethods';
  String apiUrlProcessPaymentMethods =
      "https://staging.fawaterk.com/api/v2/invoiceInitPay";

  Future<void> getPaymentMethod() async {
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    dio.interceptors.add(PrettyDioLogger());
    try {
      Response<dynamic> response = await dio.get(apiUrlGetPaymentMethods);
      paymentMethodModel = PaymentMethodModel.fromJson(response.data);
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> processPaymentMethod(int paymentMethodId) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
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
          {
            'name': 'test',
            'price': '500',
            'quantity': '1',
          },
        ],
      };

      Response<dynamic> response = await dio.post(
        apiUrlProcessPaymentMethods,
        data: requestData,
      );
      visaResponseModel = VisaResponseModel.fromJson(response.data);
      if (paymentMethodId == 2) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WebViewFawaterak(
              url: "${visaResponseModel!.data!.paymentData!.redirectTo}",
            ),
          ),
        );
      }
      if (paymentMethodId == 4) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentWalletDetailsScreen(
              meezaQrCode: "${response.data['data']['payment_data']['meezaQrCode']}",
              meezaReference: "${response.data['data']['payment_data']['meezaReference']}",
            ),
          ),
        );
      }
    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 422) {
        debugPrint("Error 422: ${dioError.response?.data}");
      } else {
        debugPrint("Unexpected error: ${dioError.message}");
      }
    throw Exception('Failed to process payment: ${dioError.message}');
    } catch (e) {
      debugPrint("An unexpected error occurred: $e");
      throw Exception('Failed due to an unexpected error: $e');
    }
  }

  @override
  void initState() {
    getPaymentMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fawaterak"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    processPaymentMethod(
                        paymentMethodModel!.data![index].paymentId!);
                  },
                  title: Text(paymentMethodModel!.data![index].nameEn!),
                  subtitle: Text(paymentMethodModel!.data![index].nameAr!),
                  leading:
                      Image.network(paymentMethodModel!.data![index].logo!),
                );
              },
              itemCount: paymentMethodModel!.data!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
