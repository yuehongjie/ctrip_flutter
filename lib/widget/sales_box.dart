

import 'package:ctrip_flutter/model/common_model.dart';
import 'package:ctrip_flutter/model/sales_box_model.dart';
import 'package:ctrip_flutter/widget/web_view.dart';
import 'package:flutter/material.dart';

class SalesBox extends StatelessWidget {
  
   static const divider = BorderSide(color: Color(0xfff2f2f2), width: 0.8);
   
   final SalesBoxModel salesBoxModel;

  const SalesBox({Key key, @required this.salesBoxModel}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (salesBoxModel == null) return Container(width: 0.0, height: 0.0);
    return Column(
      children: <Widget>[
        _topView(context),
        _lineView(context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, 138),
        _lineView(context, salesBoxModel.smallCard1, salesBoxModel.smallCard2, 85),
        _lineView(context, salesBoxModel.smallCard3, salesBoxModel.smallCard4, 85),
      ],
    );
  }
  
  Widget _topView(BuildContext context){
    return Container(
      height: 48,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: divider,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(
            salesBoxModel.icon,
            height: 18,
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(0xffff4e63), Color(0xffff6cc9)],
              )
            ),
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: _wrapGesture(
              context,
              '更多福利',
              salesBoxModel.moreUrl,
              Text(
                '获取更多福利 >',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //每一行左右两个图片
  Widget _lineView(BuildContext context, CommonModel leftModel, CommonModel rightModel, double lineHeight){
    return Row(
      children: <Widget>[
        _imageItem(context, leftModel, lineHeight, false),
        _imageItem(context, rightModel, lineHeight, true),
      ],
    );
  }

  //每一个要显示的图片
  Widget _imageItem(BuildContext context, CommonModel model, double height, bool showLeftDivider) {

    //平分宽度
    return Expanded(
      flex: 1,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            left: showLeftDivider ? divider : BorderSide.none,
            bottom: divider,
          ),
        ),
        child: _wrapGesture(
            context,
            model.title,
            model.url,
            Image.network(
              model.icon,
              fit: BoxFit.fill,
            )
        ),
      ),
    );
  }

   //抽取点击事件，把需要被点击的控件，放入 GestureDetector 中
   _wrapGesture(BuildContext context, String title, String url, Widget child) {
     return GestureDetector(
       onTap: () {
         //跳转到 WebView 页面
         Navigator.push(context, MaterialPageRoute(builder: (context) =>
             WebView(
               title: title,
               url: url,
             )
         ));
       },
       child: child,
     );
   }
  
}
