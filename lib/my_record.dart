import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:pipopapo/my_audio.dart';

// void main() => runApp(const MyRecord());

class MyRecord extends StatefulWidget {

  final String pushedButton;

  // コンストラクタ
  const MyRecord({Key? key, required this.pushedButton}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyRecordState();
}

class _MyRecordState extends State<MyRecord> {
  final Logger logger = Logger("MyLOG");

  late final MyAudio _myAudio;

  late String _pushedButton;

  /// 最初に一度呼ばれる.Widgetツリーの初期化を実行.
  @override
  initState() {
    super.initState();

    // ログレベルの設定
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('[${record.loggerName}] ${record.level.name}: ${record.message}');
    });
    _pushedButton = widget.pushedButton;
    logger.info("initState");

    _myAudio = MyAudio("vo$_pushedButton");
    //_myAudio.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:  Text('録音($_pushedButton)')),
        body: Column(children: <Widget>[
          AudioWaveforms(
            size: Size(MediaQuery.of(context).size.width, 200.0),
            recorderController: _myAudio.recorderController,
          ),
          SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                  onPressed: () async {
                    logger.info("録音開始ボタンが押下されました。");

                    // // 録音を開始する
                    _myAudio.record();
                  },
                  child: const Text("録音開始"))),
          SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                  onPressed: () async {
                    logger.info("録音停止ボタンが押下されました。");

                    // // 録音を停止する
                    _myAudio.stop;
                  },
                  child: const Text("録音停止"))),
          SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                  onPressed: () async {
                    logger.info("再生ボタンが押下されました。");
                    Fluttertoast.showToast(msg: '再生中');

                    _myAudio.playOrPausePlayer;
                  },
                  child: const Text("再生"))),
          SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                  onPressed: () async {
                    logger.info("pop");
                    Navigator.pop(context);
                  },
                  child: const Text("もどる")))
        ]));
  }
}
