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
  Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    _data = search('xyxyz');
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
      body: RefreshIndicator(
        onRefresh: () async {
          _data = search('xyxyz');
          setState(() {}); // ★これ！
        },
        child: Container(
          child: FutureBuilder(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                log("02 : " + snapshot.toString());
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return createListWidget(snapshot.data);
                } else {
                  return Text("データの取得に失敗しました");
                }
              }),
        ),
      ),
    );
  }
  Widget createListWidget(Map<String, dynamic> data){
    if (data.containsKey('error')) {
      List<dynamic> errorList = data['error']['errors'];
      String errorCode = "";
      for (int i = 0; i < errorList.length; i++) {
        Map<String, dynamic> errorContent = errorList[i];
        log("04: " + errorContent.toString());
        errorCode += errorContent['reason'] + ",";
      }
      return Text("APIでエラーが発生しました。\nエラーコード:$errorCode");
    } else {
      return ListView.builder(
        itemCount: data['items'].length,
        itemBuilder: (_, int index) => videoItem(
            index,
            data['items'][index]['snippet'],
            data['items'][index]['id']['videoId']),
      );
      // return Text(snapshot.data['items'][0]['snippet']['title'].toString());
    }
  }
  Widget videoItem(int index, Map<String, dynamic> data, String id) {
    log(data.toString());
    return ElevatedButton(
      onPressed: () {
        log(id);
      },
      style:ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
      // color: Colors.white,
      // shape: const OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(0)),
      // ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Image.network(
              data['thumbnails']['default']['url'],
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(
                    data['title'],
                    softWrap: true,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  Text(
                    data['channelTitle'],
                    softWrap: true,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  Text(
                    "https://www.youtube.com/watch?v=" + id,
                    softWrap: true,
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
