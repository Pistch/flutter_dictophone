import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:nota_nota/utils.dart';
import './base.dart';

class SoundRecordingsModel extends BaseModel {
  static final provider = ChangeNotifierProvider<SoundRecordingsModel>(
    create: (_) {
      var model = SoundRecordingsModel();

      model.init();
      
      return model;
    }
  );

  Directory _directory;

  bool _isReady = false;
  get isReady => _isReady;
  set isReady(_) {}

  List<FileSystemEntity> _list = [];
  get list {
    List<String> namesList = [];
      
    for (var item in _list) {
      if (item is File) {
        namesList.add(getFileSelfName(item.path));
      }
    }

    return namesList;
  }
  set list(value) {}

  Map<String, FileSystemEntity> _map = {};
  get map => _map;
  set map(_) {}

  String _libDirPath = '';

  void init() async {
    var libDir = await getApplicationDocumentsDirectory();
    _libDirPath = libDir.path;

    _directory = Directory(_libDirPath);
    _refreshList();

    setState(() {
      _isReady = true;
    });
  }

  void _refreshList() {
    setState(() {
      _list = _directory.listSync();
      Map<String, FileSystemEntity> newMap = {};

      for (var file in _list) {
        if (file is! File) {
          continue;
        }

        if (file.path.endsWith('.aac')) {
          newMap[getFileSelfName(file.path)] = file;
        }
      }
      
      _map = newMap;
    });
  }

  Future<String> add(File tempFile) async {
    final String newFileId = randomString(10);
    final String newFileName = '$_libDirPath/$newFileId.aac';

    return tempFile
      .copy(newFileName)
      .then((_) {
        tempFile.delete();
        _refreshList();

        return newFileId;
      });
  }

  File getRecording(String id) {
    return map[id];
  }

  Future delete(String id) async {
    final File file = getRecording(id);

    if (file is! File) {
      return;
    }

    await file.delete();
    _refreshList();
  }
}