import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview/api_services/api_methods.dart';
import 'package:webview/pages/home_page.dart';
import 'package:webview/pages/intro_page_design.dart';
import 'package:webview/static_data/static_data.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/sharedprefe.dart';
import 'package:webview/main.dart';
import 'package:webview/models/get_splash_screen_list_model.dart';
import 'package:webview/utils/string_to_color_converter.dart';
import '../responsible_file/responsible_file.dart';
import '../widgets/no_data.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void callGeneralSettingsApi() async {
    await ApiMethods.generalSettings().then((value) async {
      debugPrint(value!.status.toString());
      for (int i = 0; i < value.result.length; i++) {
        SharedPrefe.addStringPre(value.result[i].settingsKey.toString(),
            value.result[i].settingsValue.toString());
      }

      StaticData.bannerAd = await SharedPrefe.getStringPre("banner_ad");
      StaticData.bannerAdId = await SharedPrefe.getStringPre("banner_adid");

      StaticData.interstitalAdId =
          await SharedPrefe.getStringPre("interstital_adid");
      StaticData.interstitalAd =
          await SharedPrefe.getStringPre("interstital_ad");

      StaticData.iosBannerAd = await SharedPrefe.getStringPre("ios_banner_ad");
      StaticData.iosBannerAdId =
          await SharedPrefe.getStringPre("ios_banner_adid");

      StaticData.iosInterstitalAdId =
          await SharedPrefe.getStringPre("ios_interstital_adid");
      StaticData.iosInterstitalAd =
          await SharedPrefe.getStringPre("ios_interstital_ad");
    });
  }

  void callGetSettingApi() async {
    debugPrint("get Setting call");
    await ApiMethods.getSettings().then((value) async {
      ApiMethods.getSettingsData = value;
      colorPrimary =
          colorConvert(ApiMethods.getSettingsData!.result[0].primary);
      colorPrimaryDark =
          colorConvert(ApiMethods.getSettingsData!.result[0].primaryDark);
      colorAccent = colorConvert(ApiMethods.getSettingsData!.result[0].accent);
      debugPrint("get Setting call");
      debugPrint(value!.status.toString());

      await ApiMethods.getMenuList().then(((value) {
        ApiMethods.getMenuListData = value;
        debugPrint("Successs Menu List" + value!.status.toString());

        callGetSplashScreenApi();
      }));

      await ApiMethods.getFloatList().then(((value) {
        ApiMethods.getFloatData = value;
        debugPrint("Successs FloatMenu List" + value!.status.toString());
      }));
    });
  }

  void callGetSplashScreenApi() async {
    await ApiMethods.getSplashScreenList(context).then((value) {
      ApiMethods.getSplashScreenListData = value;

      if (initScreen == 0 ||
          initScreen == null &&
              ApiMethods.getSettingsData!.result[0].introductionScreen == "1") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => IntroPageDesign(
                    getSettingsApiData: ApiMethods.getSettingsData,
                  )),
        );
      } else {
        if (ApiMethods.getSettingsData!.result[0].isLogin == "On") {
          if (SharedPrefe.login == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                        getSettingsData: ApiMethods.getSettingsData,
                      )),
            );
          } else if (SharedPrefe.login == "Off") {
            ///change`
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        getSettingsdata: ApiMethods.getSettingsData,
                      )),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                        getSettingsData: ApiMethods.getSettingsData,
                      )),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      getSettingsdata: ApiMethods.getSettingsData,
                    )),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Splash intit method");
    SharedPrefe.readUserProfileData();
    callGeneralSettingsApi();

    callGetSettingApi();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: FutureBuilder<GetSplashScreenListModel?>(
            future: ApiMethods.getSplashScreenList(context),
            builder:
                (context, AsyncSnapshot<GetSplashScreenListModel?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.status == 200) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              snapshot.data!.result![0].splashImageOrColor == 1
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        "${snapshot.data!.result![0].splashBackground}",
                                        fit: BoxFit.fill,
                                      ))
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      color: colorConvert(
                                          "${snapshot.data!.result![0].splashBackground}"),
                                    ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier * 20,
                                      width: SizeConfig.heightMultiplier * 20,
                                      child: CircleAvatar(
                                        backgroundColor: white,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 180,
                                          backgroundImage: NetworkImage(
                                            "${snapshot.data!.result![0].splashLogo}",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data!.result![0].title}",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.textMultiplier * 3,
                                          color: colorConvert(
                                            "${snapshot.data!.result![0].titleColor}",
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return NoData(message: snapshot.data!.message.toString());
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
