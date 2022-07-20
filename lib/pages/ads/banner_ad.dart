import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview/static_data/static_data.dart';

Ad? adnew;

BannerAd bannerAd = BannerAd(
  adUnitId: Platform.isAndroid
      ? StaticData.bannerAdId.toString()
      : StaticData.iosBannerAdId.toString(),
  size: AdSize.banner,
  request: const AdRequest(),
  listener: BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      adnew = ad;
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  ),
);

BannerAd bannerAd2 = BannerAd(
  adUnitId: Platform.isAndroid
      ? StaticData.bannerAdId.toString()
      : StaticData.iosBannerAdId.toString(),
  size: AdSize.banner,
  request: const AdRequest(),
  listener: BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      adnew = ad;
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  ),
);

BannerAd bannerAd3 = BannerAd(
  adUnitId: Platform.isAndroid
      ? StaticData.bannerAdId.toString()
      : StaticData.iosBannerAdId.toString(),
  size: AdSize.banner,
  request: const AdRequest(),
  listener: BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      adnew = ad;
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  ),
);
