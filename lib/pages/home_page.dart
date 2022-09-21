import 'dart:developer';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:webview/provider/apiprovider.dart';
import 'package:webview/responsible_file/responsible_file.dart';
import 'package:webview/theme_this_time_not_usable/fonts.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/constants.dart';
import 'package:webview/utils/sharedpre.dart';
import 'package:webview/pages/login_page.dart';
import 'package:webview/pages/notification.dart';
import 'package:webview/pages/notification_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../utils/adhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentClikedBottomMenu = 0;
  String? getMenuA = Constants.webViewUrl;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  String androidId = "";
  SharedPre sharePref = SharedPre();

  var bannerad = "";
  var banneradIos = "";

  String? pic, username, email, type;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  bool activeConnection = false;
  String T = "";

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: colorPrimary,
      ),
      onRefresh: () async {
        debugPrint('refresh');
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    checkUserConnection();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
    getAdmobId();
    getUserinfo();
    super.initState();
  }

  getAdmobId() async {
    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";

    AdHelper.createInterstitialAd();

    AdHelper.createRewardedAd();
  }

  getUserinfo() async {
    pic = await sharePref.read("pic") ?? "";
    username = await sharePref.read("username") ?? "";
    email = await sharePref.read("email") ?? "";
    type = await sharePref.read("type") ?? "";
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  bool bannerAdView = true;

  Widget drawer() {
    return SingleChildScrollView(
        child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (provider.getSettingModel.result?[0].isLogin == "On")
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, bottom: 10, top: 60),
                      height: 80,
                      width: 80,
                      child: pic == null ||
                              pic!.isEmpty ||
                              provider.getSettingModel.result?[0].isLogin ==
                                  "OFF"
                          ? const CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/ic_avatar.png'),
                            )
                          : CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(pic.toString()),
                            ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 3),
                        child: Text(
                          username == null ||
                                  provider.getSettingModel.result?[0].isLogin ==
                                      "OFF"
                              ? ""
                              : username.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.w600),
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 5),
                        child: Text(
                          email.toString() == null ||
                                  provider.getSettingModel.result?[0].isLogin ==
                                      "OFF" ||
                                  type.toString() == "1"
                              ? ""
                              : email.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: textColorThird,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
              const SizedBox(height: 40),
              ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                shrinkWrap: true,
                itemCount: provider.menuModel.result?.length ?? 0,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (provider.floatingValueCurrent == true) {
                            provider.floatingOnOff(oldFloatingValue: false);
                          }
                          provider.changeBottomMenu(oldIndex: index);
                          checkUserConnection().then((value) async {
                            return {
                              provider.changeUrl(
                                  oldUrl:
                                      provider.menuModel.result?[index].url),
                              activeConnection
                                  ? await webViewController!.loadUrl(
                                      urlRequest: URLRequest(
                                          url: Uri.parse(
                                              provider.currentUrl.toString())),
                                    )
                                  : null,
                              setState(() {}),
                              _advancedDrawerController.hideDrawer()
                            };
                          });
                        },
                        child: SizedBox(
                          child: Center(
                            child: ListTile(
                              leading: Image.network(
                                provider.menuModel.result?[index].image
                                        .toString() ??
                                    "",
                                height: SizeConfig.blockVertical * 3,
                              ),
                              title: Text(
                                provider.menuModel.result?[index].title
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                  color: black,
                                  fontSize: SizeConfig.blockVertical * 2 - 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    ));
  }

  final _advancedDrawerController = AdvancedDrawerController();

  _onWillPop(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Do you want to exit'),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }

  String? selectedUrl;

  Widget _getFloatingActionButton() {
    return Builder(builder: (context) {
      return Consumer<ApiProvider>(
          builder: (context, objectMenuProvider, widget) {
        return SpeedDialMenuButton(
          mainFABPosX: 20,
          mainFABPosY: 120,
          isShowSpeedDial: objectMenuProvider.floatingValueCurrent,
          updateSpeedDialStatus: (isShow) {
            objectMenuProvider.floatingValueCurrent = isShow;
          },
          //general init
          isMainFABMini: false,
          isEnableAnimation: false,
          mainMenuFloatingActionButton: MainMenuFloatingActionButton(
              mini: false,
              child: const Icon(Icons.menu),
              onPressed: () {},
              backgroundColor: colorPrimary,
              closeMenuChild: const Icon(Icons.close),
              closeMenuForegroundColor: white,
              closeMenuBackgroundColor: colorPrimaryDark),
          floatingActionButtonWidgetChildren: <FloatingActionButton>[
            for (int i = 0;
                i < objectMenuProvider.floatModel.result!.length;
                i++) ...[
              FloatingActionButton(
                heroTag: "btn$i",
                mini: true,
                backgroundColor: colorPrimary,
                child: SizedBox(
                  height: 20,
                  child: Image.network(
                    objectMenuProvider.floatModel.result![i].image.toString(),
                    color: colorAccent,
                  ),
                ),
                onPressed: () async {
                  checkUserConnection().then((value) async {
                    return {
                      activeConnection
                          ? await webViewController!.loadUrl(
                              urlRequest: URLRequest(
                                  url: Uri.parse(objectMenuProvider
                                      .floatModel.result![i].link
                                      .toString())),
                            )
                          : null,
                    };
                  });
                  objectMenuProvider.floatingOnOff(oldFloatingValue: false);
                },
              ),
            ]
          ],
          isSpeedDialFABsMini: true,
          paddingBtwSpeedDialButton: 10.0,
        );
      });
    });
  }

  final cookieManager = WebviewCookieManager();

  @override
  Widget build(BuildContext context) {
    log("Build method called");

    var webViewProvider = Provider.of<ApiProvider>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    void _handleMenuButtonPressed() {
      _advancedDrawerController.showDrawer();
    }

    return Consumer<ApiProvider>(
      builder: (context, provider, child) {
        return AdvancedDrawer(
          disabledGestures: true,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer:
              provider.getSettingModel.result?[0].fullScreen == "Full screen" ||
                      provider.getSettingModel.result?[0].sideDrawer == ""
                  ? const Text("")
                  : drawer(),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening:
              EasyLocalization.of(context)!.currentLocale.toString() == "ar"
                  ? true
                  : false,
          child: WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton:
                  provider.getSettingModel.result?[0].floatingMenuScreen == "1"
                      ? _getFloatingActionButton()
                      : null,
              backgroundColor: white,
              appBar: provider.getSettingModel.result?[0].fullScreen ==
                      "Full screen"
                  ? null
                  : AppBar(
                      backgroundColor: colorPrimary,
                      leading: provider.getSettingModel.result?[0].fullScreen ==
                                  "Full screen" ||
                              provider.getSettingModel.result?[0].sideDrawer ==
                                  ""
                          ? null
                          : SizedBox(
                              child: IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  debugPrint("Local language" +
                                      EasyLocalization.of(context)!
                                          .currentLocale
                                          .toString());
                                  _handleMenuButtonPressed();
                                },
                                // open side menu
                              ),
                              height: double.infinity,
                            ),
                      actions: [
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            AdHelper.showRewardedAd();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationPage()));
                          },
                          child: Badge(
                            showBadge: false,
                            badgeColor: white,
                            padding: const EdgeInsets.all(2),
                            position: BadgePosition.topStart(top: 16, start: 9),
                            badgeContent: const Text(
                              '3',
                              style: TextStyle(color: red, fontSize: 10),
                            ),
                            child: Image.asset(
                                "assets/images/home_page_images/notification.png",
                                height: 22),
                          ),
                        ),
                        const SizedBox(width: 20),
                        if (provider.getSettingModel.result?[0].isLogin == 'On')
                          InkWell(
                            onTap: () {
                              AwesomeDialog(
                                  customHeader: Container(
                                    margin: const EdgeInsets.all(15),
                                    child: Image.network(
                                      provider.getSettingModel.result?[0]
                                              .appLogo
                                              .toString() ??
                                          "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  btnOkText: "Yes",
                                  btnCancelColor: red,
                                  btnOkColor: green,
                                  btnCancelText: "No",
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  headerAnimationLoop: false,
                                  animType: AnimType.TOPSLIDE,
                                  showCloseIcon: true,
                                  closeIcon: const Icon(
                                      Icons.close_fullscreen_outlined),
                                  title: 'Logout',
                                  desc: 'are you sure logout',
                                  btnCancelOnPress: () {},
                                  onDissmissCallback: (type) {
                                    debugPrint(
                                        'Dialog Dissmiss from callback $type');
                                  },
                                  btnOkOnPress: () async {
                                    await sharePref.clear();

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  }).show();
                            },
                            child: SizedBox(
                              child: Image.asset(
                                "assets/images/home_page_images/logout.png",
                                width: 25,
                              ),
                            ),
                          ),
                        const SizedBox(width: 20),
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.settings),
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Text("Select Preferred Language".tr()),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(
                              value: 0,
                              child: const Text("English"),
                              onTap: () {
                                EasyLocalization.of(context)!
                                    .setLocale(const Locale('en'));
                              },
                            ),
                            PopupMenuItem<int>(
                              value: 0,
                              child: const Text("हिन्दी"),
                              onTap: () {
                                EasyLocalization.of(context)!
                                    .setLocale(const Locale('hi'));
                              },
                            ),
                            PopupMenuItem<int>(
                              value: 0,
                              child: const Text("français"),
                              onTap: () {
                                EasyLocalization.of(context)!
                                    .setLocale(const Locale('fr', 'FR'));
                              },
                            ),
                            PopupMenuItem<int>(
                              value: 0,
                              child: const Text("عربي"),
                              onTap: () {
                                EasyLocalization.of(context)!
                                    .setLocale(const Locale('ar'));
                              },
                            ),
                            const PopupMenuDivider(),
                            if (provider.getSettingModel.result?[0].isLogin ==
                                "On")
                              PopupMenuItem<int>(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(
                                          seconds: 1,
                                        ), () {
                                      AwesomeDialog(
                                          customHeader: Container(
                                            margin: const EdgeInsets.all(15),
                                            child: Image.network(
                                              provider.getSettingModel
                                                      .result?[0].appLogo
                                                      .toString() ??
                                                  "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          btnOkText: "Yes".tr(),
                                          btnCancelColor: red,
                                          btnOkColor: green,
                                          btnCancelText: "No".tr(),
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          headerAnimationLoop: false,
                                          animType: AnimType.TOPSLIDE,
                                          showCloseIcon: true,
                                          closeIcon: const Icon(
                                              Icons.close_fullscreen_outlined),
                                          title: 'Logout'.tr(),
                                          desc: 'are you sure logout'.tr(),
                                          btnCancelOnPress: () {},
                                          onDissmissCallback: (type) {
                                            debugPrint(
                                                'Dialog Dissmiss from callback $type');
                                          },
                                          btnOkOnPress: () async {
                                            await sharePref.clear();

                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                          }).show();
                                    });
                                  },
                                  value: 2,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        color: red,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text("Logout".tr())
                                    ],
                                  ))
                          ],
                        ),
                      ],
                      title: Text(
                        provider.getSettingModel.result?[0].appName ?? "",
                        style: const TextStyle(
                            color: white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
              extendBody: true,
              bottomNavigationBar:
                  provider.getSettingModel.result?[0].bottomNavigation ==
                          "Bottom Navigation"
                      ? bottomBar()
                      : null,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(
                                url: Uri.parse((provider
                                        .getSettingModel.result?[0].baseUrl ??
                                    ""))),
                            initialOptions: options,
                            pullToRefreshController: provider.getSettingModel
                                        .result?[0].pullToRefresh
                                        .toString() ==
                                    "1"
                                ? pullToRefreshController
                                : null,
                            onWebViewCreated: (controller) {
                              debugPrint("im in on Web View Created");
                              webViewController = controller;
                            },
                            androidOnGeolocationPermissionsShowPrompt:
                                (InAppWebViewController controller,
                                    String origin) async {
                              return GeolocationPermissionShowPromptResponse(
                                  origin: origin, allow: true, retain: true);
                            },
                            onLoadStart: (controller, url) {
                              checkUserConnection().then((value) {
                                return null;
                              });
                              // setState(() {});
                            },
                            androidOnPermissionRequest:
                                (controller, origin, resources) async {
                              return PermissionRequestResponse(
                                  resources: resources,
                                  action:
                                      PermissionRequestResponseAction.GRANT);
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              var uri = navigationAction.request.url!;

                              if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri.scheme)) {}

                              return NavigationActionPolicy.ALLOW;
                            },
                            onLoadStop: (controller, url) async {
                              log("onLoadStop ${controller.getContentHeight()}");
                              pullToRefreshController.endRefreshing();
                            },
                            onLoadError: (controller, url, code, message) {
                              pullToRefreshController.endRefreshing();
                            },
                            onUpdateVisitedHistory:
                                (controller, url, androidIsReload) {},
                            onConsoleMessage: (controller, consoleMessage) {
                              log("onConsoleMessage ${controller.getContentHeight()}");
                            },
                          ),
                          activeConnection == false
                              ? Container(
                                  height: double.infinity,
                                  color: white,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.blockVertical * 13,
                                        child: Image.asset(
                                            "assets/images/home_page_images/no-signal.png"),
                                      ),
                                      Text(
                                        "Ooops!".tr(),
                                        style: Fonts.ooops,
                                      ),
                                      Text(
                                        "No Internet Connection Found".tr(),
                                        style: Fonts.networkMessage,
                                      ),
                                      Text(
                                        "Check Your Connection".tr(),
                                        style: Fonts.networkMessage,
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (bannerad == "1" || banneradIos == "1")
          SizedBox(
            height: 60,
            child: AdWidget(
                ad: AdHelper.createBannerAd()..load(), key: UniqueKey()),
          ),
        Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child:
                  Consumer<ApiProvider>(builder: (context, bottomMenu, widget) {
                return SalomonBottomBar(
                  currentIndex: bottomMenu.currentIndex, //_selectedIndex,
                  selectedItemColor: colorAccent,
                  unselectedItemColor: colorAccent,
                  onTap: (i) async {
                    AdHelper.showInterstitialAd();

                    if (bottomMenu.floatingValueCurrent == true) {
                      bottomMenu.floatingOnOff(oldFloatingValue: false);
                    }
                    bottomMenu.changeBottomMenu(oldIndex: i);
                    checkUserConnection().then((value) async {
                      return {
                        bottomMenu.changeUrl(
                            oldUrl: bottomMenu.menuModel.result![i].url),
                        activeConnection
                            ? await webViewController!.loadUrl(
                                urlRequest: URLRequest(
                                    url: Uri.parse(
                                        bottomMenu.currentUrl.toString())),
                              )
                            : null,
                        // setState(() {}),
                      };
                    });
                  },
                  items: [
                    for (int i = 0;
                        i < bottomMenu.menuModel.result!.length;
                        i++)
                      SalomonBottomBarItem(
                          icon: Image.network(
                            bottomMenu.menuModel.result![i].image.toString(),
                            height: 22,
                            color: colorAccent,
                          ),
                          title: Text(
                              bottomMenu.menuModel.result?[i].title
                                      .toString() ??
                                  "",
                              style: TextStyle(color: colorAccent)))
                  ],
                );
              }),
            )),
      ],
    );
  }
}
