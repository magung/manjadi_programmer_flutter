import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import 'ad_helper.dart';
import 'list_konten_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BannerAd _ad;
  bool _isAdLoaded = false;
  var dataKategori = [];
  var loading = true;
  final String apiUrl = "https://menjadi-programmer.000webhostapp.com/api.php";

  _fecthDataKategori() async {
    final multipartRequest =
        new http.MultipartRequest('POST', Uri.parse(apiUrl));
    multipartRequest.fields['method'] = 'GetKategori';
    var response = await multipartRequest.send();
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);
    final respStr = await response.stream.bytesToString();
    // return jsonDecode(respStr);
    // log('Response : ${respStr}');
    // log('status: ${response.statusCode}');
    // log('data: ${response.request}');
    // log(" fetch kategori");
    setState(() {
      dataKategori = json.decode(respStr)['data'];
      loading = false;
    });
    // return json.decode(respStr)['data'];
  }

  _refreshKategori() async {
    // log("REfreshing kategori");
    _fecthDataKategori();
  }

  _fetchData() async {
    // log("fetch data");
    return dataKategori;
  }

  @override
  void initState() {
    // initializing states
    setState(() {
      loading = true;
    });
    _fecthDataKategori();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_sharp),
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        child: Stack(
          children: [
            FutureBuilder(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (!loading) {
                  return ListView.builder(
                    itemCount: dataKategori.length,
                    padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 80),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListKonten(
                                        title: '${dataKategori[index]['nama']}',
                                        kategori:
                                        '${dataKategori[index]['ID']}',
                                      )));
                            },
                            child: SizedBox(
                              child: new Column(
                                children: [
                                  new Text(
                                    '',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  new Text(
                                    '${dataKategori[index]['nama']}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
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
        ),
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            // log("REFRESH");
            _refreshKategori();
          });
        },
      ),
    );
  }
}
