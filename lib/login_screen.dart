import 'package:dio/dio.dart';
import 'package:onemc/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'utils/constant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final controller = ScrollController();
  double offset = 0;
  bool _isSelected = false;
  String? _loginRes;
  TencentLoginResp? _loginResp;
  bool passwordInvisible = true;
  TextEditingController accountController = new TextEditingController();
  TextEditingController passwdController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/barbecue.svg",
              textTop: "在这里",
              textBottom: "学习和分享代码",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("登录",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6)),
                          SizedBox(
                            height: 30,
                          ),
                          Text("账号",
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 26)),
                          TextField(
                            controller: accountController,
                            decoration: InputDecoration(
                                hintText: "手机号/邮箱/用户名",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("密码",
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 26)),
                          TextFormField(
                            controller: passwdController,
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordInvisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                                hintText: "**********",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("记住密码", style: TextStyle(fontSize: 12))
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: kActiveShadowColor,
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _tryLogin();
                              },
                              child: Center(
                                child: Text("登录",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("社交帐号登录",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    color: kActiveShadowColor,
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                loginQQ();
                              },
                              child: Center(
                                child: Text("QQ登录",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "新用户？",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text("注册",
                            style: TextStyle(color: Color(0xFF5d74e3))),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 60,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  _tryLogin() async {
    var dio = Dio();
    var formData = FormData.fromMap({
      'account': accountController.value.text,
      'passwd': md5.convert(utf8.encode(passwdController.value.text)).toString(),
      'app_login': 'true',
      'app_version': 'alpha.channel',
      'app_source': 'onemc'
    });
    var response = await dio.post('https://user.1mc.site/api/user/login', data: formData);
    print(response.data);
    if(response.data['code']!=200){
      wrongMsg(response.data['msg']);
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', response.data['user_token']);
      Fluttertoast.showToast(
        msg: "登录成功~",
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.of(context).pop();
    }
  }
  loginQQ() async {
    diag('仍在调试中。');
    Tencent.instance.login(
      scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
    );
    if ((_loginResp?.isSuccessful ?? false) &&
        !(_loginResp!.isExpired ?? true)) {
      final TencentUserInfoResp userInfo = await Tencent.instance.getUserInfo(
        appId: '1108306556',
        openid: _loginResp!.openid!,
        accessToken: _loginResp!.accessToken!,
      );
      if (userInfo.isSuccessful) {
        diag('用户信息' +
            '${userInfo.nickname} - ${userInfo.gender} - ${userInfo.genderType}');
      } else {
        diag('用户信息' + '${userInfo.ret} - ${userInfo.msg}');
      }
    } else {
      diag('msg: ' + _loginResp!.msg!);
    }
    print('MSG:' + _loginResp!.msg!);
  }

  void _showTips(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  diag(msg) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('DEBUG 提示'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  wrongMsg(msg) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('啊哦~ 登录失败'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
