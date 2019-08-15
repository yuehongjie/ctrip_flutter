
import 'package:ctrip_flutter/dao/travel_tab_dao.dart';
import 'package:ctrip_flutter/model/travel_tab_model.dart';
import 'package:ctrip_flutter/pages/travel_tab_page.dart';
import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TravelPageState();
  }

}


class _TravelPageState extends State<TravelPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  TabController _tabController;
  TravelTabModel _travelTabModel;
  List<TabItem> _tabList = [];

  String resultT='旅拍';

  @override
  void initState() {
    _tabController = TabController(length: _tabList.length, vsync: this);
    loadData();
    super.initState();
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  
  loadData() {
    TravelTabDao.fetch().then((model) {
      _travelTabModel = model;

      setState(() {
        _tabList = _travelTabModel.tabs ?? [];

      });

      //由于 tabs 是动态的，数量在获取到 tabs 之后，再设置一次
      _tabController = TabController(length: _tabList.length, vsync: this);

    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: <Widget>[

          //填充状态栏的高度
          Container(
            height: MediaQuery.of(context).padding.top,
          ),

          //tab 标签
          TabBar(
            tabs: _createTabs(),
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.black87,
            unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            labelPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Color(0xff2fcfbb),
                width: 2,
              ),
              insets: EdgeInsets.only(top:5, bottom: 5),
            ),
          ),

          // tab 对应的 View
          Expanded( // 铺满
            child: TabBarView(
              controller: _tabController,
              children: _createTabPages(),
            ),
          ),
        ],
      ),
    );
  }

  //每个 tab 标签对应的每页的 Widget
  _createTabPages() {

    List<Widget> tabPages = [];

    _tabList.forEach((item) {
      tabPages.add(
          TravelTabPage(travelUrl: _travelTabModel.url, groupChannelCode: item.groupChannelCode)
      );
    });

    return tabPages;
  }

  // tab 标签
  List<Tab> _createTabs() {

    List<Tab> tabs = [];
    _tabList.forEach((item){
      tabs.add( Tab(text: item.labelName) );
    });

    return tabs;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}