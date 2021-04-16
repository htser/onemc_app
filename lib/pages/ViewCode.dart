import 'package:flutter/material.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart';

class MyHomePageA extends StatefulWidget {
  MyHomePageA({Key? key,required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomeAPageState createState() => _MyHomeAPageState();
}

class _MyHomeAPageState extends State<MyHomePageA> {
  String _exampleCode =
      "class MyHomePage extends StatefulWidget { MyHomePage({Key key, this.title}) : super(key: key); final String title; @override _MyHomePageState createState() => _MyHomePageState();}";

  @override
  Widget build(BuildContext context) {
    final SyntaxHighlighterStyle style =
    Theme.of(context).brightness == Brightness.dark
        ? SyntaxHighlighterStyle.darkThemeStyle()
        : SyntaxHighlighterStyle.lightThemeStyle();
    return Scaffold(
        appBar: AppBar(
          title: Text('代码浏览'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: 'monospace', fontSize: 10.0),
                children: <TextSpan>[
                  DartSyntaxHighlighter(style).format(_exampleCode),
                ],
              ),
            ),
          ),
        ));
  }
}