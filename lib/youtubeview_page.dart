
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeAppDemo extends StatefulWidget {
  YoutubeAppDemo({Key? key, required this.title, required this.deskripsi, required this.link}) : super(key: key);

  final String title, deskripsi, link;
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return OrientationBuilder(
        builder: (context, orientation) {
          // if(orientation == Orientation.landscape) {
          //   return Scaffold(
          //     body: Center(
          //       child: FittedBox(
          //         fit: BoxFit.fitHeight,
          //         child:  youtubePlayer(),
          //       ),
          //     )
          //   );
          // } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child:  youtubePlayer(),
                        ),
                      ),

                      if(orientation != Orientation.landscape)
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child:  Html(
                                data: widget.deskripsi,
                                onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                                  launch(
                                    url!,
                                    forceSafariVC: true,
                                    forceWebView: true,
                                    enableJavaScript: true,
                                  );
                                }
                            )
                        ),
                    ],
                  )
              ));
        }
      // }
    );

  }

  Widget youtubePlayer() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: '${widget.link}',
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            hideThumbnail: true,
            useHybridComposition: false,
          ),
        ),
        liveUIColor: Colors.amber,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Column(
          children: [
            player,
          ],
        );
      },
    );
  }
}
