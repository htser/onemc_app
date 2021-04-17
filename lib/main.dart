import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme.dart';
import 'pages/screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tencent_kit/tencent_kit.dart';
import 'package:quick_actions/quick_actions.dart';

const String _TENCENT_APPID = '1108306556';
String shortcut = "NO";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Tencent.instance.registerApp(appId: _TENCENT_APPID);
  runApp(MyApp());
}
BuildContext? testContext;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneMC',
      theme: tealTheme,
      home: MainIndex(menuScreenContext: context,),
      initialRoute: '/',
      routes: {
        '/first': (context) => MainScreen2(),
        '/second': (context) => MainScreen3(),
      },
    );
  }
}

// ============== [ Main Index Page ] ===============

class MainIndex extends StatefulWidget {
  final BuildContext menuScreenContext;
  MainIndex({Key? key, required this.menuScreenContext}) : super(key: key);
  @override
  _MainIndexState createState() => _MainIndexState();
}

class _MainIndexState extends State<MainIndex> {
  late final StreamSubscription<TencentLoginResp> _login =
  Tencent.instance.loginResp().listen(_listenLogin);
  late final StreamSubscription<TencentSdkResp> _share =
  Tencent.instance.shareResp().listen(_listenShare);
  TencentLoginResp? _loginResp;
  PersistentTabController? _controller;
  bool _hideNavBar = false;
  void _listenLogin(TencentLoginResp resp) {
    _loginResp = resp;
    final String content = 'login: ${resp.openid} - ${resp.accessToken}';
    _showTips('登录', content);
  }

  void _listenShare(TencentSdkResp resp) {
    final String content = 'share: ${resp.ret} - ${resp.msg}';
    _showTips('分享', content);
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

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;

    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: 'action_one',
        localizedTitle: 'Action one',
        icon: 'AppIcon',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
          type: 'action_two',
          localizedTitle: 'Action two',
          icon: 'ic_launcher'),
    ]);
  }

  List<Widget> _buildScreens() {
    return [
      Tokopedia(),
      MainScreen(
        menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      MainScreen(
        menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onScreenHideButtonPressed: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      WebSandboxPage(),
      MyHomePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "主页",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.waves),
        title: ("动态"),
        activeColorPrimary: Colors.pink,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.add),
          title: ("投稿"),
          activeColorPrimary: Colors.blueAccent,
          activeColorSecondary: Colors.cyan,
          inactiveColorPrimary: Colors.grey,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            initialRoute: '/',
            routes: {
              '/first': (context) => MainScreen2(),
              '/second': (context) => MainScreen3(),
            },
          ),
          onPressed: (c) {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                useRootNavigator: true,
                builder: (context) => Container(
                      padding: EdgeInsets.only(top: 40, right: 34, left: 34),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                AccBBtn(
                                    color: Colors.blue,
                                    text: '代码',
                                    icon: Icons.code,
                                    onTap: () {
                                      print('test');
                                    }),
                                AccBBtn(
                                    color: Colors.blue,
                                    text: '视频',
                                    icon: Icons.play_arrow,
                                    onTap: () {
                                      print('test');
                                    }),
                                AccBBtn(
                                    color: Colors.blue,
                                    text: '文章',
                                    icon: Icons.article,
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
                                    color: Colors.blue,
                                    text: '动态',
                                    icon: Icons.cloud,
                                    onTap: () {
                                      print('test');
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
          }),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.code),
        title: ("沙盒"),
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("我"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => MainScreen2(),
            '/second': (context) => MainScreen3(),
          },
        ),
      ),
    ];
  }
  bool isTimerRunning = false;
  startTimeout([int? milliseconds]) {
    isTimerRunning = true;
    var timer = new Timer.periodic(new Duration(seconds: 2), (time) {
      isTimerRunning = false;
      time.cancel();
    });
  }
  void _showToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: "再按一次就可以退出了哦~",
      toastLength: Toast.LENGTH_SHORT,
    );
  }
  Future<bool> _willPopCallback() async {
    int stackCount = Navigator.of(context).getNavigationHistory().length;
    if (stackCount == 1) {
      if (!isTimerRunning) {
        startTimeout();
        _showToast(context);
        return false;
      } else
        return true;
    } else {
      isTimerRunning = false;
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        onWillPop: (context) async {
          return _willPopCallback();
        },
        selectedTabScreenContext: (context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(colorBehindNavBar: Colors.indigo),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style9,
      ),
    );
  }
}

// ============== [ WebView SandBox Page ] ===============
class WebSandboxPage extends StatefulWidget {
  @override
  _WebSandboxPageState createState() => _WebSandboxPageState();
}

class _WebSandboxPageState extends State<WebSandboxPage> {
  WebViewController? _webViewController;
  String filePath = 'assets/html/sandbox.html';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('沙盒'),
          centerTitle: true,
        ),
        body: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            _loadHtmlFromAssets();
          },
        ));
  }
  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController?.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
