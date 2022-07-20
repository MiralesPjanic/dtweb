import 'package:flutter/cupertino.dart';
import 'package:webview/static_data/static_data.dart';

class DrawerProvider with ChangeNotifier {
  String webUrl = StaticData.webViewUrl;

  changeWebUrl(String newWebUrl) {
    debugPrint(newWebUrl);
    webUrl = newWebUrl;
    StaticData.changeUrl = newWebUrl;

    notifyListeners();
  }
}
