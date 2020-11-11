import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/WidgetsUtils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsDetailPage extends StatefulWidget {
  String _url, _title;

  NewsDetailPage(this._url, this._title);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState(_url, _title);
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  WidgetsUtils widgetsUtils;

  bool _isLoading = true;
  String _url, _title;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  // URL变化监听器
  StreamSubscription<String> _onUrlChanged;

  _NewsDetailPageState(this._url, this._title);

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((url) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    //组件移除
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widgetsUtils = new WidgetsUtils(context);
    return new WebviewScaffold(
      appBar: new AppBar(
        // automaticallyImplyLeading: false,//去掉返回键，leading返回键
        title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getAppBar(),
        ),
        iconTheme: new IconThemeData(color: Colors.black),
        actions: <Widget>[
          new IconButton(
            // action button
            icon: new Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        // leading: Container(
        //     // 绘制返回键
        //     margin: EdgeInsets.fromLTRB(10,10,10,10), // 设置边距
        //     decoration: BoxDecoration(
        //       boxShadow: <BoxShadow>[
        //         BoxShadow(
        //           offset: Offset(1, 2), // 阴影起始位置
        //           blurRadius: 5, // 阴影面积
        //           color: Colors.grey.withOpacity(.4), // 阴影透明度
        //         )
        //       ],
        //       color: Colors.white, // Container背景色
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(100.0), // Container设置为圆形
        //       ),
        //     ),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back_ios,
        //         size: 20,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context); // 关闭当前页面
        //       },
        //     ))
      ),
      url: _url,
    );
  }

  // 获取appbar
  List<Widget> _getAppBar() {
    List<Widget> appbarChildList = [];
    appbarChildList.add(widgetsUtils.getAppBar(_title));
    if (_isLoading) {
      //进度环是自带的
      appbarChildList.add(new CupertinoActivityIndicator());
    }
    return appbarChildList;
  }
}
