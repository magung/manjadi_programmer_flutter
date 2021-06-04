import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:menjadi_programmer/webview_page.dart';
import 'package:menjadi_programmer/youtubeview_page.dart';

import 'ad_helper.dart';
import 'htmlview_page.dart';

class ListKonten extends StatefulWidget {
  ListKonten({Key? key, required this.title, required this.kategori})
      : super(key: key);
  final String title, kategori;

  @override
  _ListKonten createState() => _ListKonten();
}

class _ListKonten extends State<ListKonten> {
  late BannerAd _ad;
  bool _isAdLoaded = false;
  var dataKonten = [];
  var loading = true;
  final String apiUrl = "https://menjadi-programmer.000webhostapp.com/api.php";

  _fecthDataKonten() async {
    final multipartRequest =
        new http.MultipartRequest('POST', Uri.parse(apiUrl));
    multipartRequest.fields['method'] = 'GetKonten';
    multipartRequest.fields['kategori'] = widget.kategori;
    var response = await multipartRequest.send();
    final respStr = await response.stream.bytesToString();
    setState(() {
      dataKonten = json.decode(respStr)['data'];
      loading = false;
    });
  }

  void _refreshKonten() {
    _fecthDataKonten();
  }

  _fetchData() async {
    return dataKonten;
  }

  @override
  void initState() {
    // initializing states
    setState(() {
      loading = true;
    });
    _fecthDataKonten();
    super.initState();

    // COMPLETE: Create a BannerAd instance
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // COMPLETE: Load an ad
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_sharp),
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              _refreshKonten();
            });
          },
          child: Stack(
            children: [
              FutureBuilder(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (!loading) {
                    return ListView.builder(
                      itemCount: dataKonten.length,
                      padding: EdgeInsets.only(
                          top: 10, right: 10, left: 10, bottom: 85),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                if (dataKonten[index]['tipe_konten'] == '3') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebViewScreen(
                                                title:
                                                    '${dataKonten[index]['nama']}',
                                                link:
                                                    '${dataKonten[index]['link']}',
                                              )));
                                } else if (dataKonten[index]['tipe_konten'] ==
                                    '2') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YoutubeAppDemo(
                                              title:
                                                  '${dataKonten[index]['nama']}',
                                              deskripsi:
                                                  '${dataKonten[index]['deskripsi']}',
                                              link:
                                                  '${dataKonten[index]['link']}')));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailKonten(
                                                title:
                                                    '${dataKonten[index]['nama']}',
                                                konten:
                                                    '${dataKonten[index]['isi_konten']}',
                                              )));
                                }
                              },
                              child: SizedBox(
                                child: new Column(
                                  children: [
                                    new Text(
                                      '',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    new Text(
                                      '${dataKonten[index]['nama']}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                    new Text(
                                      '',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Align(
                alignment: Alignment(0.9, 1),
                child: Container(
                  child: AdWidget(ad: _ad),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  alignment: Alignment.center,
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _ad.dispose();

    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    log("ADS  : " + MobileAds.instance.initialize().toString());
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
