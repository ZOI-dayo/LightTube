import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_api/youtube_api.dart';

void main() {
  runApp(LightTubeApp());
}

class LightTubeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LightTube on Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LightTubeHomePage(title: 'LightTube Home Page'),
    );
  }
}

class LightTubeHomePage extends StatefulWidget {
  LightTubeHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LightTubeHomePageState createState() => _LightTubeHomePageState();
}

class _LightTubeHomePageState extends State<LightTubeHomePage> {

  YoutubeAPI ytApi = YoutubeAPI(key);
  List<YT_API> ytResult = [];


  ytSearch() async {
    String query = "日本";
    ytResult = await ytApi.search(query);
    // ytResult = await ytApi.nextPage();
    log("Query : " + ytApi.getQuery.toString() + ";");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ytSearch();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube API'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: ytResult.length,
          itemBuilder: (_, int index) => listItem(index),
        ),
      ),
    );
  }

  Widget listItem(index) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Image.network(
              ytResult[index].thumbnail['default']['url'],
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(
                    ytResult[index].title,
                    softWrap: true,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  Text(
                    ytResult[index].channelTitle,
                    softWrap: true,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  Text(
                    ytResult[index].url,
                    softWrap: true,
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
