import 'package:ctrip_flutter/pages/home_page.dart';
import 'package:ctrip_flutter/pages/my_page.dart';
import 'package:ctrip_flutter/pages/search_page.dart';
import 'package:ctrip_flutter/pages/travel_page.dart';
import 'package:flutter/material.dart';

class MainNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainNavigatorState();
  }

}

class _MainNavigatorState extends State<MainNavigator> {

  //激活与默认状态的颜色
  final defaultColor = Colors.grey;
  final activeColor = Colors.blue;

  //当前页面索引
  var currIndex = 0;

  // PageView 的控制器 默认显示第一个页面
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView( // 和 Android 中的 ViewPager 类似
        controller: controller,
        children: <Widget>[ // 四个导航页面
          HomePage(),
          SearchPage(showLeftView: false, hint: '酒店、车票、旅游、攻略',),
          TravelPage(),
          MyPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currIndex,
          onTap: (index){ //点击
            if(currIndex != index) { //已在当前页面就不跳转了
              controller.jumpToPage(index); //控制 PageView 跳转到第 index 个页面
              setState(() {
                currIndex = index; //告知 BottomNavigationBar 改变状态，选中第 index 个 item
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: defaultColor,),
              activeIcon: Icon(Icons.home, color: activeColor,),
              title: Text('首页', style: TextStyle(color: currIndex == 0 ? activeColor : defaultColor),)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: defaultColor,),
                activeIcon: Icon(Icons.search, color: activeColor,),
                title: Text('搜索', style: TextStyle(color: currIndex == 1 ? activeColor : defaultColor),)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt, color: defaultColor,),
                activeIcon: Icon(Icons.camera_alt, color: activeColor,),
                title: Text('旅拍', style: TextStyle(color: currIndex == 2 ? activeColor : defaultColor),)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, color: defaultColor,),
                activeIcon: Icon(Icons.account_circle, color: activeColor,),
                title: Text('我的', style: TextStyle(color: currIndex == 3 ? activeColor : defaultColor),)
            ),
          ]),
    );
  }

}