import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

/// 底部页面+导航
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => new _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  // 默认颜色 未选中
  final _defaultColor = Colors.grey;

  // 选中状态下颜色
  final _activeColor = Colors.blue;

  // 当前索引 选中 控制选中哪个页面
  int _currentIndex = 0;

  // 管理pageView
  final PageController _controller = new PageController(
    //初始页面
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        // children显示得是页面 四个主页面
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true),
          TravelPage(),
          MyPage(),
        ],
        //关闭整个页面的联动
        physics: NeverScrollableScrollPhysics(),
      ),
      // 底部导航
      bottomNavigationBar: BottomNavigationBar(
        //当前索引 第几页
        currentIndex: _currentIndex,
        //切换当前索引
        onTap: (index) {
          //跳转到相应页面
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        //将item固定
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem(Icons.home, '首页', 0),
          _bottomItem(Icons.search, '搜索', 1),
          _bottomItem(Icons.camera_alt, '旅拍', 2),
          _bottomItem(Icons.account_circle, '我的', 3),
        ],
      ),
    );
  }

  ///底部导航item
  _bottomItem(IconData iconData, String title, int index) {
    return BottomNavigationBarItem(
      icon: Icon(iconData, color: _defaultColor),
      activeIcon: Icon(iconData, color: _activeColor),
      title: Text(
        title,
        style: TextStyle(
            color: _currentIndex == index ? _activeColor : _defaultColor),
      ),
    );
  }
}
