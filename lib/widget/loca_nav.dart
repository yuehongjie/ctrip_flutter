

import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

/*
 * 首页地址导航控件
 */
class LocalNav extends StatelessWidget {

  final List<CommonModel> localNavList;

  const LocalNav({Key key, @required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:BorderRadius.all(
          Radius.circular(6),
        ),
      ),


      child: Padding(
        padding: EdgeInsets.all(8),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {

    if(localNavList == null) return Container(width: 0.0, height: 0.0);

    List<Widget> items = [];

    localNavList.forEach((model){

      items.add(item(context, model));

    });

    //水平方向 平均排列
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );

  }

  // image + text
  Widget item(BuildContext context, CommonModel commonModel) {

    return GestureDetector(

      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {

                //景点~玩乐 链接打不开了，所以要替换
                var url;
                if(commonModel.url == 'https://m.ctrip.com/html5/ticket/') {
                  url = 'https://m.ctrip.com/webapp/vacations/tour/around?&from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F';
                }

                return WebView(
                  title: commonModel.title,
                  url: url ?? commonModel.url,
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
            width: 32,
            height: 32,
          ),
          Text(
            commonModel.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),

    );

  }

}
