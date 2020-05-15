import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/utils.dart';
import 'package:nota_nota/models/SoundRecorderModel.dart';
import 'package:nota_nota/models/SoundRecordingsModel.dart';
import 'package:nota_nota/ui/LevelIndicator.dart';

class RecorderControls extends StatelessWidget {
  void Function(String) onRecordingDone;

  RecorderControls({this.onRecordingDone});

  void start(SoundRecorderModel recorderModel) {
    recorderModel.startRecording();
  }

  void stop(SoundRecorderModel recorderModel, SoundRecordingsModel recordingsModel) async {
    final String newRecordingId = await recorderModel.stop();
//    final String newRecordingId = await recordingsModel.add(tempFile);

    onRecordingDone(newRecordingId);
  }

  @override
  Widget build(BuildContext context) {
    final recorderModel = Provider.of<SoundRecorderModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        LevelIndicator(recorderModel.dbLevel, 110),
        Container(
          padding: EdgeInsets.all(24),
          child: Text(
            getFormattedDurationString(recorderModel.recordingPosition),
            style: TextStyle(fontSize: 36)
          )
        ),
        RaisedButton(
          child: Text(recorderModel.isRecording ? 'Stop' : 'Start'),
          onPressed: () {
            final recordingsModel = Provider.of<SoundRecordingsModel>(context, listen: false);

            if (recorderModel.isRecording) {
              stop(recorderModel, recordingsModel);
            } else {
              start(recorderModel);
            }
          }
        )
      ],
    );
  }
}