import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview/pages/home_page.dart';
import 'package:webview/pages/intro_page_design.dart';
import 'package:webview/provider/apiprovider.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/constants.dart';
import 'package:webview/utils/sharedpre.dart';
import 'package:webview/utils/string_to_color_converter.dart';
import '../responsible_file/responsible_file.dart';
import '../utils/adhelper.dart';
import '../widgets/no_data.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPre sharePref = SharedPre();
  var apiprovide;
  String? isfirst, isLogin;

  @override
  void initState() {
    super.initState();

    getisFirst();
    debugPrint("Splash intit method");
    apiprovide = Provider.of<ApiProvider>(context, listen: false);
    callGeneralSettingsApi();
  }

  getisFirst() async {
    await AdHelper.getAds();
    isfirst = await sharePref.read("isfirst");
    isLogin = await sharePref.read("login");
    debugPrint('===> $isfirst');
    debugPrint('===> isLogin $isLogin');
  }

  void callGeneralSettingsApi() async {
    log("Called First");

    try {
      await apiprovide.getGeneralsetting();
      if (apiprovide.loading) {
        for (int i = 0;
            i < (apiprovide.generalSettingModel.result?.length ?? 0);
            i++) {
          log('===>key ${apiprovide.generalSettingModel.result![i].settingsKey}');
          await sharePref.save(
              apiprovide.generalSettingModel.result![i].settingsKey.toString(),
              apiprovide.generalSettingModel.result![i].settingsValue
                  .toString());
        }
      }
    } on Exception catch (_) {
      log('never reached' + _.toString());
    }

    await apiprovide.getMenuList();
    if (!apiprovide.loading) {
      log("===> Menulist ${apiprovide.menuModel}");
    }

    await apiprovide.getFloatList();
    if (!apiprovide.loading) {
      log("===> FloatMenu${apiprovide.floatModel}");
    }

    await apiprovide.getSplashScreenList();
    if (!apiprovide.loading) {
      log("===> Splashscreen${apiprovide.splashScreenModel}");
    }

    callGetSettingApi();
  }

  void callGetSettingApi() async {
    log("Called second");

    await apiprovide.getSetting();

    if (apiprovide.loading) {
      for (int i = 0;
          i < (apiprovide.getSettingModel.result?.length ?? 0);
          i++) {
        colorPrimary =
            colorConvert(apiprovide.getSettingModel.result?[i].primary ?? "");
        colorPrimaryDark = colorConvert(
            apiprovide.getSettingModel.result?[i].primaryDark ?? "");
        colorAccent =
            colorConvert(apiprovide.getSettingModel.result?[i].accent ?? "");
        Constants.webViewUrl =
            apiprovide.getSettingModel.result?[i].baseUrl ?? "";
      }

      log('===> intro ${apiprovide.getSettingModel.result?[0].introductionScreen}');
      if (apiprovide.getSettingModel.result?[0].introductionScreen == "1") {
        if (isfirst == "1") {
          nextScreen();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => IntroPageDesign()),
          );
        }
      } else {
        nextScreen();
      }
    }
  }

  nextScreen() {
    if (apiprovide.getSettingModel.result?[0].isLogin == "On") {
      if (isLogin == null) {
        log('login null');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (isLogin == "off") {
        log('login Off');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        log('login else');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Consumer<ApiProvider>(builder: (context, snapshot, child) {
          if (snapshot.loading) {
            if (snapshot.splashScreenModel.status == 200) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Stack(
                  children: [
                    snapshot.splashScreenModel.result![0].splashImageOrColor ==
                            1
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              "${snapshot.splashScreenModel.result![0].splashBackground}",
                              fit: BoxFit.fill,
                            ))
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            color: colorConvert(
                                "${snapshot.splashScreenModel.result![0].splashBackground}"),
                          ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.network(
                              snapshot.splashScreenModel.result![0].splashLogo
                                  .toString(),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                          ),
                          Text(
                            "${snapshot.splashScreenModel.result![0].title}",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 3,
                                color: colorConvert(
                                  snapshot
                                      .splashScreenModel.result![0].titleColor
                                      .toString(),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return NoData(
                  message: snapshot.splashScreenModel.message.toString());
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
