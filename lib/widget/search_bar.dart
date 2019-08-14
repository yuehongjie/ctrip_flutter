
import 'package:flutter/material.dart';

enum SearchType{Home, HomeLight, Search}

class SearchBar extends StatefulWidget {

  final SearchType searchType;
  final String hint;
  final String defaultText;
  final bool showLeftView;
  final TextEditingController controller;
  final void Function() onBack;
  final void Function() onTap;
  final void Function() onVoiceBtnClick;
  final void Function(String) onTextChange;


  SearchBar({
    this.searchType = SearchType.Home,
    this.hint = '',
    this.defaultText = '',
    this.showLeftView = true,
    this.controller,
    this.onBack,
    this.onTap,
    this.onVoiceBtnClick,
    this.onTextChange
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  //输入框是否有内容
  bool isInputEmpty = true ;

  String searchText;

  @override
  void initState() {

    //添加文字变化监听
    if (widget.searchType != SearchType.Home && widget.controller != null) {

      widget.controller.addListener((){
        //print('text change listener');
        _onTextChange(widget.controller.text);
      });

      //预搜索的内容（从语音搜索页面携带数据过来）
      if (widget.defaultText != null && widget.defaultText.length > 0){
        widget.controller.text = widget.defaultText ;
      }

    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(widget.showLeftView ?? true ? 10 : 0, 0, 10, 0),
      child:  Row(
        children: [
          _generateLeftView(),
          Expanded(
            child: _generateSearchView(),
          ),
          _generateRightView(),
        ],
      ),
    );
  }

  //搜索框左侧布局
  Widget _generateLeftView() {

    if (widget.showLeftView) {

      if(widget.searchType == SearchType.Search) {
        return _wrapTap(
          widget.onBack,
          Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        );
      }else{

        return Row(
          children: <Widget>[
            Text('北京',
              style: TextStyle(
                fontSize: 16,
                color: _homeFontColor(),
              ),
            ),
            Icon(
              Icons.expand_more,
              color: _homeFontColor(),
            )
          ],
        );

      }

    }else {
      return Container(height: 0, width: 0,);
    }

  }

  //搜索框右侧布局
  _generateRightView(){
    return
      widget.searchType == SearchType.Search ?
      _wrapTap(
        _onSearch,
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue
          ),
          child: Text(
            '搜索',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        )
      )
      :
      Icon(
        Icons.message,
        color: _homeFontColor(),
      );
  }

  //点击搜索按钮
  _onSearch() {
    if (widget.controller == null) return;
    print('onSearch');
    _onTextChange(widget.controller.text);
  }

  //home 页的文字，在不同状态下的颜色
  Color _homeFontColor() {
    return widget.searchType == SearchType.Home ? Colors.white : Colors.black54;
  }

  //搜索框布局
  Widget _generateSearchView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.searchType == SearchType.Search ? 6 : 26),
        color: Color( widget.searchType == SearchType.Home ? 0xfffefefe : 0xffe5e5e5),
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: widget.searchType == SearchType.Search ? Colors.grey : Colors.blue,
          ),

          Expanded(
            child: widget.searchType == SearchType.Search ? _createInputView() : _createTextView(),
          ),

          !isInputEmpty ?
          _wrapTap(
            _clearInputText,
            Icon(
              Icons.close,
              color: Colors.grey,
            )
          ) :
          _wrapTap(
            widget.onVoiceBtnClick ,
            Icon(
              Icons.mic,
              color: widget.searchType == SearchType.Search ? Colors.blue : Colors.grey,
            )
          ),
        ],
      ),
    );
  }

  _clearInputText() {
    if (widget.controller == null) return;
    widget.controller?.clear();
  }

  //搜索模式时 显示输入框
  Widget _createInputView() {

    return TextField(
      controller: widget.controller,
      //onChanged: _onTextChange,
      decoration: InputDecoration(
        hintText: widget.hint,
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(10,0,10,0),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(
        fontSize: 16,
        color: Color(0xff141414),
      ),
      autofocus: false,
    );
  }

  //文字变化回调，发起搜索
  _onTextChange(String text) {

    print('SearchBar _onTextChange: $text');

    //当状态发生变化，再更新 widget，减少重绘
    var isEmpty =  (text == null || text.length == 0);
    if (isEmpty != isInputEmpty) {
      setState(() {
        isInputEmpty = isEmpty;
      });
    }

    //回调内容变化
    if(widget.onTextChange != null) {
      widget.onTextChange(text);
    }

  }

  // Home 页 显示文本框
  Widget _createTextView(){
    return _wrapTap(
        widget.onTap,
        Text(
          widget.defaultText,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black54
          ),
        )
    );
  }

  //点击事件包装
  Widget _wrapTap(void Function() callBack, Widget child) {
    return GestureDetector(
      onTap: callBack,
      child: child,
    );
  }

  setSearchText(String text) {
    widget.controller.text = text;
  }

}
