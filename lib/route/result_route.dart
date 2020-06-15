import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResultRoute extends StatefulWidget {
  final url;

  ResultRoute(this.url);

  @override
  _ResultRouteState createState() => _ResultRouteState(this.url);
}

class _ResultRouteState extends State<ResultRoute> {
  var _url;
  final _key = UniqueKey();

  _ResultRouteState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('당첨 확인'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          key: _key,
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
        );
      }),
    );
  }
}
