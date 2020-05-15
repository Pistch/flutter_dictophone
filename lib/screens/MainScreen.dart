import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/models/SoundRecordingsModel.dart';
import 'package:nota_nota/models/SoundPlayerModel.dart';
import 'package:nota_nota/ui/TappableContainer.dart';
import 'package:nota_nota/ui/Spinner.dart';
import 'package:nota_nota/components/DefaultAppLayout.dart';
import './ItemScreen.dart';
import './NewRecordingScreen.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/';

  Widget renderItem({
    String recordingName,
    SoundPlayerModel player,
    Function() onPressed
  }) {
    final isCurrentlyPlaying = recordingName == player.currentTrack;
    final playPauseButton = Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            color: isCurrentlyPlaying ? Colors.lightGreen : Colors.green,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              isCurrentlyPlaying && !player.isPaused
                ? Icons.pause
                : Icons.play_arrow
            ),
            color: Colors.white,
            onPressed: () {
              player.play(recordingName);
            }
          ),
        ),
      ),
    );

    return TappableContainer(
      onPressed: onPressed,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    playPauseButton,
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        recordingName,
                        style: TextStyle(fontSize: 16),
                      )
                    )
                  ]
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20
                )
              ]
            ),
          ),
          Divider(height: 0)
        ],
      ),
    );
  }

  Widget renderEmptyState(BuildContext context) {
    const color = Color.fromARGB(32, 0, 0, 0);
    const textStyle = TextStyle(fontSize: 32, color: color);

    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.close,
          color: color,
          size: 128,
        ),
        Text(
          'No recordings yet',
          style: textStyle
        )
      ],
    ));
  }

  Widget renderBody(BuildContext context) {
    final recordings = Provider.of<SoundRecordingsModel>(context);

    if (!recordings.isReady) {
      return Spinner();
    }

    if (recordings.list.length == 0) {
      return renderEmptyState(context);
    }

    final player = Provider.of<SoundPlayerModel>(context);

    return ListView(
      children: <Widget>[
        for (String recordingName in recordings.list) renderItem(
          player: player,
          recordingName: recordingName,
          onPressed: () {
            Navigator.pushNamed(
              context,
              ItemScreen.routeName,
              arguments: ItemScreenArguments(id: recordingName)
            );
          }
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAppLayout(
      header: AppBar(title: Text('Such a title')),
      body: renderBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        onPressed: () {
          Navigator.pushNamed(context, NewRecordingScreen.routeName);
        }
      ),
    );
  }
}
