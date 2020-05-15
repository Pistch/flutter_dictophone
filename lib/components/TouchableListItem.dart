import 'package:flutter/material.dart';

class TouchableListItem extends StatefulWidget {
  final Widget child;
  final Function() onPressed;

  TouchableListItem({this.child, this.onPressed});

  @override
  TouchableListItemState createState () => TouchableListItemState(child: child, onPressed: onPressed);
}

class TouchableListItemState extends State {
  final Widget child;
  final Function() onPressed;

  bool _isTapped = false;

  TouchableListItemState({this.child, this.onPressed});

  void _handleTapDown(TapDownDetails tapDownDetails) {
    setState(() => _isTapped = true);
  }

  void _handleTapUp([TapUpDetails tapUpDetails]) {
    setState(() => _isTapped = false);
  }

  Color _getColor() {
    return _isTapped ? Color.fromARGB(30, 0, 0, 0) : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      onTapDown: _handleTapDown,
      onTapCancel: _handleTapUp,
      onTapUp: _handleTapUp,
      child: AnimatedContainer(
        child: child,
        duration: Duration(milliseconds: 100),
        color: _getColor()
      ),
    );
  }
}
