import 'dart:convert';

import 'package:banner_view/banner_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:flutter_study/utils/WidgetsUtils.dart';
import 'package:flutter_study/utils/net/Api.dart';
import 'package:flutter_study/utils/net/Http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'NewsDetailPage.dart';

class MyNewsListPager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyNewsListPagerState();
  }
}

class MyNewsListPagerState extends State<MyNewsListPager> {
  var listData = [];
  List<Widget> datas;

// 轮播图的数据
  var slideData = [];

  RefreshController _controller = RefreshController(initialRefresh: false);
  var _mCurPage = 1;
  WidgetsUtils mWidgetsUtils;

  @override
  void initState() {//只执行一次
    super.initState();
    getBannerList();
    getNewsList(_mCurPage);
  }

  // 获取文章列表数据
  getNewsList(int curPage) {
    var url = Api.HOME_ARTICLE + curPage.toString() + "/json";
    Http.get(url).then((res) {
      try {
        Map<String, dynamic> map = jsonDecode(res);
        setState(() {
          var _listData = map['data']['datas'];
          if (curPage == 1) {
            listData.clear();
            listData.addAll(_listData);
          } else {
            listData.addAll(_listData);
          }
          datas = getList();
          if (curPage == 1) {
            _controller.refreshCompleted();
          } else {
            if (mounted) setState(() {});
            _controller.loadComplete();
          }
        });
      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mWidgetsUtils = new WidgetsUtils(context);
    if (listData.length == 0) {
      return new Center(
          child: new CircularProgressIndicator(
        backgroundColor: Colors.green,
      ));
    } else {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: ClassicFooter(
          loadStyle: LoadStyle.ShowAlways,
          completeDuration: Duration(microseconds: 50),
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        controller: _controller,
        child: ListView.builder(
            itemBuilder: _itemBuilder, itemCount: datas.length),
      );
    }
  }

  void _onRefresh() async {
    return new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        _mCurPage = 1;
        getBannerList();
        getNewsList(_mCurPage);
      });
    });
  }

  void _onLoading() async {
    return new Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        _mCurPage++;
        getNewsList(_mCurPage);
      });
    });
  }

  Widget _itemBuilder(BuildContext context, int position) {
    return Card(child: datas[position]);
  }

  List<Widget> getList() {
    List<Widget> models = [];
    if (slideData != null && slideData.length > 0) {
      models.add(getBanner());
    }
    for (var little in listData) models.add(new Item(little));
    return models;
  }

  //  获取Banner数据
  getBannerList() {
    Http.get(Api.HOME_BANNER).then((res) {
      Map<String, dynamic> map = jsonDecode(res);
      setState(() {
        slideData = map['data'];
      });
    });
  }

  Widget getBanner() {
    return Container(
      height: 180.0,
      child: new BannerView(mWidgetsUtils.getBannerChild(context, slideData),
          intervalDuration: const Duration(seconds: 3),
          animationDuration: const Duration(milliseconds: 500)),
    );
  }
}

class Item extends StatelessWidget {
  String title;
  String author;
  int selfVisible;
  var little;

  Item(this.little);

  @override
  Widget build(BuildContext context) {
    title = little["title"];
    author = little["author"];
    selfVisible = little["selfVisible"];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new NewsDetailPage(little['link'], little['title']);
        }));
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[titleStyle(), bottomStyle()],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: rightImageStyle(),
          )
        ],
      ),
    );
  }

  Container rightImageStyle() {
    return Container(
      width: 100,
      height: 80,
      color: const Color(0xFFECECEC),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: new ExactAssetImage('./images/ic_img_default.jpg'),
                  fit: BoxFit.cover),
              border: Border.all(color: Colors.amber, width: 2)),
        ),
      ),
    );
  }

  Padding bottomStyle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                // 通过指定shape属性设置图片为圆形
                shape: BoxShape.circle,
                color: const Color(0xFFECECEC),
                image: DecorationImage(
                    image: AssetImage('./images/author.png'),
                    fit: BoxFit.cover),
                border: Border.all(
                  color: const Color(0xFFECECEC),
                  width: 2.0,
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Text(author,
                style: TextStyle(color: Color(0xFFB5BDC0), fontSize: 12.0)),
          ),
          // 这是评论数，评论数由一个评论图标和具体的评论数构成，所以是一个Row组件
          Expanded(
            flex: 1,
            child: Row(
              // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("${selfVisible}",
                    style: TextStyle(color: Color(0xFFB5BDC0), fontSize: 12.0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: Image.asset('./images/ic_comment.png',
                      width: 16, height: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Row titleStyle() {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title, style: new TextStyle(fontSize: 15.0)))
      ],
    );
  }
}
