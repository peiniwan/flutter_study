import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_study/domain/SystemClassBean.dart';
import 'package:flutter_study/pages/system/SystemListPage.dart';
import 'package:flutter_study/utils/net/Api.dart';
import 'package:flutter_study/utils/net/Http.dart';

class SystemPage extends StatefulWidget {
  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  var _treeList = [];

  var _titleStyle = new TextStyle(color: Colors.black, fontSize: 16.0);
  var _childStyle = new TextStyle(color: Color(0xFFB5BDC0), fontSize: 14.0);

  @override
  void initState() {
    super.initState();
    _getSystemTree();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: getBody(),
//      child: buildCustomScrollView()
    );
  }

  CustomScrollView buildCustomScrollView() {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverAppBar(
            pinned: false,
            expandedHeight: 180.0,
            iconTheme: new IconThemeData(color: Colors.transparent),
            flexibleSpace: new Image.asset(
              './images/ic_xiaoxin.jpg',
              fit: BoxFit.fill,
            )),
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          var _tempItems = _treeList[index];
          return Container(
              alignment: Alignment.centerLeft, child: normalItem(_tempItems));
        }, childCount: _treeList.length))
      ],
    );
  }

  String _childStr(var _tempItems) {
    var childList = _tempItems['children'] as List;
    StringBuffer _resultStr = new StringBuffer();
    for (var i = 0; i < childList.length; i++) {
      String name = childList[i]['name'];
      if (name.isNotEmpty) {
        _resultStr.write(name);
        _resultStr.write('         ');
      }
    }
    return _resultStr.toString();
  }

  _getSystemTree() {
    Http.get(Api.HOME_SYSTEM).then((res) {
      Map<String, dynamic> map = jsonDecode(res);
      var _tempTreeList = map['data'];
      if (_tempTreeList != null) {
        _treeList.addAll(_tempTreeList);
      }
    });
  }

  Widget _initClassData(var tempData) {
    var childList = tempData['children'] as List;
    List<SystemClassBean> systemCBean = [];
    for (var tempItem in childList) {
      systemCBean.add(new SystemClassBean(tempItem['id'], tempItem['name']));
    }
    return new SystemListPage(systemCBean, tempData['name']);
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  bool showLoadingDialog() {
    if (_treeList.length == 0) {
      return true;
    }
    return false;
  }

  getProgressDialog() {
    new Center(child: new CircularProgressIndicator());
  }

  ListView getListView() => ListView.builder(
      itemCount: _treeList.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  getRow(int position) {
    if (position == 0) {
      return Image.asset('./images/ic_xiaoxin.jpg', fit: BoxFit.fill);
    } else {
      var _tempItems = _treeList[position];
      return normalItem(_tempItems);
    }
  }

  InkWell normalItem(_tempItems) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return _initClassData(_tempItems);
          }));
        },
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        _tempItems['name'],
                        style: _titleStyle,
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: new Text(
                        _childStr(_tempItems),
                        style: _childStyle,
                        textAlign: TextAlign.start,
                      ),
                      alignment: Alignment.topLeft,
                    )
                  ],
                )),
            Divider(
              height: 1.0,
            )
          ],
        ));
  }
}
