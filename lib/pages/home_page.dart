

import 'package:ctrip_flutter/dao/home_dao.dart';
import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/model/grid_nav_model.dart';
import 'package:ctrip_flutter/model/sales_box_model.dart';
import 'package:ctrip_flutter/pages/search_page.dart';
import 'package:ctrip_flutter/pages/speak_page.dart';
import 'package:ctrip_flutter/widget/grid_nav.dart';
import 'package:ctrip_flutter/widget/loca_nav.dart';
import 'package:ctrip_flutter/widget/sales_box.dart';
import 'package:ctrip_flutter/widget/search_bar.dart';
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

  List<CommonModel> _bannerList = [];
  List<CommonModel> _localNavList;
  List<CommonModel> _subNavList;
  GridNavModel _gridNavModel;
  SalesBoxModel _salesBoxModel;

  bool shouldRefresh = true;
  var _listView;
  var _futureFutureBuilder;
  double statusBarHeight = 0;

  var _searchBar;
  bool _currLightMode ;
  var defaultText = '酒店、车票、旅游、攻略';

  @override
  void initState() {
    super.initState();
    _futureFutureBuilder = loadData();
  }

  //加载网络请求的第二种方式
  //下拉刷新需要返回 Future, 但又不需要结果，所以加上 Future<void>
  //使用 FutureBuilder 等待网络的请求和结果，并且 FutureBuilder 会自动调用 setState
  Future<void> loadData() async {

      var homeModel = await HomeDao.fetch();

      _bannerList = homeModel.bannerList;
      _localNavList = homeModel.localNavList;
      _gridNavModel = homeModel.gridNav;
      _subNavList = homeModel.subNavList;
      _salesBoxModel = homeModel.salesBox;

      shouldRefresh = true;

      //如果发生异常，会被 FutureBuilder 的 AsyncSnapshot 捕获，在那可以显示错误 view
      //throw Exception('错误异常测试');
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
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
            onRefresh: loadData,
            child: NotificationListener( //添加滑动监听
              onNotification: (scrollNotification){ //监听回调
                if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                  //当事件是滚动事件 且是 ListView （scrollNotification.depth == 0 表示只监听第一个 child 的滚动） 滚动时
                  onScroll(scrollNotification.metrics.pixels);
                }

                return false;
              },
              child: FutureBuilder( // FutureBuilder 接收一个 future，初次加载有 waiting 状态，可用来做加载中处理
                builder: _futureBuild,
                future: _futureFutureBuilder, //虽然网上说 设置一个（暂时）不变的 future 可以避免重绘，但是好像没效果？？
              ),
            ),
          ),
        ),

        //第二个 child 是自定义的可以改变透明度的 AppBar
        _appBar,
      ],
    );
  }

  Widget _futureBuild(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        //print('done');
        if (snapshot.hasError) return _errView(snapshot.error);
        return createListView();
      default:
        return _errView('Loading...');
    }
  }

  Widget _errView(dynamic msg) {
    return Center(
      child: Text('Error: $msg'),
    );
  }

  Widget createListView() {

    //要把 _listView 做缓存，不在状态栏透明度变化（滑动改变）的时候，一直重绘，否则会滑动有点卡
    if (shouldRefresh) {
       print('Create A New List...');
       shouldRefresh = false;

      _listView = ListView( //ListView 处于会自动把顶部或者四周的安全区空间预留出来
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

          //底部活动 View
          SalesBox(salesBoxModel: _salesBoxModel,),

        ],
      );
    }

    return _listView;

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

    if (statusBarHeight == 0.0) {
      statusBarHeight = MediaQuery.of(context).padding.top;
      print('statusBarHeight: $statusBarHeight');
    }


    return
      Container(
        decoration: BoxDecoration(
          color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
          border: _isLightMode() ? Border(bottom: BorderSide(color: Colors.black12)) : null,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: _searchView(),
        ),
      );

//    return Opacity(
//      opacity: appBarAlpha,
//      child: Container(
//        height: statusBarHeight + 50,
//        color: Colors.white,
//        child: Padding(
//          padding: EdgeInsets.only(top:statusBarHeight),
//          child:SearchBar(),
//        ),
//      ),
//    );
  }

   Widget _searchView() {

    //状态没变化，不重绘 searchBar
    var isLightMode = _isLightMode();
    if(_currLightMode == null || isLightMode != _currLightMode) {
      print('Create A New SearchBar');
      _searchBar =  SearchBar(
        searchType: isLightMode ? SearchType.HomeLight : SearchType.Home,
        defaultText: defaultText,
        onTap: _jumpSearch,
        onVoiceBtnClick: _onVoiceBtnClick,
      );
      _currLightMode = isLightMode;
    }
     return _searchBar;

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

  bool _isLightMode(){
    return appBarAlpha > 0.7;
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

  _jumpSearch(){
    //跳转到 WebView 页面
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        SearchPage(
          hint: defaultText,
          showLeftView: true,
        )
    ));
  }

  _onVoiceBtnClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SpeakPage();
    }));
  }

}