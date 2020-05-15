import 'package:flutter/foundation.dart';

class BaseModel extends ChangeNotifier {
  void setState(final VoidCallback cb) {
    cb();

    notifyListeners();
  }
}