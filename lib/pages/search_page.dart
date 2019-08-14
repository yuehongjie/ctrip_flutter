import 'package:ctrip_flutter/dao/search_dao.dart';
import 'package:ctrip_flutter/model/search_model.dart';
import 'package:ctrip_flutter/pages/speak_page.dart';
import 'package:ctrip_flutter/widget/search_bar.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  final String hint;
  final String defaultText;
  final bool showLeftView;

  const SearchPage({Key key, this.hint, this.defaultText, this.showLeftView}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}

class _SearchPageState extends State<SearchPage> {

  SearchModel _searchModel;
  String _currKeyword;
  String defaultWord;
  TextEditingController controller = TextEditingController();

  var normalStyle = TextStyle(color: Colors.black54, fontSize: 15);
  var keywordStyle= TextStyle(color: Colors.blue, fontSize: 15);
  var regExp = RegExp('^(-?[1-9]\d*(\.\d*[1-9])?)|(-?0\.\d*[1-9])\$');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //这里的 widget 就是 State.widget 即 State 泛型的对象 即 WebView
    var statusBarHeight= MediaQuery.of(context).padding.top;
    print('statusBarHeight: $statusBarHeight');
    return  Scaffold(
      body: Column(
        children: <Widget>[
          //填充状态栏
          Container(
            height: statusBarHeight <= 0 ? 30 : statusBarHeight,
            color: Colors.white,
          ),

          SearchBar(
            searchType: SearchType.Search,
            hint: widget.hint,
            defaultText: widget.defaultText,
            showLeftView: widget.showLeftView,
            controller: controller,
            onTextChange: _onTextChange,
            onVoiceBtnClick: _onVoiceBtnClick,
            onBack: _onBack,
          ),
          Expanded(
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemBuilder: _itemBuilder,
                itemCount: _searchModel?.data?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ListView 的 item
  Widget _itemBuilder(BuildContext context, int pos) {

    var searchItem = _searchModel.data[pos];

    return _wrapGesture(
        context,
        searchItem.url,
        searchItem.word,
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //图标
              _itemIcon(searchItem.type),
              //内容
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _itemTitle(searchItem.word),
                          _itemSubTitle(searchItem),
                        ],
                      ),
                    ),
                    _itemPrice(searchItem.price),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  //每行 item 的子标题
  _itemSubTitle(SearchItem item){

    String subTitle = item.districtname ?? '' + item.zonename ?? '' + item.star ?? '';

    if (subTitle.length == 0) {
      return Container(width: 0, height: 0,);
    }

    return Container(
      padding: EdgeInsets.only(top: 8),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        subTitle,
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  _itemPrice(String price) {

    if (price == null) {
      return Container(height: 0, width: 0,);
    }

    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Text(
        regExp.hasMatch(price) ? '￥$price' : price,
        style: TextStyle(
        color: Colors.orange,
        fontSize: 14,
        ),
      ),
    );

  }

  //每行 item 的标题（关键字高亮）
  Widget _itemTitle(String title) {

    // world wallw   -- w -->   ['', 'orld ', 'all','']
    var splitList = title.split(_currKeyword);

    List<TextSpan> spanList = [];

    // 在每一个被拆分的元素（除了最后一个）后，加上关键字，最后再加上最后一个元素，就是原来的字符串
    // 或者第一个元素 + 每一个元素（除了第一个元素）的前面加上关键字，就是原来的字符串
    for (int i = 0; i < splitList.length - 1; i++) {

      spanList.add(TextSpan(style: normalStyle, text:splitList[i]));
      spanList.add(TextSpan(style: keywordStyle, text:_currKeyword));

    }
    spanList.add(TextSpan(style: normalStyle, text:splitList[splitList.length - 1]));

    return RichText(
      text: TextSpan(
        children: spanList,
      ),
    );
  }


  // 每行 item 图标
  Widget _itemIcon(String type){

    //（默认的）背景色和图标
    Color bgColor = Colors.blue;
    String iconPath = 'images/type_common.png';

    if (type != null) {
      if (type.contains('hotel')) {
        bgColor = Colors.redAccent;
        iconPath = 'images/type_hotel.png';
      }else if (type.contains('ticket')) {
        bgColor = Colors.orange;
        iconPath = 'images/type_ticket.png';
      }else if (type.contains('plane')) {
        bgColor = Colors.blueAccent;
        iconPath = 'images/type_plane.png';
      }else if (type.contains('train')) {
        bgColor = Colors.teal;
        iconPath = 'images/type_train.png';
      }else if (type.contains('travel') || type.contains('sight')) {
        bgColor = Colors.green;
        iconPath = 'images/type_travel.png';
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bgColor,
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(right: 8,top: 2.5),
      child: Image.asset(
        iconPath,
        height: 10,
        width: 10,
      ),
    );

  }

  //文字变化 开始搜索
  _onTextChange(String text) {
    _currKeyword = text;
    if(text == null || text.length == 0) {
      //不显示数据
      setState(() {
        _searchModel = null;
      });

      return;
    }

    SearchDao.fetch(text)
        .then((model) {
          // 因为实时搜索，可能很短时间内发送多个请求，但返回时序是不定的，
          // 所以，只有输入框中的关键字和返回的数据的关键字一样时，再更新 UI
          if(_currKeyword == model.keyword) {
            setState(() {
              _searchModel = model;
            });
          }

    }).catchError((err){
          print('err: $err');
    });
  }

  //语音识别
  _onVoiceBtnClick() async {
    //从语音识别返回的数据
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SpeakPage(isFromSearch: true,);
    }));

    if (result != null) {
      print('语音搜索：$result');
      //改变输入框文字
      controller.text = result;
    }

  }

  _onBack(){
    Navigator.pop(context);
  }

  ///抽取点击事件，把需要被点击的控件，放入 GestureDetector 中
  _wrapGesture(BuildContext context, String url, String title, Widget child) {
    return GestureDetector(
      onTap: () {
        print(url);
        //跳转到 WebView 页面
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(
              url: url,
              title: title,
            )
        ));
      },
      child: child,
    );
  }

}