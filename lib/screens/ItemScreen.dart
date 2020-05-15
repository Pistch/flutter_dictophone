import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/models/SoundRecordingsModel.dart';
import 'package:nota_nota/models/SoundPlayerModel.dart';
import 'package:nota_nota/components/DefaultAppLayout.dart';

class ItemScreenArguments {
  final String id;

  ItemScreenArguments({ @required this.id });
}

class ItemScreen extends StatelessWidget {
  static const routeName = '/item';

  @override
  Widget build(BuildContext context) {
    final ItemScreenArguments args = ModalRoute.of(context).settings.arguments;
    final recordings = Provider.of<SoundRecordingsModel>(context);
    final player = Provider.of<SoundPlayerModel>(context);
    final buttonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
    final bool isCurrentlyPlaying = args.id == player.currentTrack;

    return DefaultAppLayout(
      header: AppBar(title: Text(args.id)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            args.id,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isCurrentlyPlaying && !player.isPaused
                    ? Icons.pause
                    : Icons.play_arrow,
                  size: 36
                ),
                onPressed: () {
                  player.play(args.id);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () {
                  if (player.currentTrack == args.id) {
                    player.stop();
                  }

                  recordings.delete(args.id);
                  Navigator.pop(context);
                },
                color: Colors.red,
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      child: Text(
                        'Delete',
                        style: buttonTextStyle
                      )
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () => {},
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      child: Text(
                        'Save',
                        style: buttonTextStyle
                      )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
