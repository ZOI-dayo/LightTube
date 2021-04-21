import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  int _counter = 0;
  WebViewController _controller;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview Demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('webviewの上に表示'),
                    );
                  });
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'https://youtube.com',
        // initialUrl: 'assets/youtube.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) async {
          _controller = controller;
          // await _loadHtmlFromAssets();
          /*_controller.evaluateJavascript(
              "window.onload = function() {getData.postMessage(\"あああ\");};");

           */
        },
        onPageStarted: (String str) {
          _controller.evaluateJavascript(
              "getData.postMessage(\"あああ\");");
        },
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: "getData",
              onMessageReceived: (JavascriptMessage result) {
                // イベントが発動した時に呼び出したい関数
                log(result.message);
                return "";
              }),
        ]),
      ),
    );
  }

  Future _loadHtmlFromAssets() async {
    //　HTMLファイルを読み込んでHTML要素を文字列で返す
    String fileText = await rootBundle.loadString('assets/youtube.html');
    // <WebViewControllerのloadUrlメソッドにローカルファイルのURI情報を渡す>
    // WebViewControllerはWebViewウィジェットに情報を与えることができます。
    // <Uri.dataFromStringについて>
    // パラメータで指定されたエンコーディングまたは文字セット（指定されていないか認識されない場合はデフォルトでUS-ASCII）
    // を使用してコンテンツをバイトに変換し、結果のデータURIにバイトをエンコードします。
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
