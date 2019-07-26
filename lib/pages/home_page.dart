import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage> {

  // 设置 AppBar 透明度
  double appBarAlpha = 0;
  // 基准偏移量基准
  static const APP_BAR_SCROLL_OFFSET = 100.0;

  // Banner 图 图片列表
  final banners = [
    'https://dimg04.c-ctrip.com/images/zg0m15000000yqwx03AC2.jpg',
    'https://dimg04.c-ctrip.com/images/zg0215000000yomk6CDCE.jpg',
    'https://dimg04.c-ctrip.com/images/zg0616000000yyjj13FAD.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      //使用 Stack 实现叠加的效果
      children: <Widget>[
        //第一个 child 是（包了几层 widget 的）滚动的列表
        MediaQuery.removePadding(
            context: context,
            removeTop: true, //移除 ListView 顶部的 padding
            child: NotificationListener( //添加监听
                onNotification: (scrollNotification){ //监听回调
                  if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                    //当事件是滚动事件 且是 ListView （scrollNotification.depth == 0 表示只监听第一个 child 的滚动） 滚动时
                    onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: ListView( //ListView 处于会自动把顶部或者四周的安全区空间预留出来
                  children: <Widget>[
                    Container(
                      height: 170,
                      child: Swiper(
                        itemCount: banners.length,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(banners[index], fit: BoxFit.fill,);
                        },
                        pagination: SwiperPagination(),
                      ),
                    ),
                    Container(
                      height: 800,
                      color: Colors.lightBlueAccent,
                    ),

                  ],
                )
            )
        ),

        //第二个 child 是自定义的可以改变透明度的 AppBar
        Opacity(
          opacity: appBarAlpha,
          child: Container(
            height: 80,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top:30),
                child: Text('首页'),
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 根据列表滚动的偏移量，来动态设置 AppBar 的透明度，理论上 [offset] 是不会小于 0 的
  void onScroll(double offset) {
    var alpha = offset / APP_BAR_SCROLL_OFFSET;
    //矫正
    if(alpha < 0) {
      alpha = 0;
    }else if(alpha > 1) {
      alpha = 1;
    }

    //刷新 widget 树
    setState(() {
      appBarAlpha = alpha;
    });
    //print('offset: $offset  alpha: $alpha');
  }

}