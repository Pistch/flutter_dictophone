import 'package:flutter/material.dart';

class DefaultAppLayout extends StatelessWidget {
  DefaultAppLayout({this.header, this.body, this.floatingActionButton});

  final Widget header;
  final Widget body;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header,
      body: body,
      floatingActionButton: floatingActionButton
    );
  }
}
