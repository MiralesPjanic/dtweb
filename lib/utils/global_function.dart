import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:webview/pages/ads/interstitial_ad.dart';
import 'package:webview/static_data/static_data.dart';

checkAds() {
  if (Platform.isAndroid) {
    if (StaticData.interstitalAd == "1") {
      interstitialAdLoad();
      interstitialAd.show();
    } else {
      debugPrint(StaticData.interstitalAd! + "interstitalAd");
    }
  } else {
    if (StaticData.iosInterstitalAd == "1") {
      interstitialAdLoad();
      interstitialAd.show();
    } else {
      debugPrint(StaticData.iosInterstitalAd! + "interstitalAd");
    }
  }
}
