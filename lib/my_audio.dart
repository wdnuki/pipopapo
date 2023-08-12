import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class MyAudio {
  // RecorderController
  late final RecorderController recorderController;

  // PlayerController
  late final PlayerController playerController;

  // 録音ファイルを保存するパス
  late final String _path;

  // アプリで使用できるフォルダ
  late final Directory appDirectory;
  final Logger logger = Logger("MyLOG");

  late String _voiceFileName;

  MyAudio(String voiceFileName) {
    _init();
    logger.info("コンストラクタ$voiceFileName");
    _voiceFileName = voiceFileName;

    // ログレベルの設定
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('[${record.loggerName}] ${record.level.name}: ${record.message}');
    });
  }

  Future<void> _init() async  {

    logger.info("init");
    // 音声データを一時的に保存するためのディレクトリを指定する
    _getApplicationDirectory();

    //_preparePlayers();
    _initialiseControllers();
  }

  /// 音声データを一時的に保存するためのディレクトリを指定する
  Future<void> _getApplicationDirectory() async {
    // アプリケーション専用のファイルを配置するディレクトリを取得する
    appDirectory = await getApplicationDocumentsDirectory();
    logger.info("出力パス：${appDirectory.path}");

    _path = "${appDirectory.path}/$_voiceFileName";
  }

  /// 各種Controllerの初期設定
  void _initialiseControllers() {
    // RecorderController
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000
      ..bitRate = 64000;

    // PlayerController
    playerController = PlayerController();
  }

  /// 録音を開始する
  void record() async {
    // 録音を開始する
    await recorderController.record(_path);
  }

  void stop() async {
    // 録音を停止する
    await recorderController.stop();

    await playerController.preparePlayer(_path);
  }

  /// 音楽が流れていれば止める、止まっていれば再生する
  void playOrPausePlayer() async {
    // 現在の状態を取得する
    PlayerState state = playerController.playerState;

    // 音楽が流れている場合
    if (state == PlayerState.playing) {
      // 止める
      await playerController.pausePlayer();
      logger.info("音楽を止めました。$state -> ${playerController.playerState}");
    } else {
      // 再生する
      await playerController.startPlayer();
      logger.info("音楽を再生しました。$state -> ${playerController.playerState}");
    }
  }
}
