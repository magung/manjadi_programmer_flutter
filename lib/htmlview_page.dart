import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class DetailKonten extends StatefulWidget {
  DetailKonten({Key? key, required this.title, required this.konten})
      : super(key: key);

  final String title, konten;

  @override
  DetailKontenState createState() => DetailKontenState();
}

class DetailKontenState extends State<DetailKonten> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.arrow_back_ios_sharp),
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Html(
                data: widget.konten,
                onLinkTap: (String? url, RenderContext context,
                    Map<String, String> attributes, dom.Element? element) {
                  launch(
                    url!,
                    forceSafariVC: true,
                    forceWebView: true,
                    enableJavaScript: true,
                  );
                })));
  }
}
