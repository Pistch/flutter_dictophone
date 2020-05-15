import 'package:flutter/material.dart';

class TappableContainer extends Container {
  final VoidCallback onPressed;

  TappableContainer({ this.onPressed, child }) : super(child: child);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: super.build(context)
    );
  }
}