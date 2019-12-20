import 'package:flutter_study/domain/UserInfoBean.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const SP_ID = 'sp_id';
  static const SP_NAME = 'sp_name';
  static const SP_EMAIL = 'sp_email';

  static const SP_TOKEN_TYPE = 'sp_token_type';
  static const SP_EXPIRES_IN = 'sp_expires_in';

  static const SP_COOKIE = 'sp_cookie';

//  获取用户信息
  static Future<UserInfoBean> getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString(SP_ID);
    var name = sharedPreferences.getString(SP_NAME);
    var email = sharedPreferences.getString(SP_EMAIL);
    UserInfoBean userInfoBean = new UserInfoBean(id, name, email);
    return userInfoBean;
  }

  static void saveCookie(var cookie) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SP_COOKIE, cookie);
  }

  //  把map转为UserInfoBean
  static Future<UserInfoBean> map2UserInfo(Map map) async {
    if (map != null) {
      var id = map['id'];
      var name = map['username'];
      var email = map['email'];
      UserInfoBean userInfoBean = new UserInfoBean(id, name, email);
      return userInfoBean;
    } else {
      return null;
    }
  }

  // 保存用户信息
  static void saveUserInfo(UserInfoBean userInfo) async {
    if (userInfo != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(SP_ID, userInfo.id.toString());
      sharedPreferences.setString(SP_NAME, userInfo.username);
      sharedPreferences.setString(SP_EMAIL, userInfo.email);
    }
  }
}
