import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';

///语音识别
class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

///需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  String speakTips = '长按说话';
  String speakResult = '';
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    //创建 AnimationController 对象 AnimationController 用于控制动画，它包含动画的启动forward()、停止stop() 、反向播放 reverse()等方法。
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    //CurvedAnimation来指定动画的曲线;Curves.easeIn 开始慢，后面快
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 动画结束时，反转从尾到头播放，结束的状态是 dismissed
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // 重新从头到尾播放
          controller.forward();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _topItem(),
            _bottomItem(),
          ],
        ),
      ),
    );
  }

  ///顶部视图
  _topItem() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            speakResult,
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  ///底部视图
  _bottomItem() {
    //根据父容器宽高的百分比来设置子组件宽高
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    speakTips,
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      //占坑，避免动画执行过程中导致父布局大小变化
                      width: MIC_SIZE,
                      height: MIC_SIZE,
                    ),
                    Center(
                      child: AnimatedMic(
                        animation: animation,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //右边关闭按钮
          Positioned(
            right: 0,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _speakStart() {
    controller.forward();
    setState(() {
      speakTips = "- 识别中 -";
    });
    AsrManager.start().then((text) {
      if (text != null && text.length > 0) {
        setState(() {
          speakResult = text;
        });
        //先关闭当前页面，在跳转
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              keyword: speakResult,
            ),
          ),
        );
      }
    }).catchError((e) {
      print(e);
    });
  }

  void _speakStop() {
    setState(() {
      speakTips = "长按说话";
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }
}

const double MIC_SIZE = 80;

///AnimatedWidget会自动调用addlistener和setState
class AnimatedMic extends AnimatedWidget {
  //透明度改变动画
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);

  //大小改变动画
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // 外部传递过来的 Animation 对象
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        //evaluate(Animation<double> animation) 获取动画当前映射值
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(MIC_SIZE / 2),
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
