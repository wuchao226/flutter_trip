import 'package:flutter/material.dart';
//加载进度条组件
class LoadingContainer extends StatelessWidget {
  //显示完进度条后显示的内容
  final Widget child;

  //显示进度条还是child
  final bool isLoading;

  //是否覆盖页面的布局（即是否放在child页面之上）
  final bool cover;

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : null],
          );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
