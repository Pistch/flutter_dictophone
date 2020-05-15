import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound_lite/flauto.dart';
import 'package:flutter_sound_lite/ios_quality.dart';
import 'package:flutter_sound_lite/flutter_sound_recorder.dart';

import './base.dart';
import './SoundRecordingsModel.dart';

class SoundRecorderModel extends BaseModel {
  static const _tempFileName = 'temp_recording.aac';
  static final provider = ChangeNotifierProvider<SoundRecorderModel>(
    create: (BuildContext context) => SoundRecorderModel(
      recordingsModel: Provider.of<SoundRecordingsModel>(context, listen: false)
    )
  );

  SoundRecorderModel({recordingsModel}) {
    _recordingsModel = recordingsModel;
  }

  SoundRecordingsModel _recordingsModel;
  final FlutterSoundRecorder _recorderInstance = new FlutterSoundRecorder();

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  String _tempDirPath;

  bool _isRecording = false;
  get isRecording => _isRecording;
  set isRecording(_) {}

  bool _isReady = false;
  get isReady => _isReady;
  set isReady(_) {}

  int _recordingPosition = 0;
  get recordingPosition => _recordingPosition;
  set recordingPosition(_) {}

  double _dbLevel = 0;
  get dbLevel => _dbLevel;
  set dbLevel(_) {}

  File get _tempFile {
    return File('$_tempDirPath/$_tempFileName');
  }

  Future _prepareRecorder() async {
    if (_recorderInstance.isInited == t_INITIALIZED.NOT_INITIALIZED) {
      await _recorderInstance.initialize();
      await _recorderInstance.setDbLevelEnabled(true);
      _recorderInstance.setDbPeakLevelUpdate(0.05);
    }
  }

  Future init() async {
    final List<dynamic> preparationData = await Future.wait([
      getTemporaryDirectory(),
      _prepareRecorder()
    ]);

    setState(() {
      _tempDirPath = preparationData[0].path;
      _isReady = true;
    });
  }

  void _cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }

    if (_dbPeakSubscription != null) {
      _dbPeakSubscription.cancel();
      _dbPeakSubscription = null;
    }
  }

  void startRecording() async {
    if (!_isReady) {
      await init();
    }

    await _recorderInstance.startRecorder(
      uri: _tempFile.path,
      codec: t_CODEC.CODEC_AAC,
      iosQuality: IosQuality.HIGH
    );

    setState(() {
      _isRecording = true;
    });

    _recorderSubscription = _recorderInstance.onRecorderStateChanged.listen((e) {
      if (e != null && e.currentPosition != null) {
        setState(() {
          _recordingPosition = e.currentPosition.toInt();
        });
      }
    });

    _dbPeakSubscription = _recorderInstance.onRecorderDbPeakChanged.listen((value) {
      setState(() {
        _dbLevel = value;
      });
    });
  }

  Future<String> stop() async {
    await _recorderInstance.stopRecorder();

    setState(() {
      _isRecording = false;
      _dbLevel = 0;
      _recordingPosition = 0;
    });
    _cancelRecorderSubscriptions();

    return await _recordingsModel.add(_tempFile);
  }

  @override
  void dispose() {
    _cancelRecorderSubscriptions();
    _recorderInstance.release();
    super.dispose();
  }
}