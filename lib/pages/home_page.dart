import 'dart:convert';

import 'package:ctrip_flutter/dao/home_dao.dart';
import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/model/grid_nav_model.dart';
import 'package:ctrip_flutter/model/sales_box_model.dart';
import 'package:ctrip_flutter/widget/grid_nav.dart';
import 'package:ctrip_flutter/widget/loading_container.dart';
import 'package:ctrip_flutter/widget/loca_nav.dart';
import 'package:ctrip_flutter/widget/sales_box.dart';
import 'package:ctrip_flutter/widget/sub_nav.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
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
  static const APP_BAR_SCROLL_OFFSET = 140.0;

  // Banner 图 图片列表
  final banners = [
    'https://dimg04.c-ctrip.com/images/zg0m15000000yqwx03AC2.jpg',
    'https://dimg04.c-ctrip.com/images/zg0215000000yomk6CDCE.jpg',
    'https://dimg04.c-ctrip.com/images/zg0616000000yyjj13FAD.jpg'
  ];

  String resultStr = 'Loading HomePage...';

  List<CommonModel> _bannerList = [];
  List<CommonModel> _localNavList;
  List<CommonModel> _subNavList;
  GridNavModel _gridNavModel;
  SalesBoxModel _salesBoxModel;


  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loadData2();
  }

  //加载网络请求的第一种方式
  Future<void> loadData() {
    HomeDao.fetch().then((homeModel) {

      setState(() {
        resultStr = json.encode(homeModel);
      });

    }).catchError((e){
      resultStr = e.toString();
    });

    return null;
  }

  //加载网络请求的第二种方式
  //下拉刷新需要返回 Future, 但又不需要结果，所以加上 Future<void>
  Future<void> loadData2() async {

    try {

      var homeModel = await HomeDao.fetch();
      setState(() {

        _bannerList = homeModel.bannerList;
        _localNavList = homeModel.localNavList;
        _gridNavModel = homeModel.gridNav;
        _subNavList = homeModel.subNavList;
        _salesBoxModel = homeModel.salesBox;

        _isLoading = false;
        
      });

    }catch (e) {
      setState(() {
        resultStr = e.toString();
        _isLoading = false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {

    return LoadingContainer( //加载进度指示器
      isLoading: _isLoading,
      child: Stack(
        //使用 Stack 实现叠加的效果
        children: <Widget>[

          //设置背景色
          Container(
            color: Color(0xfff2f2f2),
          ),

          //移除 ListView 顶部的 padding，延伸到状态栏下方
          MediaQuery.removePadding(
              context: context,
              removeTop: true, //移除 ListView 顶部的 padding
              child: RefreshIndicator( //下拉刷新
                onRefresh: loadData2,
                child: NotificationListener( //添加滑动监听
                    onNotification: (scrollNotification){ //监听回调
                      if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                        //当事件是滚动事件 且是 ListView （scrollNotification.depth == 0 表示只监听第一个 child 的滚动） 滚动时
                        onScroll(scrollNotification.metrics.pixels);
                      }

                      return false;
                    },
                    child: _listView,
                ),
              ),
          ),

          //第二个 child 是自定义的可以改变透明度的 AppBar
          _appBar,
        ],
      ),
    );
  }

  Widget get _listView {
    return ListView( //ListView 处于会自动把顶部或者四周的安全区空间预留出来
      children: <Widget>[

        //banner 图
        _banner,

        //首页小图标导航 外部有 padding
        Padding(
          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: LocalNav(localNavList: _localNavList,),
        ),

        //首页卡片导航 外部有 padding
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
          child: GridNav(gridNavModel: _gridNavModel,),
        ),

        //卡片下方子导航
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
          child: SubNav(subNavList: _subNavList,),
        ),

        //底部 View
        SalesBox(salesBoxModel: _salesBoxModel,),

      ],
    );
  }

  ///banner 图
  Widget get _banner {
    return Container(
      height: 180,
      child: Swiper(
        itemCount: _bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return _wrapGesture(
              context,
              _bannerList[index].url,
              Image.network(
                _bannerList[index].icon,
                fit: BoxFit.fill,
              )
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }


  /// appbar
  Widget get _appBar {
    return Opacity(
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

  ///抽取点击事件，把需要被点击的控件，放入 GestureDetector 中
  _wrapGesture(BuildContext context, String url, Widget child) {
    return GestureDetector(
      onTap: () {
        //跳转到 WebView 页面
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(
                url: url,
            )
        ));
      },
      child: child,
    );
  }

}