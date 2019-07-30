import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/widgets/grid_nav.dart';
import 'package:flutter_trip/widgets/loading_container.dart';
import 'package:flutter_trip/widgets/local_nav.dart';
import 'package:flutter_trip/widgets/sales_box.dart';
import 'package:flutter_trip/widgets/search_bar.dart';
import 'package:flutter_trip/widgets/sub_nav.dart';
import 'package:flutter_trip/widgets/webview.dart';

//appbar 滚动最大距离
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //appBar透明度
  double appBarAlpha = 0;

  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;

  //是否显示加载框
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  ///监听列表滚动距离计算透明度
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  ///网络请求
  Future<Null> _handleRefresh() async {
    /* HomeDao.fetch().then((result) {
      setState(() {
        resultString = json.encode(result);
        localNavList = result.localNavList;
        bannerList = result.bannerList;
        gridNavModel = result.gridNav;
      });
    }).catchError((e) {
      print(e);
    });*/
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        bannerList = model.bannerList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              //下拉刷新
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    //正在滚动
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      //scrollNotification.depth == 0 只检测ListView的滚动
                      //滚动且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: _listView,
                ),
              ),
            ),
            //appbar透明度处理
            _appBar,
          ],
        ),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        //活动轮播图
        _banner,
        //球区导航
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        //网格卡片
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        //活动入口
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        //活动入口
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(salesBox: salesBoxModel),
        ),
      ],
    );
  }

  ///活动轮播图
  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true, //自动播放开关.
        pagination: SwiperPagination(), //分页指示器
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    CommonModel model = bannerList[index];
                    return WebView(
                      title: model.title,
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      hideAppBar: model.hideAppBar,
                    );
                  },
                ),
              );
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  ///appbar透明度处理
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            //AppBar 渐变遮罩背景
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)],
          ),
        ),
      ],
    );
  }

  ///跳转到搜索页
  _jumpToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
              hint: SEARCH_BAR_DEFAULT_TEXT,
            ),
      ),
    );
  }

  _jumpToSpeak() {}
}
