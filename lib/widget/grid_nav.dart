

import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/model/grid_nav_model.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

//首页卡片 Grid 布局
class GridNav extends StatelessWidget {

  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _gridView(context);
  }

  //完整的 grid 布局
  _gridView(BuildContext context) {

    return PhysicalModel(
        //设置圆角
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        clipBehavior: Clip.antiAlias, //需要设置裁减，要不没有圆角效果
        child:Column(
          //三行元素
          children: _gridColumnItems(context),
        )
    );
  }

  // Column 元素
  _gridColumnItems(BuildContext context) {

    List<Widget> items = [];
    if(gridNavModel == null) return items;

    //酒店
    if (gridNavModel.hotel != null) {
      items.add(_gridLineItem(context, gridNavModel.hotel, items.isEmpty)); //如果 items 为空，则为第一行
    }

    //机票
    if (gridNavModel.flight != null) {
      items.add(_gridLineItem(context, gridNavModel.flight, items.isEmpty));
    }
    //旅行
    if (gridNavModel.travel != null) {
      items.add(_gridLineItem(context, gridNavModel.travel, items.isEmpty));
    }

    return items;

  }

  // 每一行元素: 由 1 x 主item + 2 x 两个竖直方向排列的小 Item
  // 参数 isFirstLine 表示是否为第一行，用来设置行分割线
  _gridLineItem(BuildContext context, GridNavItem gridNavItem, bool isFirstLine) {

    // 每一行有 3 列元素
    List<Widget> rowItems = [];
    rowItems.add(_mainItem(context, gridNavItem.mainItem));
    rowItems.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    rowItems.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    //每列元素是平分宽度的，所以外层各包裹一个 Expand
    List<Widget> expandRowItems = [];
    rowItems.forEach((item) {
      expandRowItems.add(Expanded(child: item, flex: 1));
    });

    //渐变色
    Color statrColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));
    
    //返回一整行元素
    return Container(

      height: 88, //每行高度 88
      margin: isFirstLine ? null : EdgeInsets.only(top: 3), //如果不是第一行，则要设置上外边距
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [statrColor, endColor]), //线性渐变色
      ),
      child: Row(
        //一行 3 列
        children: expandRowItems,
      ),
    );
  }

  //每一行的主（大）Item
  _mainItem(BuildContext context, CommonModel model){
    //可点击
    return _wrapGesture(
        context,

        Stack(
          //底部是图片 上面是文字
          children: <Widget>[
            Image.network(
                model.icon,
                width: 121,
                height: 80,
                alignment: AlignmentDirectional.bottomCenter
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: AlignmentDirectional.topCenter,
              child: Text(
                model.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        model
    );
  }

  //每一行的 两个竖直方向排列的小 Item
  _doubleItem(BuildContext context, CommonModel topModel, CommonModel bottomModel) {
    return Column(
      children: <Widget>[
        //竖直方向上 平分 column
        Expanded(child: _subItem(context, topModel, true)),
        Expanded(child: _subItem(context, bottomModel, false))
      ],
    );
  }


  //每行竖直方向排列的小 Item
  _subItem(BuildContext context, CommonModel model, bool isTopItem) {

    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    //可点击的 item
    return _wrapGesture(

        context,

        //水平方向占满
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              //分割线
              border: Border(
                left: borderSide,
                bottom: isTopItem ? borderSide : BorderSide.none, //如果不是 topItem 则没有底部分割线
              ),
            ),
            child: Center(
              child: Text(
                model.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        model
    );
  }

  //抽取点击事件，把需要被点击的控件，放入 GestureDetector 中
  _wrapGesture(BuildContext context, Widget child, CommonModel model) {
    return GestureDetector(
      onTap: () {
        //跳转到 WebView 页面
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(
                title: model.title,
                url: model.url,
                statusBarColor: model.statusBarColor,
                hideAppBar: model.hideAppBar
            )
        ));
      },
      child: child,
    );
  }

}
