import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

///白名单，携程首页h5可能出现的地址
const CATCH_URLS = [
  'm.ctrip.com/',
  'm.ctrip.com/html5/',
  'm.ctrip.com/html5',
];

class WebView extends StatefulWidget {
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;
  final bool backForbid; //是否禁用返回按钮

  WebView(
      {this.title,
      this.url,
      this.statusBarColor,
      this.hideAppBar,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  ///网页是否返回过，防止重复返回
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    //关闭webview;防止页面重新打开
    flutterWebviewPlugin.close();
    //监听url地址改变事件
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    //监听web页加载状态
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          //返回主页面（即WebView的上一页）
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              //禁止返回，重新打开当前页
              flutterWebviewPlugin.launch(widget.url);
            } else {
              Navigator.pop(context);
              //防止重复返回
              exiting = true;
            }
          }
          break;
        case WebViewState.finishLoad:
          break;
        case WebViewState.abortLoad:
          break;
        default:
          break;
      }
    });
    //加载网页错误监听
    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  ///是否返回主页面（即WebView的上一页）
  _isToMain(String url) {
    bool contain = false;
    for (String value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? "ffffff";
    Color backButtonColor;
    //如果状态栏的颜色是白色，返回按钮颜色是黑色
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              //是否允许网页缩放
              withZoom: true,
              withLocalStorage: true,
              //url加载之前隐藏
              hidden: true,
              //隐藏过程中显示的布局
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Wait ......',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///标题栏，backgroundColor：背景色，backButtonColor：返回按钮颜色
  _appBar(Color backgroundColor, Color backButtonColor) {
    //widget.hideAppBar为null值值为false
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      color: backButtonColor,
      child: FractionallySizedBox(
        //撑满父布局的宽度
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            //返回按钮
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(
                  Icons.arrow_back,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            //标题
            Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    widget.title ?? "",
                    style: TextStyle(color: backButtonColor, fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
