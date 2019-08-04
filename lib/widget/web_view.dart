
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {

  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid; //是否禁止返回

  const WebView({Key key, this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid = false}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

  final FlutterWebviewPlugin flutterWebview = FlutterWebviewPlugin();
  StreamSubscription<String> _urlChangeListen;
  StreamSubscription<WebViewStateChanged> _stateChangeListen;
  StreamSubscription<WebViewHttpError> _errorListen;

  //这些 url 会返回到携程首页，需要拦截
  static const CATCH_URLS = ['m.ctrip.com/','m.ctrip.com', 'm.ctrip.com/html5/', 'm.ctrip.com/html5',
    'm.ctrip.com/webapp/you/', 'm.ctrip.com/webapp/'];
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    //防止重新打开
    flutterWebview.close();
    //url 变化监听
     _urlChangeListen = flutterWebview.onUrlChanged.listen((String url) {

     });
     //页面加载状态变化监听
    _stateChangeListen = flutterWebview.onStateChanged.listen((WebViewStateChanged state){
      switch (state.type) {
        case WebViewState.startLoad:
          print('load_url: ${state.url}');
          if (_isToMain(state.url) && !_exiting) {
            if (widget.backForbid ?? false) { //禁止返回上一个网页
              flutterWebview.launch(widget.url);
            }else {
              Navigator.pop(context); //返回上一个页面
              _exiting = true; //防止重复返回
            }
          }

          break;

        default:

          break;
      }
    });
    //加载错误监听
    _errorListen = flutterWebview.onHttpError.listen((WebViewHttpError error){
      print(error);
    });

  }
  
  _isToMain(String url) {
    bool isContain = false;
    for(final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        isContain = true;
        break;
      }

    }

    return isContain;
  }

  @override
  void dispose() {

    //取消监听
    _urlChangeListen.cancel();
    _stateChangeListen.cancel();
    _errorListen.cancel();
    //关闭
    flutterWebview.close();
    flutterWebview.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    //状态栏颜色，默认是白色 (RGB)
    final whiteColorStr = 'ffffff';
    String statusBarColorStr = widget.statusBarColor ?? whiteColorStr;
    //如果状态栏是白色，则返回按钮是黑色，否则按钮是白色
    Color backButtonColor = statusBarColorStr == whiteColorStr ? Colors.black : Colors.white;
    //颜色字符串 转换成 Color
    Color statusBarColor = Color(int.parse('0xff$statusBarColorStr'));

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(statusBarColor, backButtonColor),
          //AppBar 下面铺满屏幕
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              hidden: true,
              withLocalStorage: true,

            ),
          ),
        ],
      ),
    );
  }
  
  /*
   * 自定义的 AppBar:
   * 如果要隐藏 AppBar，则只设置状态栏的颜色
   * 如果要显示 AppBar,则自定义 返回 + 标题的 AppBar
   */
  _appBar(Color statusBarColor, Color backButtonColor) {

    //这里的 widget 就是 State.widget 即 State 泛型的对象 即 WebView
    var statusBarHeight= MediaQuery.of(context).padding.top;
    print('statusBarHeight: $statusBarHeight');

    return Column(
      children: <Widget>[
        //填充状态栏
        Container(
          height: statusBarHeight <= 0 ? 30 : statusBarHeight,
          color: statusBarColor,
        ),

        //如果隐藏状态栏则高度为 0 ，否则显示自定义状态栏
        widget.hideAppBar ?? false == true ?
        Container(
          height: 0,
        )
            :
        Container(
          height:50 ,
          color: statusBarColor,
          alignment: AlignmentDirectional.centerStart,
          //设置宽度铺满 match_parent
          child: FractionallySizedBox(
            widthFactor: 1,
            child:Stack(
              children: <Widget>[
                //可点击的返回按钮
                GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  //左边距
                  child: Container(
                    margin: EdgeInsets.only(left: 14),
                    child: Icon(
                      Icons.close,
                      color: backButtonColor,
                      size: 22,
                    ),
                  ),
                ),

                //标题绝对定位 左右距离 stack 的左右均为 0， 即水平方向铺满
                Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.title ?? '',
                      style: TextStyle(color: backButtonColor, fontSize: 16),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                )

              ],
            ),
          ),
        )

      ],
    );

  }
}
