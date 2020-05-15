import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/ui/Spinner.dart';
import 'package:nota_nota/models/SoundRecorderModel.dart';
import 'package:nota_nota/components/RecorderControls.dart';
import 'package:nota_nota/components/DefaultAppLayout.dart';
import './ItemScreen.dart';

class NewRecordingScreen extends StatelessWidget {
  static const routeName = '/new';

  @override
  Widget build(BuildContext context) {
    final recorderModel = Provider.of<SoundRecorderModel>(context);
    final isReady = recorderModel.isReady;

    if (!isReady) {
      recorderModel.init();
    }

    return DefaultAppLayout(
      header: AppBar(title: Text('New recording')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isReady ? Center(
              child: RecorderControls(
                onRecordingDone: (String filename) {
                  Navigator.pushNamed(
                    context,
                    ItemScreen.routeName,
                    arguments: ItemScreenArguments(id: filename)
                  );
                }
              )
            ) : Spinner()
          ]
        )
      )
    );
  }
}
