

import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

/*
 * 首页卡片下面的子导航控件
 */
class SubNav extends StatelessWidget {

  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.circular(6),
      ),

      child: Padding(
        padding: EdgeInsets.all(8),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {

    if(subNavList == null) return Container(width: 0.0, height: 0.0);

    List<Widget> items = [];

    subNavList.forEach((model){

      items.add(item(context, model));

    });

    //分成两行展示
    int centerPos = (items.length / 2 + 0.5).toInt();

    //水平方向 平均排列
    return Column(
      children: <Widget>[
        Row(
          children: items.sublist(0, centerPos),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        Row(
          children: items.sublist(centerPos,items.length),
        ),
      ],
    );

  }

  // image + text
  Widget item(BuildContext context, CommonModel commonModel) {

    return Expanded( //平分

      child: GestureDetector(

        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {

                  return WebView(
                    title: commonModel.title,
                    url: commonModel.url,
                    statusBarColor: commonModel.statusBarColor,
                    hideAppBar:  commonModel.hideAppBar,
                  );
                },
              )
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(
              commonModel.icon,
              width: 20,
              height: 20,
            ),
            Text(
              commonModel.title,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),

      ),
    );

  }

}
