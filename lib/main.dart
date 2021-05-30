import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Menjadi Programmer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = "https://menjadi-programmer.000webhostapp.com/api.php";
  Future<List<dynamic>> _fecthDataUsers() async {
    final multipartRequest = new http.MultipartRequest('POST', Uri.parse(apiUrl));
    multipartRequest.fields['method'] = 'GetKategori';
    var response = await multipartRequest.send();
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);
    final respStr = await response.stream.bytesToString();
    // return jsonDecode(respStr);
    log('Response : ${respStr}');
    log('status: ${response.statusCode}');
    log('data: ${response.request}');
    return json.decode(respStr)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_sharp),
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.green,
                    Colors.blue
                  ])
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ListKonten(title: '${snapshot.data[index]['nama']}'))
                          );
                        },
                        child: SizedBox(
                          child:new Column(
                            children: [
                              new Text('', style: TextStyle(fontSize: 20),),
                              new Text('${snapshot.data[index]['nama']}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), new Text('', style: TextStyle(fontSize: 20),),
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
        )
      ),
    );
  }
}

class ListKonten extends StatefulWidget {
  ListKonten({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ListKonten createState() => _ListKonten();
}

class _ListKonten extends State<ListKonten> {

  var kontens = [
    {
      "ID": "1",
      "nama": "Belajar HTML Dasar 1",
      "deskripsi": "Pendahuluan mengenai HTML.\r\n\r\n---\r\nIkuti Kelas Online \"Menjadi Seorang FullStack Designer dalam 15 Hari\"\r\nhttp://fullstackdesigner.id\r\n\r\n---\r\nBeli Hosting & Domain di NIAGAHOSTER\r\nKODE KUPON DISKON 10% : WPUNPAS (gunakan saat checkout)\r\nNiagaHoster : http://bit.ly/2Jx5jDV\r\n\r\n---\r\n\r\nDOWNLOAD SLIDE :\r\nhttp://www.slideshare.net/sandhikagalih\r\n\r\n\r\n---\r\n\r\nhttp://facebook.com/webprogrammingunpas\r\nhttp://codepen.io/webprogrammingunpas/\r\nhttp://twitter.com/sandhikagalih\r\nhttp://instagram.com/sandhikagalih",
      "tipe_konten": "2",
      "link": "https://www.youtube.com/watch?v=NBZ9Ro6UKV8&list=PLFIM0718LjIVuONHysfOK0ZtiqUWvrx4F&index=1",
      "isi_konten": null,
      "foto": null,
      "kategori": "1",
      "created_at": "2021-05-30 12:59:18",
      "created_by": null,
      "updated_at": null,
      "updated_by": null
    },
    {
      "ID": "2",
      "nama": "Tutorial Pemrograman PHP untuk Pemula dari Petani Koding",
      "deskripsi": "PHP adalah bahasa pemrograman yang dirancang khusus untuk membuat web",
      "tipe_konten": "3",
      "link": "https://www.petanikode.com/tutorial/php/",
      "isi_konten": null,
      "foto": null,
      "kategori": "2",
      "created_at": "2021-05-30 12:59:18",
      "created_by": null,
      "updated_at": null,
      "updated_by": null
    },
    {
      "ID": "3",
      "nama": "Belajar Java 1",
      "deskripsi": "Belajar Java",
      "tipe_konten": "1",
      "link": "www.googl.com",
      "isi_konten": "tets",
      "foto": "60b33721cc491.jpeg",
      "kategori": null,
      "created_at": "2021-05-30 13:56:33",
      "created_by": "12",
      "updated_at": null,
      "updated_by": null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.arrow_back_ios_sharp),
          title: Text(widget.title),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.blue,
                      Colors.green
                    ])
            ),
          ),
        ),
        body: Container(
          child: ListView(
            children: kontens.map((nama) {
              return new  Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  child: SizedBox(
                    child:new Column(
                      children: [
                        new Text(
                          '',
                          style: TextStyle(fontSize: 20),
                        ),
                        new Text(
                          '${nama['nama']}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          '',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )

    );
  }
}
