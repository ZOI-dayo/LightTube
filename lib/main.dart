import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:light_tube/api/ApiKey.dart';
import 'dart:io';

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
  // Object resStr;

  @override
  void initState() {
    super.initState();
    print('hello');
  }

  Future<Map<String, dynamic>> search(String query) async {
    var request = await HttpClient().getUrl(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&relevanceLanguage=ja&key=${ApiKey.key}'));
    request.headers.add('Accept-Encoding', 'gzip');
    request.headers.add('User-Agent', 'my program (gzip)');
    log("03");
    var response = await request.close();
    var responseBodyText = await utf8.decodeStream(response);
    log("01: " +
        json.decode(responseBodyText.toString()).runtimeType.toString());
    // return new Map<String,dynamic>.from(json.decode(responseBodyText.toString()));
    return new Map<String, dynamic>.from(json.decode(responseBodyText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube API'),
      ),
      body: Container(
        child: FutureBuilder(
            future: search('ベノム'),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              log("02 : " + snapshot.toString());
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                if (snapshot.data.containsKey('error')) {
                  List<dynamic> errorList = snapshot.data['error']['errors'];
                  String errorCode = "";
                  for (int i = 0; i < errorList.length; i++) {
                    Map<String, dynamic> errorContent = errorList[i];
                    log("04: "+errorContent.toString());
                    errorCode += errorContent['reason'] + ",";
                  }
                  return Text(
                      "APIでエラーが発生しました。\nエラーコード:$errorCode");
                } else {
                  return Text(snapshot.data['items'][0]['snippet']['title'].toString());
                }
              } else {
                return Text("データの取得に失敗しました");
              }
            }),
      ),
    );
  }
}
