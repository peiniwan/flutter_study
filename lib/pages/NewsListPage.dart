import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:banner_view/banner_view.dart';
import 'package:flutter_study/utils/WidgetsUtils.dart';
import 'package:flutter_study/utils/net/Api.dart';
import 'package:flutter_study/utils/net/Http.dart';

import 'NewsDetailPage.dart';

// 资讯列表页面
class NewsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewsListPageState();
  }
}

class NewsListPageState extends State<NewsListPage> {
// 轮播图的数据
  var slideData = [];

  // 列表的数据（轮播图数据和列表数据分开，但是实际上轮播图和列表中的item同属于ListView的item）
  var listData = [];

  // 总数
  var listTotalSize;

  // 列表中资讯标题的样式
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);

  // 时间文本的样式
  TextStyle subtitleStyle =
      new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

//  作者style
  TextStyle authorStyle =
      new TextStyle(color: const Color(0xFF000000), fontSize: 12.0);

  // 分页
  var _mCurPage = 0;

  WidgetsUtils mWidgetsUtils;

  @override
  void initState() {
    super.initState();
    getNewsList(_mCurPage);
    getBannerList();
  }

  @override
  Widget build(BuildContext context) {
    mWidgetsUtils = new WidgetsUtils(context);
    if (listData.length == 0) {
      return new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      );
    } else {
      return new Refresh(
        onFooterRefresh: onFooterRefresh,
        onHeaderRefresh: onHeaderRefresh,
        childBuilder: (BuildContext context,
            {ScrollController controller, ScrollPhysics physics}) {
          return new Container(
              child: new ListView.builder(
                  // 这里itemCount是将轮播图组件、分割线和列表items都作为ListView的item算了
                  itemCount: listData.length * 2 + 1,
                  controller: controller,
                  physics: physics,
                  itemBuilder: (context, i) => renderRow(i)));
        },
      );
    }
  }

  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _mCurPage++;
        getNewsList(_mCurPage);
      });
    });
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _mCurPage = 1;
        getBannerList();
        getNewsList(_mCurPage);
      });
    });
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
        });
      } catch (e) {
        print('错误catch s $e');
      }
    });
  }

  // 渲染列表item
  Widget renderRow(i) {
    // i为0时渲染轮播图
    if (i == 0) {
      return new Container(
        height: 180.0,
        child: new BannerView(mWidgetsUtils.getBannerChild(context, slideData),
            intervalDuration: const Duration(seconds: 3),
            animationDuration: const Duration(milliseconds: 500)),
      );
    }
    // i > 0时
    i -= 1;
    // i为奇数，渲染分割线
    if (i.isOdd) {
      return new Divider(height: 1.0);
    }
    // 将i取整
    i = i ~/ 2;
    // 得到列表item的数据
    var itemData = listData[i];
    // 代表列表item中的标题这一行
    var titleRow = new Row(
      children: <Widget>[
        // 标题充满一整行，所以用Expanded组件包裹
        new Expanded(
          child: new Text(itemData['title'], style: titleTextStyle),
        )
      ],
    );
    // 时间这一行包含了作者头像、时间、评论数这几个
    var timeRow = new Row(
      children: <Widget>[
        // 这是作者头像，使用了圆形头像
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            // 通过指定shape属性设置图片为圆形
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: new DecorationImage(
                image: new AssetImage('./images/author.png'),
                fit: BoxFit.cover),
            border: new Border.all(
              color: const Color(0xFFECECEC),
              width: 2.0,
            ),
          ),
        ),
        // 这是时间文本
        new Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
          child: new Text(
            itemData['author'],
            style: subtitleStyle,
          ),
        ),
        // 这是评论数，评论数由一个评论图标和具体的评论数构成，所以是一个Row组件
        new Expanded(
          flex: 1,
          child: new Row(
            // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData['selfVisible']}", style: subtitleStyle),
              new Padding(
                padding: new EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                child: new Image.asset('./images/ic_comment.png',
                    width: 16.0, height: 16.0),
              )
            ],
          ),
        )
      ],
    );
    var thumbImgUrl = itemData['thumb'];
    // 这是item右侧的资讯图片，先设置一个默认的图片
    var thumbImg = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(
            image: new ExactAssetImage('./images/ic_img_default.jpg'),
            fit: BoxFit.cover),
        border: new Border.all(
          color: const Color(0xFFECECEC),
          width: 2.0,
        ),
      ),
    );
    // 如果上面的thumbImgUrl不为空，就把之前thumbImg默认的图片替换成网络图片
    if (thumbImgUrl != null && thumbImgUrl.length > 0) {
      thumbImg = new Container(
        margin: const EdgeInsets.all(10.0),
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFECECEC),
          image: new DecorationImage(
              image: new NetworkImage(thumbImgUrl), fit: BoxFit.cover),
          border: new Border.all(
            color: const Color(0xFFECECEC),
            width: 2.0,
          ),
        ),
      );
    }
    // 这里的row代表了一个ListItem的一行
    var row = new Row(
      children: <Widget>[
        // 左边是标题，时间，评论数等信息
        new Expanded(
          flex: 1, //占用剩余的部分
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                titleRow,
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
        // 右边是资讯图片
        new Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: new Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );
    // 用InkWell包裹row，让row可以点击
    return new InkWell(
      child: row,
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
          return new NewsDetailPage(itemData['link'],itemData['title']);
        }));
      },
    );
  }
}
