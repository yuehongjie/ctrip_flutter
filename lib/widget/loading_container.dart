

import 'package:flutter/material.dart';


///加载中进度指示器
class LoadingContainer extends StatelessWidget {

  ///加载完成后显示的 widget
  final Widget child;
  ///是否正在加载中
  final bool isLoading;

  const LoadingContainer({Key key, @required this.isLoading,  @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //print('isLoading: $isLoading');

    return Stack(
      children: <Widget>[
        child,
        isLoading ? _loadingProgress : Container(width: 0.0,height: 0.0),
      ],
    );

  }

  /// 加载进度 widget (这是一个变量，提供 get 方法)
  Widget get _loadingProgress {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
