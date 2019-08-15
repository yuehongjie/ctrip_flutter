import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }

}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return WebView(
      url: 'http://m.ctrip.com/webapp/myctrip/',
      hideAppBar: true,
      backForbid: true,
      statusBarColor: '4c5bca',
    );
  }

}