import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview/utils/sharedpre.dart';

class AdHelper {
  static int interstialcnt = 0;
  static int rewardcnt = 0;

  int maxFailedLoadAttempts = 3;
  static SharedPre sharePref = SharedPre();

  static String? banneradid;
  static String? banneradid_ios;
  static String? interstitaladid;
  static String? interstitaladid_ios;
  static String? rewardadid;
  static String? rewardadid_ios;

  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int? maxInterstitialAdclick;

  static int _numRewardAttempts = 0;
  static int maxRewardAdclick = 0;

  static var bannerad = "";
  static var banneradIos = "";

  static RewardedAd? _rewardedAd;

  static AdRequest request = const AdRequest(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
  );

  static initialize() {
    MobileAds.instance.initialize();
  }

  static getAds() async {
    banneradid = await sharePref.read("banner_adid") ?? "";
    banneradid_ios = await sharePref.read("ios_banner_adid") ?? "";

    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";

    interstitaladid = await sharePref.read("interstital_adid") ?? "";
    interstitaladid_ios = await sharePref.read("ios_interstital_adid") ?? "";

    rewardadid = await sharePref.read("reward_adid") ?? "";
    rewardadid_ios = await sharePref.read("ios_reward_adid") ?? "";

    maxInterstitialAdclick =
        int.parse(await sharePref.read("interstital_adclick") ?? "0");
    maxRewardAdclick = int.parse(await sharePref.read("reward_adclick") ?? "0");

    log("maxInterstitialAdclick $maxInterstitialAdclick");

    log("Banner ads $banneradid");
  }

  static BannerAd createBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => debugPrint('Ad Loaded'),
            onAdClosed: (Ad ad) => debugPrint('Ad Closed'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => debugPrint('Ad Open')));
    return ad;
  }

  static void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('====> ads $ad');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            ad.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error');
          },
        ));
  }

  static showInterstitialAd() {
    log('===>$_numInterstitialLoadAttempts');
    log('===>$maxInterstitialAdclick');
    if (_numInterstitialLoadAttempts == maxInterstitialAdclick) {
      _numInterstitialLoadAttempts = 0;
      if (_interstitialAd == null) {
        debugPrint('Warning: attempt to show interstitial before loaded.');

        return false;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();

          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      return;
    }
    _numInterstitialLoadAttempts += 1;
  }

  static createRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('$ad loaded.');
            _rewardedAd = ad;
            _numRewardAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardAttempts += 1;
            if (_numRewardAttempts <= maxRewardAdclick) {
              createRewardedAd();
            }
          },
        ));
  }

  static showRewardedAd() {
    log('===>$_numRewardAttempts');
    log('===>$maxRewardAdclick');
    if (_numRewardAttempts == maxRewardAdclick) {
      if (_rewardedAd == null) {
        debugPrint('Warning: attempt to show rewarded before loaded.');
        return;
      }
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          createRewardedAd();
        },
      );

      _rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint(
            '$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      });
      _rewardedAd = null;
    }
    _numRewardAttempts += 1;
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return banneradid.toString();
    } else if (Platform.isIOS) {
      return banneradid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitaladid.toString();
    } else if (Platform.isIOS) {
      return interstitaladid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardadid.toString();
    } else if (Platform.isIOS) {
      return rewardadid_ios.toString();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
