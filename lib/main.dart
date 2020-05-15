import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nota_nota/models/SoundPlayerModel.dart';
import 'package:nota_nota/models/SoundRecorderModel.dart';
import 'package:nota_nota/models/SoundRecordingsModel.dart';

import 'package:nota_nota/screens/MainScreen.dart';
import 'package:nota_nota/screens/ItemScreen.dart';
import 'package:nota_nota/screens/NewRecordingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        SoundPlayerModel.provider,
        SoundRecordingsModel.provider,
        SoundRecorderModel.provider
      ],
      child: MaterialApp(
        title: 'NotaNota',
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

