
import 'package:audioplayers/audioplayers.dart';
//import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:pipopapo/new_page.dart';

import 'package:pipopapo/my_record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    //print(size.width);

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.yellow),
        home: const Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  // ここのcontextは上位ツリーで提供されたMaterialAppを含んでいる。
  Widget build(BuildContext context) {


    final Logger logger = Logger("MyLOG");

    return Scaffold(
      appBar: AppBar(title: const Text('こうちゃんアプリ')),
      body: Column(
        children: <Widget>[
          const SizedBox(width: double.infinity, height: 100),
          numberButton3piece(context, ["1", "2", "3"]),
          numberButton3piece(context, ["4", "5", "6"]),
          numberButton3piece(context, ["7", "8", "9"]),
          numberButton(context, "0")
        ],
      ),
    );
  }
}

/// 横に3連並んだ数字ボタンの定義
Widget numberButton3piece(BuildContext context, List<String> displayTextList) {
  return Container(
    width: double.infinity,
    color: Colors.grey[200],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        numberButton(context, displayTextList[0]),
        numberButton(context, displayTextList[1]),
        numberButton(context, displayTextList[2]),
      ],
    ),
  );
}

/// 数字ボタンの定義
Widget numberButton(BuildContext context, String displayText) {
  return Padding(
      padding: const EdgeInsets.all(2), //マージン
      child: SizedBox(
          width: 100,
          height: 100,
          child: ElevatedButton(
            onPressed: () {
              print(displayText + "がクリックされたぞ");
              // Fluttertoast.showToast(msg: "完了しました");
              // 再生
              // AudioCache player = AudioCache();
              // player.play('se.mp3');

                GoNextPage().intent(context,displayText);

            },
            child: Text(displayText),
          )));
}

// 画面遷移をする部分のコード
class GoNextPage {
  void intent(BuildContext context, String displayText) {
    print("画面遷移します");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyRecord(pushedButton:displayText)),
    );
  }
}
