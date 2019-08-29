import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/dao/travel_tab_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => new _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _tabController;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///初始化tab数据
  void _loadData() {
    _tabController = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      //fix tab label 空白问题
      _tabController = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
              controller: _tabController,
              //是否可滚动
              isScrollable: true,
              //tab 标签颜色
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              //指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Color(0xff1fcfbb),
                  width: 3,
                ),
                insets: EdgeInsets.only(bottom: 10),
              ),
              //设置tabbar 的标签显示内容，一般使用Tab对象,当然也可以是其他的Widget
              tabs: tabs.map((TravelTab tab) {
                return Tab(text: tab.labelName);
              }).toList(),
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((TravelTab tab) {
                return TravelTabPage(
                  travelUrl: travelTabModel.url,
                  groupChannelCode: tab.groupChannelCode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
