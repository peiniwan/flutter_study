import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/app/OsApplication.dart';
import 'package:flutter_study/domain/event/LoginEvent.dart';
import 'package:flutter_study/utils/cache/SpUtils.dart';

import 'UserInfoPage.dart';
import 'login/LoginPage.dart';


class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var userAvatar;
  var userName;
  var titles = [
    "我的消息",
    "阅读记录",
    "我的博客",
    "我的问答",
    "我的活动",
    "我的团队",
    "邀请好友",
    "我的消息",
    "阅读记录",
    "我的博客",
    "我的问答",
    "我的活动",
    "我的团队",
    "邀请好友"
  ];
  var imagePaths = [
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png",
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png"
  ];

  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    'images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  @override
  void initState() {
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        if (event != null && event.userName != null) {
          userName = event.userName;
          userAvatar = 'https://www.wanandroid.com/resources/image/pc/logo.png';
        } else {
          userName = null;
          userAvatar = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return initView();
  }



  //  构建布局
  Widget initView() {
    var listView = new ListView.builder(
      itemBuilder: (context, i) => renderRow(context, i),
      itemCount: titles.length * 2,//一个头部+真实条数+真实条数-1条分割线=真实条数2。分割线
    );
    return listView;
    return Container(
        //去掉也可以
        child: new CustomScrollView(
            reverse: false,
            shrinkWrap: false,
            slivers: <Widget>[
          new SliverAppBar(
            //AppBar 和 SliverAppBar 都是继承StatefulWidget 类，都代表 Toobar，
            // 二者的区别在于 AppBar 位置的固定的应用最上面的；而 SliverAppBar 是可以跟随内容滚动的。
            pinned: false,
            //固定导航
            backgroundColor: Colors.green,
            expandedHeight: 200.0,
            iconTheme: new IconThemeData(color: Colors.transparent),
            flexibleSpace: new InkWell(
                //包裹了一个InkWell，用于提供点击事件
                onTap: () {
                  userAvatar == null ? _login() : _userDetail();
                },
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    userAvatar == null
                        ? new Image.asset(
                            "images/ic_avatar_default.png",
                            width: 60.0,
                            height: 60.0,
                          )
                        : new Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                image: new DecorationImage(
                                    image: new NetworkImage(userAvatar),
                                    fit: BoxFit.cover),
                                border: new Border.all(
                                    color: Colors.white, width: 2.0)),
                          ),
                    new Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new Text(
                        userName == null ? '点击头像登录' : userName,
                        style:
                            new TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    )
                  ],
                )),
          ),
          new SliverFixedExtentList(
              delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                String title = titles[index];
                return new Container(
                    alignment: Alignment.centerLeft,
                    child: new InkWell(
                      onTap: () {
                        print("the is the item of $title");
                      },
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 15.0),
                            child: new Row(
                              children: <Widget>[
                                new Image.asset(
                                  imagePaths[index],
                                  width: IMAGE_ICON_WIDTH,
                                  height: IMAGE_ICON_WIDTH,
                                ),
                                new Expanded(
                                    //填充
                                    child: new Text(
                                  title,
                                  style: titleTextStyle,
                                )),
                                rightArrowIcon,
                              ],
                            ),
                          ),
                          new Divider(
                            height: 1.0,
                          )
                        ],
                      ),
                    ));
              }, childCount: titles.length),
              itemExtent: 61.0),
        ]));
  }

  _login() async {
    final result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) {
      return new LoginPage();
    }));
    if (result != null && result == 'refresh') {
      _getUserInfo();
    }
  }

  _userDetail() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new UserInfoPage();
    }));
  }

  _getUserInfo() async {
    SpUtils.getUserInfo().then((userInfoBean) {
      if (userInfoBean != null && userInfoBean.username != null) {
        setState(() {
          userName = userInfoBean.username;
          userAvatar = 'https://www.wanandroid.com/resources/image/pc/logo.png';
        });
      }
    });
  }

  renderRow(BuildContext context, int i) {
    final userHeaderHeight = 200.0;
    if (i == 0) {
      var userHeader = new Container(
          height: userHeaderHeight,
          color: Colors.green,
          child: new Center(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? new Image.asset(
                      "images/ic_avatar_default.png",
                      width: 60.0,
                    )
                  : new Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: new DecorationImage(
                              image: new NetworkImage(userAvatar),
                              fit: BoxFit.cover),
                          border:
                              new Border.all(color: Colors.white, width: 2.0)),
                    ),
              new Container(
                margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: new Text(
                  userName == null ? '点击头像登录' : userName,
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              )
            ],
          )));
      return new GestureDetector( //用于提供点击事件
        onTap: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new LoginPage()));
        },
        child: userHeader,
      );
    }
    --i;
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;//向下取整
    String title = titles[i];
    var listItemContent = new Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
            title,
            style: titleTextStyle,
          )),
          rightArrowIcon
        ],
      ),
    );
    return new InkWell(
      child: listItemContent,
      onTap: () {},
    );
  }
}
