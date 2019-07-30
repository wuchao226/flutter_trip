import 'package:flutter/material.dart';

///枚举类型，home：首页状态下的SearchBar样式；
///normal：搜索状态下的SearchBar样式；
///homeLight：首页状态下高亮的SearchBar样式
enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  //是否禁止搜索
  final bool enabled;

  //左边按钮是否隐藏
  final bool hideLeft;

  //SearchBar样式
  final SearchBarType searchBarType;

  //默认提示文案
  final String hint;

  //传递到搜索框的默认值
  final String defaultText;

  //左边按钮点击回调
  final void Function() leftButtonClick;

  //右边按钮点击回调
  final void Function() rightButtonClick;

  //语音按钮点击回调
  final void Function() speakClick;

  //输入框点击回调
  final void Function() inputBoxClick;

  //内容变化回调
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  //是否显示clear按钮
  bool showClear = false;

  //动态获取搜索输入框内容的变化
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    //带入搜索输入框中的默认值
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //根据 SearchBarType 类型绘制不同的 SearchBar 样式
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch()
        : _getHomeSearch();
  }

  ///搜索状态下的搜索框
  _getNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget?.hideLeft ?? false
                  ? null
                  : Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 26,
                    ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.rightButtonClick),
        ],
      ),
    );
  }

  ///首页状态下的搜索框
  _getHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
              child: Row(
                children: <Widget>[
                  Text(
                    '上海',
                    style: TextStyle(color: _homeFontColor(), fontSize: 14),
                  ),
                  Icon(
                    Icons.expand_more,
                    color: _homeFontColor(),
                    size: 22,
                  ),
                ],
              ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.rightButtonClick),
        ],
      ),
    );
  }

  ///输入框
  _inputBox() {
    //输入框颜色
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
            widget.searchBarType == SearchBarType.normal ? 5 : 15),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffA9A9A9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    //输入文本样式
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      border: InputBorder.none,
                      hintText: widget.hint ?? '',
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(
                  Icon(
                    Icons.clear,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ), () {
                  setState(() {
                    //清空
                    _controller.clear();
                  });
                  //将内容清空
                  _onChanged('');
                })
        ],
      ),
    );
  }

  ///监听器
  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  ///搜索框内容变化监听
  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  //首页前景色
  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
