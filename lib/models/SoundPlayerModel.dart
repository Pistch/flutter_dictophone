import 'package:provider/provider.dart';
import 'package:flutter_sound_lite/flauto.dart';
import 'package:flutter_sound_lite/flutter_sound_player.dart';

import 'package:nota_nota/utils.dart';
import './base.dart';

class SoundPlayerModel extends BaseModel {
  static final provider = ChangeNotifierProvider<SoundPlayerModel>(
    create: (_) {
      final player = SoundPlayerModel();

      player.init();

      return player;
    },
  );

  final FlutterSoundPlayer _playerInstance = new FlutterSoundPlayer();

  bool _isReady = false;
  get isReady => _isReady;
  set isReady(_) {}

  bool _isPlaying = false;
  get isPlaying => _isPlaying;
  set isPlaying(_) {}

  bool _isPaused = false;
  get isPaused => _isPaused;
  set isPaused(_) {}

  String _currentTrack;
  get currentTrack {
    if (_currentTrack == null) {
      return _currentTrack;
    }

    return getFileSelfName(_currentTrack);
  }
  set currentTrack(_) {}

  void init() async {
    if (_playerInstance.isInited == t_INITIALIZED.NOT_INITIALIZED) {
      await _playerInstance.initialize();

      setState(() {
        _isReady = true;
      });
    }
  }

  void play(final String filename) async {
    if (isPlaying || isPaused) {
      if (currentTrack == filename) {
        return isPaused ? resume() : pause();
      } else {
        await stop();
      }
    }

    try {
      await _playerInstance.startPlayer(
        filename,
        codec: t_CODEC.CODEC_AAC,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _isPaused = false;
            _currentTrack = null;
          });
        }
      );

      setState(() {
        _isPlaying = true;
        _isPaused = false;
        _currentTrack = filename;
      });
    } catch (error) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future stop() async {
    await _playerInstance.stopPlayer();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  Future pause() async {
    await _playerInstance.pausePlayer();
    setState(() {
      _isPaused = true;
    });
  }

  Future resume() async {
    await _playerInstance.resumePlayer();
    setState(() {
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    stop();
    _playerInstance.release();
    super.dispose();
  }
}
