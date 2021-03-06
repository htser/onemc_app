import 'package:onemc/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:onemc/login_screen.dart';
import 'package:onemc/theme.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'modal-screen.dart';

String? userToken;
dynamic userinfo = false;

class MainScreen extends StatelessWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  const MainScreen(
      {Key? key,
      required this.menuScreenContext,
      required this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          backgroundColor: Colors.indigo,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Test Text Field"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    this.onScreenHideButtonPressed();
                    Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new loginScreen()))
                        .then((result) async {
                      this.onScreenHideButtonPressed();
                    });
                  },
                  child: Text(
                    "??????",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    pushDynamicScreen(context,
                        screen: SampleModalScreen(), withNavBar: true);
                  },
                  child: Text(
                    "Push Dynamic/Modal Screen",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "?????????" + shortcut,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  },
                  child: Text(
                    "?????? Shortcuts ??????",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    this.onScreenHideButtonPressed();
                  },
                  child: Text(
                    this.hideStatus ? "???????????????" : "???????????????",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen2 extends StatelessWidget {
  const MainScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  pushNewScreen(context, screen: MainScreen3());
                },
                child: Text(
                  "Go to Third Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Go Back to First Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen3 extends StatelessWidget {
  const MainScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back to Second Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class Tokopedia extends StatefulWidget {
  @override
  _TokopediaState createState() => _TokopediaState();
}

class _TokopediaState extends State<Tokopedia> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  CurvedAnimationController<Color>? _animationBackground;
  CurvedAnimationController<Color>? _animationInput;
  CurvedAnimationController<Color>? _animationIcon;

  double get _systemBarHeight => 20;
  double get _appBarHeight => kToolbarHeight + _systemBarHeight;
  double get _appBarPaddingVertical => 10;
  double get _appBarPaddingTop => _systemBarHeight + _appBarPaddingVertical;
  double get _appBarPaddingBottom => _appBarPaddingVertical;

  Color _appbarBackgroundColorBegin = Colors.white.withOpacity(0.0);
  Color _appbarBackgroundColorEnd = Colors.white;

  Color _inputBackgroundColorBegin = Colors.white.withOpacity(0.92);
  Color _inputBackgroundColorEnd = Color(0xFFEFEFEF);

  Color _iconColorBegin = Colors.white.withOpacity(0.92);
  Color _iconColorEnd = Colors.grey;

  @override
  void initState() {
    _initAnimation();
    super.initState();
    _initScroll();
  }

  _initAnimation() {
    _animationBackground = CurvedAnimationController<Color>.tween(
      ColorTween(
          begin: _appbarBackgroundColorBegin, end: _appbarBackgroundColorEnd),
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationInput = CurvedAnimationController<Color>.tween(
      ColorTween(
          begin: _inputBackgroundColorBegin, end: _inputBackgroundColorEnd),
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationIcon = CurvedAnimationController<Color>.tween(
      ColorTween(begin: _iconColorBegin, end: _iconColorEnd),
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationBackground?.addListener(() => setState(() {}));
    _animationInput?.addListener(() => setState(() {}));
    _animationIcon?.addListener(() => setState(() {}));
  }

  _initScroll() {
    _scrollController.addListener(() {
      double startAnimationAfterOffset = 75;
      double scrollOffsetBackground = 150;
      double scrollOffsetInput = 150;
      double scrollOffsetIcon = 120;

      // delay animation to start animate only after scrolling
      // as far as startAnimationAfterOffset value
      // this is for a smoother effect
      double offset = _scrollController.offset - startAnimationAfterOffset;
      double progressBackground = offset / scrollOffsetBackground;
      double progressInput = offset / scrollOffsetInput;
      double progressIcon = offset / scrollOffsetIcon;

      // make sure progress animation always between 0.0 and 1.0
      progressBackground = progressBackground <= 0.0 ? 0.0 : progressBackground;
      progressBackground = progressBackground >= 1.0 ? 1.0 : progressBackground;

      // make sure progress animation always between 0.0 and 1.0
      progressInput = progressInput <= 0.0 ? 0.0 : progressInput;
      progressInput = progressInput >= 1.0 ? 1.0 : progressInput;

      // make sure progress animation always between 0.0 and 1.0
      progressIcon = progressIcon <= 0.0 ? 0.0 : progressIcon;
      progressIcon = progressIcon >= 1.0 ? 1.0 : progressIcon;

      _animationBackground?.progress = progressBackground;
      _animationInput?.progress = progressInput;
      _animationIcon?.progress = progressIcon;
    });
  }

  Widget get _appbar => Container(
        height: _appBarHeight,
        padding: EdgeInsets.only(
          top: _appBarPaddingTop,
          bottom: _appBarPaddingBottom,
        ),
        color: _animationBackground?.value,
        child: Row(
          children: [
            SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: _animationInput?.value,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    hintText: '????????????????????????',
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ),
            SizedBox(width: 13),
            IconButton(
              icon: Icon(Icons.message_rounded, color: _animationIcon?.value),
              onPressed: () {},
            ),
          ],
        ),
      );

  Widget get _content => SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: [Color(0xFF000046), Color(0xFF1CB5E0)],
                ),
              ),
            ),
            Container(height: 1, color: Color(0xFF000046)),
            Container(height: 1200, color: Color(0xFFEEEEEE)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _content,
          _appbar,
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
    GetUserInfo();
  }

  GetUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = await prefs.getString('user_token');
    if (userToken == null) {
      userinfo = false;
    } else {
      var dio = Dio();
      Map<String, dynamic> headers = new Map();
      headers['Cookie'] = 'user:' + userToken!;
      Options options = new Options(headers: headers);
      var uData = await dio.get('https://user.1mc.site/api/user/getme',
          options: options);
      print(uData.data);
      if (uData.data['code'] == 200) {
        setState(() {
          userinfo = uData;
        });
      }
    }
  }

  GetUCard() {
    if (userinfo == false || userinfo == null) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2 - 65,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 5,
              )
            ],
            color: tealTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: tealTheme.primaryColor,
                    borderRadius: BorderRadius.circular(52.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow,
                        spreadRadius: 2,
                      )
                    ]),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/qqface.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Text(
                '????????????',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2 - 65,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 5,
              )
            ],
            color: tealTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: tealTheme.primaryColor,
                    borderRadius: BorderRadius.circular(52.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow,
                        spreadRadius: 2,
                      )
                    ]),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userinfo.data['face']),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'UID: ' + userinfo.data['id'],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Text(
                userinfo.data['uname'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AccBBtn(
                      height: 60,
                      width: 80,
                      text: '????????????',
                      icon: Icons.person,
                      onTap: () {
                        print('test');
                      }),
                  AccBBtn(
                      height: 60,
                      width: 80,
                      text: '????????????',
                      icon: Icons.star,
                      onTap: () {
                        print('test');
                      }),
                  AccBBtn(
                      height: 60,
                      width: 80,
                      text: '????????????',
                      icon: Icons.settings,
                      onTap: () {
                        print('test');
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'OneMC',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            GetUCard(),
            Container(
              padding: EdgeInsets.only(top: 40, right: 34, left: 34),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AccBBtn(
                            text: '????????????',
                            icon: Icons.upload_rounded,
                            onTap: () {
                              print('test');
                            }),
                        AccBBtn(
                            text: '????????????',
                            icon: Icons.history,
                            onTap: () {
                              print('test');
                            }),
                        AccBBtn(
                            text: '?????????',
                            icon: Icons.code,
                            onTap: () {
                              print('test');
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AccBBtn(
                            text: '??????QQ???',
                            icon: Icons.add,
                            onTap: () {
                              print('test');
                            }),
                        AccBBtn(
                            text: 'Beta ??????',
                            icon: Icons.feedback,
                            onTap: () {
                              print('test');
                            }),
                        AccBBtn(
                            text: '?????? Beta',
                            icon: Icons.info,
                            onTap: () {
                              print('test');
                            })
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccBBtn extends StatelessWidget {
  AccBBtn({
    this.height = 60,
    this.width = 85,
    this.radius = 5,
    this.color = Colors.teal,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final Color color;
  final double height;
  final double width;
  final double radius;
  final String text;
  final IconData icon;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          child: new InkWell(
            onTap: onTap,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
