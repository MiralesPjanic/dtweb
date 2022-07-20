import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview/static_data/static_data.dart';

// ignore: prefer_typing_uninitialized_variables
var interstitialAd;

void interstitialAdLoad() {
  InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? StaticData.interstitalAdId
          : StaticData.iosInterstitalAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: intersitialAdLoaded,
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ));
}

intersitialAdLoaded(InterstitialAd ad) {
  interstitialAd = ad;

  interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        debugPrint('%ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      debugPrint('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
    },
    onAdImpression: (InterstitialAd ad) =>
        debugPrint('$ad impression occurred.'),
  );
}
