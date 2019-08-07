import 'package:ctrip_flutter/dao/search_dao.dart';
import 'package:ctrip_flutter/model/search_model.dart';
import 'package:ctrip_flutter/widget/search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}

class _SearchPageState extends State<SearchPage> {

  SearchModel _searchModel;
  String _currKeyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
            searchType: SearchType.Search,
            hint: '旅游攻略、网红景点打卡',
            showLeftView: false,
            onTextChange: _onTextChange,
            onVoiceBtnClick: _onVoiceBtnClick,
          ),
         Expanded(
           child: ListView.builder(
             itemBuilder: _itemBuilder,
             itemCount: _searchModel?.data?.length ?? 0,
           ),
         ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int pos) {

    var searchItem = _searchModel.data.elementAt(pos);

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _itemIcon(searchItem.type),
              Expanded(
                child: _itemTitle(searchItem),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _itemTitle(SearchItem item) {
    // world wallw -- w --> ['', 'orld ', 'all','']
    String word = item.word;
    String l;

    List<String> splitList = item.word.split(_currKeyword);
    return Text(
      item.word,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  void subStr(String word, String key) {
    int index = word.indexOf(key);
    if(index != -1){
      String normal = word.substring(0, index);
      //l = l + normal+key;
      String sub = word.substring(index + key.length, word.length);
      subStr(sub, key);
    }
  }

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
      margin: EdgeInsets.only(right: 8),
      child: Image.asset(
        iconPath,
        height: 14,
        width: 14,
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

  //语音搜索
  _onVoiceBtnClick() {

  }

}