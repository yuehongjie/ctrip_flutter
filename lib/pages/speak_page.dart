
import 'package:ctrip_flutter/pages/search_page.dart';
import 'package:ctrip_flutter/plugin/asr_plugin.dart';
import 'package:flutter/material.dart';

const double MIC_SIZE = 100;

class SpeakPage extends StatefulWidget {

  //判断是否是从搜索页面进入，
  // 是的话，则识别后，返回即可，不是的话，则跳转到搜索页面
  final bool isFromSearch;

  const SpeakPage({Key key, this.isFromSearch = false}) : super(key: key);

  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation ;
  bool hasPermission = false;
  String _speakWord = '长按说话';

  @override
  void initState() {

    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        //循环执行动画
        if (status == AnimationStatus.completed) {
          controller.reverse();//动画执行完成，则反过来继续执行
        }else if (status == AnimationStatus.dismissed) {
          controller.forward(); //动画执行到开始的地方，则重新执行
        }
      });

    checkPermission();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    AsrManager.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _topItem(),
          _bottomItem(),
        ],
      ),
    );
  }

  Widget _topItem() {

    var statusBarHeight= MediaQuery.of(context).padding.top;

    return Column(

      children: <Widget>[

        //填充状态栏
        Container(
          height: statusBarHeight <= 0 ? 30 : statusBarHeight,
          color: Colors.white,
        ),

        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            '你可以这样说',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),

        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ],

    );

  }

  Widget _bottomItem() {

    return FractionallySizedBox(
      widthFactor: 1, //宽度铺满
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[

                Text(
                  _speakWord,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),

                //文字和语音按钮间距
                Container(height: 6,),

                //手势事件
                GestureDetector(
                  onTapDown: speakStart,
                  onTapUp: speakStop,
                  onTapCancel: speakCancel,
                  child:Stack(
                    alignment: Alignment.topCenter,

                    children: <Widget>[

                      //占位控件，防止在动画执行的时候，文字位置变化
                      Container(
                        height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),

                      //动画按钮
                      AnimatedMic(
                        animation: animation,
                      ),

                    ],
                  ),
                ),

                //底部间距
                Container(height: 15,),

              ],
            ),
          ),

          Positioned(
            right: MIC_SIZE / 2,
            bottom: MIC_SIZE / 2,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );

  }

  //检查权限
  checkPermission() {
    AsrManager.checkPermission().then((isAllGranted){
      hasPermission = isAllGranted;
    }).catchError((e){
      print(e);
    });
  }

  speakStart(TapDownDetails tapDown) {
    if (!hasPermission) {
      changeWord('无录音权限');
      return;
    }
    print('tapDown');

    controller.forward();
    changeWord('-- 识别中 --');
    //开始录音
    var speakResult = AsrManager.start();
    waitForSpeak(speakResult);

  }

  speakStop(TapUpDetails tapUp) {
    print('tapUp');
    stopAnim();
    var speakResult = AsrManager.stop();
    waitForSpeak(speakResult);

  }

  speakCancel() {
    print('tapCancel');
    stopAnim();
    AsrManager.cancel();
    changeWord('长按说话');
  }

  changeWord(String word) {
    setState(() {
      _speakWord = word;
    });
  }

  stopAnim() {
    controller.reset();
    controller.stop();
  }

  //语音识别结果
  waitForSpeak(Future<String> result) {
    result.then((text){
      changeWord('长按说话');
      stopAnim();
      print('text: ' + text);
      //携带识别结果到搜索页
      _searchWithSpeak(text);
    }).catchError((e){
      print(e);
      changeWord('长按说话');
      stopAnim();
    });
  }

  _searchWithSpeak(String text) {
    if(text != null) {
      //从搜索页面来，则回到搜索页面
      if(widget.isFromSearch) {
        Navigator.pop(context, text);
      }else{
        //从首页来，则打开搜索页面
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SearchPage(
            defaultText: text,
            showLeftView: true,
          );
        }));
      }

    }
  }

}

/// 语音按钮动画
class AnimatedMic extends AnimatedWidget {

  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE / 2);

  AnimatedMic({Key key, Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityTween.evaluate(listenable),
      child: Container(
        height: _sizeTween.evaluate(listenable),
        width: _sizeTween.evaluate(listenable),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE/2)
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: MIC_SIZE/3,
        ),
      ),
    );
  }

}
