

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key? key, required this.title, required this.link}) : super(key: key);

  final String title, link;
  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_sharp),
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: widget.link,
        gestureNavigationEnabled: true,
      ),
    );
  }


}
