import 'package:flutter/material.dart';
import 'package:flutter_fawaterak/failure_screen.dart';
import 'package:flutter_fawaterak/pending_screen.dart';
import 'package:flutter_fawaterak/success_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewFawaterak extends StatefulWidget {
  const WebViewFawaterak({super.key, required this.url});

 final String url;

  @override
  State<WebViewFawaterak> createState() => _WebViewFawaterakState();
}

class _WebViewFawaterakState extends State<WebViewFawaterak> {
  late WebViewController controller;
  bool isLoading = false; // track loading state


  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }

            if(request.url.contains("https://dev.fawaterk.com/success")){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const SuccessScreen()));
              return NavigationDecision.prevent;
            }else if(request.url.contains("https://dev.fawaterk.com/fail")){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const FailureScreen()));
              return NavigationDecision.prevent;
            }else if(request.url.contains("https://dev.fawaterk.com/pending")){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const PendingScreen()));
              return NavigationDecision.prevent;
            }
             return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: isLoading
          ?WebViewWidget(controller: controller)
          : Center(child: CircularProgressIndicator(),)
      // body: Stack(
      //   children: [
      //     WebViewWidget(controller: controller),
      //     if(isLoading) const Center(child: CircularProgressIndicator()),
      //   ],
      // ),
    );
  }
}
