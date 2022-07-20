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
import 'package:webview/api_services/api_methods.dart';
import 'package:webview/pages/ads/banner_ad.dart';
import 'package:webview/provider/homepageprovider.dart';
import 'package:webview/provider/webviewprovider.dart';
import 'package:webview/responsible_file/responsible_file.dart';
import 'package:webview/theme_this_time_not_usable/fonts.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/global_function.dart';
import 'package:webview/utils/sharedprefe.dart';
import 'package:webview/pages/login_page.dart';
import 'package:webview/pages/notification.dart';
import 'package:webview/pages/notification_page.dart';
import 'package:webview/static_data/static_data.dart';
import 'package:webview/utils/state_management.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import '../models/get_setting_update_model.dart';

class HomePage extends StatefulWidget {
  final GetSettings? getSettingsdata;

  const HomePage({Key? key, this.getSettingsdata}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentClikedBottomMenu = 0;
  String? getMenuA = StaticData.webViewUrl;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  String androidId = "";

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
    SharedPrefe.readUserProfileData();
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
    StaticData.webViewUrl = widget.getSettingsdata!.result[0].baseUrl;
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    Platform.isAndroid
        ? StaticData.bannerAd == "1"
            ? bannerAd2.load()
            : debugPrint("Banner Ad Android not loaded")
        : StaticData.iosBannerAd == "1"
            ? bannerAd2.load()
            : debugPrint("Banner Ad IOS not loaded");

    checkAds();
    debugPrint("====>" + SharedPrefe.pic.toString());
    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  bool bannerAdView = true;

  Widget drawer(
      {DrawerProvider? changeWebUrl,
      var adContiner,
      required WebViewProvider webViewProvider}) {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        child: SizedBox(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, bottom: 10, top: 60),
                      height: 80,
                      width: 80,
                      child: SharedPrefe.pic == null ||
                              SharedPrefe.pic.toString().isEmpty ||
                              ApiMethods.getSettingsData!.result[0].isLogin ==
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
                              backgroundImage:
                                  NetworkImage(SharedPrefe.pic.toString()),
                            ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 3),
                        child: Text(
                          SharedPrefe.userName == null ||
                                  ApiMethods
                                          .getSettingsData!.result[0].isLogin ==
                                      "OFF"
                              ? "Guest User"
                              : SharedPrefe.userName.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.w600),
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 5),
                        child: Text(
                          SharedPrefe.email == null ||
                                  ApiMethods
                                          .getSettingsData!.result[0].isLogin ==
                                      "OFF" ||
                                  SharedPrefe.type == "1"
                              ? ""
                              : SharedPrefe.email.toString(),
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
                  itemCount: ApiMethods.getMenuListData!.result!.length,
                  itemBuilder: (context, index) {
                    return Consumer<WebViewProvider>(
                        builder: (context, object, widget) {
                      return Consumer<HomePageProvider>(
                          builder: (context, objectBottomMenu, widget) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                // checkAds();
                                // checkUserConnection();
                                // if (activeConnection == true) {
                                //   changeWebUrl!.changeWebUrl(ApiMethods
                                //       .getMenuListData!.result![index].url
                                //       .toString());
                                // }
                                // setState(() {});
                                checkAds();
                                if (objectBottomMenu.floatingValueCurrent ==
                                    true) {
                                  objectBottomMenu.floatingOnOff(
                                      oldFloatingValue: false);
                                }
                                objectBottomMenu.changeBottomMenu(
                                    oldIndex: index);
                                checkUserConnection().then((value) async {
                                  return {
                                    webViewProvider.changeUrl(
                                        oldUrl: ApiMethods.getMenuListData!
                                            .result![index].url),
                                    activeConnection
                                        ? await webViewController!.loadUrl(
                                            urlRequest: URLRequest(
                                                url: Uri.parse(object.currentUrl
                                                    .toString())),
                                          )
                                        : null,
                                    // Future.delayed(const Duration(seconds: 5),
                                    //     () {
                                    //   debugPrint("after 5 sec");
                                    // }),
                                    setState(() {}),
                                    _advancedDrawerController.hideDrawer()
                                  };
                                });
                              },
                              child: SizedBox(
                                child: Center(
                                  child: ListTile(
                                    leading: Image.network(
                                      ApiMethods
                                          .getMenuListData!.result![index].image
                                          .toString(),
                                      height: SizeConfig.blockVertical * 3,
                                    ),
                                    title: Text(
                                      ApiMethods
                                          .getMenuListData!.result![index].title
                                          .toString(),
                                      style: TextStyle(
                                        color: black,
                                        fontSize:
                                            SizeConfig.blockVertical * 2 - 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
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

  Widget _getFloatingActionButton(
      {DrawerProvider? changeWebUrl, WebViewProvider? object}) {
    return Consumer<HomePageProvider>(
        builder: (context, objectMenuProvider, widget) {
      return SpeedDialMenuButton(
        mainFABPosX: 20,
        mainFABPosY: Platform.isAndroid
            ? bannerAdView == true && StaticData.bannerAd == "1"
                ? ApiMethods.getSettingsData!.result[0].bottomNavigation == ""
                    ? 60
                    : 120
                : ApiMethods.getSettingsData!.result[0].bottomNavigation == ""
                    ? 20
                    : 80
            : bannerAdView == true && StaticData.iosBannerAd == "1"
                ? ApiMethods.getSettingsData!.result[0].bottomNavigation == ""
                    ? 60
                    : 100
                : ApiMethods.getSettingsData!.result[0].bottomNavigation == ""
                    ? 20
                    : 60,
        //if needed to close the menu after clicking sub-FAB
        isShowSpeedDial: objectMenuProvider.floatingValueCurrent,
        //manually open or close menu
        updateSpeedDialStatus: (isShow) {
          //return any open or close change within the widget
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
          for (int i = 0; i < ApiMethods.getFloatData!.result!.length; i++) ...[
            FloatingActionButton(
              mini: true,
              backgroundColor: colorPrimary,
              child: SizedBox(
                height: 20,
                child: Image.network(
                  ApiMethods.getFloatData!.result![i].image.toString(),
                  color: colorAccent,
                ),
              ),
              onPressed: () async {
                checkUserConnection().then((value) async {
                  return {
                    activeConnection
                        ? await webViewController!.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse(ApiMethods
                                    .getFloatData!.result![i].link
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
  }

  final cookieManager = WebviewCookieManager();

  @override
  Widget build(BuildContext context) {
    WebViewProvider webViewProvider = Provider.of(context, listen: false);
    final AdWidget adWidget = AdWidget(ad: bannerAd2);
    final Container adContainer = Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: adWidget,
      width: bannerAd2.size.width.toDouble(),
      height: bannerAd2.size.height.toDouble(),
    );
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    void _handleMenuButtonPressed() {
      _advancedDrawerController.showDrawer();
    }

    return ChangeNotifierProvider<DrawerProvider>(
      create: (context) => DrawerProvider(),
      child: Consumer<DrawerProvider>(builder: (context, value1, child) {
        return AdvancedDrawer(
          disabledGestures: true,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          drawer:
              widget.getSettingsdata!.result[0].fullScreen == "Full screen" ||
                      widget.getSettingsdata!.result[0].sideDrawer == ""
                  ? const Text("")
                  : drawer(
                      changeWebUrl: value1,
                      adContiner: adContainer,
                      webViewProvider: webViewProvider),
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
                  ApiMethods.getSettingsData!.result[0].floatingMenuScreen ==
                          "1"
                      ? _getFloatingActionButton(changeWebUrl: value1)
                      : null,
              backgroundColor: white,
              appBar: widget.getSettingsdata!.result[0].fullScreen ==
                      "Full screen"
                  ? null
                  : AppBar(
                      backgroundColor: colorPrimary,
                      leading: widget.getSettingsdata!.result[0].fullScreen ==
                                  "Full screen" ||
                              widget.getSettingsdata!.result[0].sideDrawer == ""
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
                        SharedPrefe.userName ==
                                SharedPrefe.userName //null value
                            ? const Text("")
                            : InkWell(
                                onTap: () {
                                  AwesomeDialog(
                                      customHeader: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: Image.network(
                                          widget.getSettingsdata!.result[0]
                                              .appLogo
                                              .toString(),
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
                                        await SharedPrefe.saveUserProfileData(
                                            email: null,
                                            userName: null,
                                            type: null,
                                            login: null);

                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(
                                                    getSettingsData: widget
                                                        .getSettingsdata)));
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
                            if (ApiMethods.getSettingsData!.result[0].isLogin ==
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
                                              widget.getSettingsdata!.result[0]
                                                  .appLogo
                                                  .toString(),
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
                                            await SharedPrefe
                                                .saveUserProfileData(
                                                    email: null,
                                                    userName: null,
                                                    type: null,
                                                    login: null);

                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) => LoginPage(
                                                        getSettingsData: widget
                                                            .getSettingsdata)));
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
                        widget.getSettingsdata!.result[0].appName,
                        style: const TextStyle(
                            color: white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
              extendBody: true,
              bottomNavigationBar:
                  widget.getSettingsdata!.result[0].bottomNavigation ==
                          "Bottom Navigation"
                      ? bottomBar(
                          changeWebUrl: value1,
                          adContiner: adContainer,
                          webViewProvider: webViewProvider)
                      : null,
              body: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Consumer<WebViewProvider>(
                            builder: (context, object, widget) {
                          return Consumer<HomePageProvider>(
                              builder: (context, objectProgress, widget) {
                            webViewProvider.changeUrl(
                                oldUrl: ApiMethods
                                    .getSettingsData!.result[0].baseUrl);
                            return InAppWebView(
                              key: webViewKey,
                              initialUrlRequest: URLRequest(
                                  url: Uri.parse(object.currentUrl.toString())),
                              initialOptions: options,
                              pullToRefreshController: ApiMethods
                                          .getSettingsData!
                                          .result[0]
                                          .pullToRefresh
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
                                setState(() {});
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
                                pullToRefreshController.endRefreshing();
                              },
                              onLoadError: (controller, url, code, message) {
                                pullToRefreshController.endRefreshing();
                              },
                              onUpdateVisitedHistory:
                                  (controller, url, androidIsReload) {},
                              onConsoleMessage: (controller, consoleMessage) {},
                            );
                          });
                        }),
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
                        if (ApiMethods
                                .getSettingsData!.result[0].bottomNavigation ==
                            "")
                          Positioned(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Platform.isAndroid
                                    ? bannerAdView == true &&
                                            StaticData.bannerAd == "1"
                                        ? adContainer
                                        : null
                                    : bannerAdView == true &&
                                            StaticData.iosBannerAd == "1"
                                        ? adContainer
                                        : null,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  bottomBar(
      {DrawerProvider? changeWebUrl,
      var adContiner,
      required WebViewProvider webViewProvider}) {
    return Builder(builder: (context) {
      return Container(
        height: 140,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              child: Platform.isAndroid
                  ? bannerAdView == true && StaticData.bannerAd == "1"
                      ? adContiner
                      : null
                  : bannerAdView == true && StaticData.iosBannerAd == "1"
                      ? adContiner
                      : null,
              color: Colors.transparent,
            ),
            Container(
              color: colorPrimary,
              child: Builder(builder: (context) {
                debugPrint(StaticData.selectedIndex.toString() +
                    "Selected Index in buildr");
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          debugPrint("1");
                          return Consumer<WebViewProvider>(
                              builder: (context, object, widget) {
                            return Consumer<HomePageProvider>(
                                builder: (context, objectBottomMenu, widget) {
                              return SalomonBottomBar(
                                currentIndex: objectBottomMenu
                                    .currentIndex, //_selectedIndex,
                                selectedItemColor: colorAccent,
                                unselectedItemColor: colorAccent,
                                onTap: (i) async {
                                  checkAds();
                                  if (objectBottomMenu.floatingValueCurrent ==
                                      true) {
                                    objectBottomMenu.floatingOnOff(
                                        oldFloatingValue: false);
                                  }
                                  objectBottomMenu.changeBottomMenu(
                                      oldIndex: i);
                                  checkUserConnection().then((value) async {
                                    return {
                                      webViewProvider.changeUrl(
                                          oldUrl: ApiMethods
                                              .getMenuListData!.result![i].url),
                                      activeConnection
                                          ? await webViewController!.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: Uri.parse(object
                                                      .currentUrl
                                                      .toString())),
                                            )
                                          : null,
                                      // Future.delayed(const Duration(seconds: 5),
                                      //     () {
                                      //   debugPrint("after 5 sec");
                                      // }),
                                      setState(() {}),
                                    };
                                  });
                                },
                                items: [
                                  for (int i = 0;
                                      i <
                                          ApiMethods
                                              .getMenuListData!.result!.length;
                                      i++)
                                    SalomonBottomBarItem(
                                        icon: Image.network(
                                          ApiMethods
                                              .getMenuListData!.result![i].image
                                              .toString(),
                                          height: 22,
                                          color: colorAccent,
                                        ),
                                        title: Text(
                                            ApiMethods.getMenuListData!
                                                .result![i].title
                                                .toString(),
                                            style:
                                                TextStyle(color: colorAccent)))
                                ],
                              );
                            });
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
