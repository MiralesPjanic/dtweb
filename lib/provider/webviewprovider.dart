import 'package:flutter/cupertino.dart';

class WebViewProvider with ChangeNotifier {
  String? currentUrl;

  changeUrl({String? oldUrl}) {
    currentUrl = oldUrl!;
    notifyListeners();
  }
}
