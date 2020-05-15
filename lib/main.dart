import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/models/SoundPlayerModel.dart';
import 'package:nota_nota/models/SoundRecorderModel.dart';
import 'package:nota_nota/models/SoundRecordingsModel.dart';

import 'package:nota_nota/screens/MainScreen.dart';
import 'package:nota_nota/screens/ItemScreen.dart';
import 'package:nota_nota/screens/NewRecordingScreen.dart';

void main() {
  runApp(Dictophone());
}

class Dictophone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        SoundRecordingsModel.provider,
        SoundPlayerModel.provider,
        SoundRecorderModel.provider
      ],
      child: MaterialApp(
        title: 'Flutter Dictophone',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
          MainScreen.routeName: (context) => MainScreen(),
          NewRecordingScreen.routeName: (context) => NewRecordingScreen(),
          ItemScreen.routeName: (context) => ItemScreen(),
        },
      )
    );
  }
}

