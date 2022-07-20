import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview/api_services/api_methods.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:webview/models/get_setting_update_model.dart';
import 'package:webview/pages/ads/banner_ad.dart';
import 'package:webview/static_data/static_data.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/sharedprefe.dart';
import 'package:webview/widgets/no_data.dart';
import '../models/get_introduction_screen_list_model.dart';
import '../responsible_file/responsible_file.dart';
import 'home_page.dart';
import 'login_page.dart';

class IntroPageDesign extends StatefulWidget {
  final GetSettings? getSettingsApiData;

  const IntroPageDesign({Key? key, required this.getSettingsApiData})
      : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPageDesign> {
  void getIntroScreenList() async {
    await ApiMethods.getIntroductionScreenList().then((value) {
      ApiMethods.getIntroductionScreenListData = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getIntroScreenList();

    Platform.isAndroid
        ? StaticData.bannerAd == "1"
            ? bannerAd.load()
            : debugPrint("Banner Ad Android not loaded")
        : StaticData.iosBannerAd == "1"
            ? bannerAd.load()
            : debugPrint("Banner Ad IOS not loaded");
  }

  void onDonePress() {
    if (ApiMethods.getSettingsData!.result[0].isLogin == "On") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  getSettingsData: ApiMethods.getSettingsData,
                )),
      );
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

  PageController controller = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(backgroundColor: white, body: demodynamicIntro());
  }

  FutureBuilder<GetIntroductionScreenListModel?> demodynamicIntro() {
    return FutureBuilder<GetIntroductionScreenListModel?>(
        future: ApiMethods.getIntroductionScreenList(),
        builder:
            (context, AsyncSnapshot<GetIntroductionScreenListModel?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.status == 200 &&
                snapshot.data!.result!.isNotEmpty) {
              final AdWidget adWidget = AdWidget(ad: bannerAd);
              final Container adContainer = Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: adWidget,
                width: bannerAd.size.width.toDouble(),
                height: bannerAd.size.height.toDouble(),
              );
              return SafeArea(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 40,
                          margin: const EdgeInsets.all(10),
                          child: currentPage == 0
                              ? Center(
                                  child: Container(),
                                )
                              : Center(
                                  child: InkWell(
                                    onTap: () {
                                      if (controller.hasClients) {
                                        controller.animateToPage(
                                          currentPage - 1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                      setState(() {});
                                    },
                                    child: const FittedBox(
                                      child: Center(
                                        child: Icon(
                                          Icons.arrow_back,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const Spacer(),
                        Container(
                          height: 30,
                          width: 40,
                          margin: const EdgeInsets.all(15),
                          child: Center(
                            child: ApiMethods.getIntroductionScreenListData!
                                            .result!.length -
                                        1 ==
                                    currentPage
                                ? null
                                : InkWell(
                                    onTap: () {
                                      debugPrint("===>" +
                                          SharedPrefe.login.toString());
                                      if (ApiMethods.getSettingsData!.result[0]
                                              .isLogin ==
                                          "On") {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage(
                                                    getSettingsData: ApiMethods
                                                        .getSettingsData,
                                                  )),
                                        );
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    getSettingsdata: ApiMethods
                                                        .getSettingsData,
                                                  )),
                                        );
                                      }
                                      setState(() {});
                                    },
                                    child: FittedBox(
                                      child: Center(
                                          child: Text(
                                        "Skip".tr(),
                                        style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) {
                          if (index != 0) {}

                          currentPage = index;
                          setState(() {});
                        },
                        itemCount: snapshot.data!.result!.length,
                        scrollDirection: Axis.horizontal,
                        controller: controller,
                        itemBuilder: (context, index) {
                          return Container(
                            color: white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockHorizontal + 1,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(10),
                                  child: Image.network(snapshot
                                      .data!.result![index].image
                                      .toString()),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockHorizontal + 1,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Text(
                                    snapshot.data!.result![index].title
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: SizeConfig.blockVertical * 3,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  margin: EdgeInsets.all(
                                      SizeConfig.blockVertical + 2),
                                  child: Text(
                                      snapshot.data!.result![index].description
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockVertical * 1.5,
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: DotsIndicator(
                              dotsCount: ApiMethods
                                  .getIntroductionScreenListData!
                                  .result!
                                  .length,
                              position: currentPage.toDouble(),
                              decorator: DotsDecorator(
                                spacing: const EdgeInsets.all(4),
                                size: const Size.square(9.0),
                                activeColor: colorPrimary,
                                activeSize: const Size(30.0, 9.0),
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: currentPage == snapshot.data!.result!.length - 1
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  if (ApiMethods
                                          .getSettingsData!.result[0].isLogin ==
                                      "On") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                                getSettingsData:
                                                    ApiMethods.getSettingsData,
                                              )),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                                getSettingsdata:
                                                    ApiMethods.getSettingsData,
                                              )),
                                    );
                                  }
                                },
                                child: Center(
                                    child: Center(
                                  child: TextButton(
                                    child: Text(
                                      'Done'.tr(),
                                      style: const TextStyle(
                                          color: white, fontSize: 18),
                                    ),
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40),
                                                60)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                colorPrimary)),
                                    onPressed: () {
                                      if (controller.hasClients) {
                                        if (ApiMethods.getSettingsData!
                                                .result[0].isLogin ==
                                            "On") {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(
                                                      getSettingsData:
                                                          ApiMethods
                                                              .getSettingsData,
                                                    )),
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                      getSettingsdata:
                                                          ApiMethods
                                                              .getSettingsData,
                                                    )),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                )),
                              ),
                            )
                          : Center(
                              child: InkWell(
                                onTap: () {
                                  if (controller.hasClients) {
                                    controller.animateToPage(
                                      currentPage + 1,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                  setState(() {});
                                },
                                child: Center(
                                  child: TextButton(
                                    child: Text(
                                      'Next'.tr(),
                                      style: const TextStyle(
                                          color: white, fontSize: 18),
                                    ),
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40),
                                                60)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                colorPrimary)),
                                    onPressed: () {
                                      if (controller.hasClients) {
                                        controller.animateToPage(
                                          currentPage + 1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockVertical,
                    ),
                    Platform.isAndroid
                        ? StaticData.bannerAd == "1"
                            ? adContainer
                            : const Text("")
                        : StaticData.iosBannerAd == "1"
                            ? adContainer
                            : const Text(""),
                  ],
                ),
              );
            } else {
              return NoData(message: snapshot.data!.message.toString());
            }
          } else {
            return const Text("Error");
          }
        });
  }
}
