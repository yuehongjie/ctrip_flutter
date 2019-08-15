
import 'package:ctrip_flutter/dao/travel_list_dao.dart';
import 'package:ctrip_flutter/model/travel_list_model.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


///每个 tab 页面的数据
class TravelTabPage extends StatefulWidget {

  // base url
  final String travelUrl;
  // tab  channel code
  final String groupChannelCode;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TravelTabPageState();
  }

}

class _TravelTabPageState extends State<TravelTabPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{


  int pageSize = 10;
  int pageIndex = 1;
  
  var _futureFutureBuilder;
  //滚动监听 加载更多
  ScrollController _scrollController = ScrollController();

  List<TravelItem> travelItemList = [];

  @override
  void initState() {

    //滚动监听 加载更多
    _scrollController.addListener((){
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print('load more');
        loadData(loadMore: true);
      }
    });

    //使用 FutureBuilder 帮助处理加载状态，
    // 如果有错误会传递给 FutureBuilder 的 snapshot
    _futureFutureBuilder = loadData();
    super.initState();
  }

  //加载数据   loadMore: 默认 false
  Future <void> loadData({bool loadMore = false}) async{

    if (loadMore) {
      pageIndex ++;
    }else {
      pageIndex = 1;
    }

    var travelListModel = await TravelListDao.fetch(widget.travelUrl, widget.groupChannelCode, pageIndex, pageSize);

    List<TravelItem> tmpTravelList = [];
    travelListModel.resultList?.forEach((travelItem) {
      if(travelItem.article != null) {
        tmpTravelList.add(travelItem);
      }
    });

    // 如果是刷新，要清空数据(这里的刷新，不包括第一次加载数据)
    if (!loadMore && travelItemList.isNotEmpty) {
      travelItemList.clear();
      setState(() {
        travelItemList = tmpTravelList;
      });
    }else if(loadMore) {
      setState(() {
        travelItemList.addAll(tmpTravelList);
      });
    }else {
      //第一次加载数据 不需要调用 setState，由 FutureBuilder 处理
      travelItemList = tmpTravelList;
    }


  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: RefreshIndicator(
        child: FutureBuilder(
          future: _futureFutureBuilder,
          builder: _futureBuild,
        ),
        onRefresh: loadData,
      ),
    );
  }

  //使用 FutureBuilder 帮助处理加载状态
  Widget _futureBuild(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
        print('tab page waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
      //print('done');
        if (snapshot.hasError) return _errView(snapshot.error);
        return createGridView();
      default:
        return _errView('Loading...');
    }
  }

  //瀑布流布局
  Widget createGridView() {
    print('Create GridView.. ');
    return StaggeredGridView.countBuilder(
      controller: _scrollController,
      crossAxisCount: 2, // n 列
      itemCount: travelItemList.length ?? 0,
      itemBuilder: (BuildContext context, int index) => TravelItemView(travelItem: travelItemList[index],),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1), //固定每一个元素占一列
      scrollDirection: Axis.vertical,//geometry.crossAxisExtent
    );
  }

  Widget _errView(dynamic msg) {
    return Center(
      child: Text('Error: $msg'),
    );
  }

  @override
  // 缓存 消耗内存
  bool get wantKeepAlive => true;

}



class TravelItemView extends StatelessWidget {

  final TravelItem travelItem;

  const TravelItemView({Key key, this.travelItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        jump(context);
      },
      //卡片（圆角）
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),  //设置圆角,
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Column(
          children: <Widget>[
            //图片
            _itemImage(),
            //标题
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
              child: Text(
                travelItem.article.articleTitle,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //底部作者及点赞
            _itemBottom(),
          ],
        ),
      ),
    );
  }

  //图片带位置
  Widget _itemImage() {
    return Stack(
      children: <Widget>[
        //图片
        Image.network(
          travelItem.article.images[0].dynamicUrl,
        ),
        //位置
        Positioned(
          bottom: 6,
          left: 6,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 8, 2),
            decoration: BoxDecoration(
              color: Color(0x88000000),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 12,
                ),
                Container(
                  width: 2,
                  height: 0,
                ),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    posText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  String posText() {
    if (travelItem.article.pois == null || travelItem.article.pois.isEmpty) {
      return '未知';
    }else {
      return travelItem.article.pois[0].poiName ?? '未知';
    }
  }

  Widget _itemBottom(){
    return Container(
      padding: EdgeInsets.all(6),
      child: Row(
        children: <Widget>[
          //作者：头像 + 昵称
          Flexible(
            child: Row(
              children: <Widget>[

                PhysicalModel(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    travelItem.article.author.coverImage.dynamicUrl,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),

                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 6, right: 4),
                    child: Text(
                      travelItem.article.author.nickName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          // 点赞数
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 13,
                color: Colors.grey,
              ),

              Container(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  '${travelItem.article.likeCount}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 跳转 H5
  jump(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {

      return WebView(
        url: travelItem.article.urls[0].h5Url,
        title: travelItem.article.articleTitle,
        hideAppBar: false,
        backForbid: true,
      );

    }));
  }

}