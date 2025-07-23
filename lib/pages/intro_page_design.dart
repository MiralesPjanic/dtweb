import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:provider/provider.dart';
import 'package:webview/utils/adhelper.dart';
import 'package:webview/utils/colors.dart';
import 'package:webview/utils/sharedpre.dart';
import 'package:webview/widgets/no_data.dart';
import '../provider/apiprovider.dart';
import '../responsible_file/responsible_file.dart';
import 'home_page.dart';
import 'login_page.dart';

class IntroPageDesign extends StatefulWidget {
  const IntroPageDesign({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPageDesign> {
  var apiprovide;
  SharedPre sharedPre = SharedPre();

  @override
  void initState() {
    super.initState();
    getId();
    apiprovide = Provider.of<ApiProvider>(context, listen: false);
    apiprovide.getIntroList();
  }

  getId() async {
    await AdHelper.getAds();
  }

  void onDonePress() async {
    await sharedPre.save("isfirst", "1");

    if (apiprovide.getSettingModel.result?[0].isLogin == "On") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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

    return Scaffold(
      body: Consumer<ApiProvider>(builder: (context, snapshot, child) {
        if (snapshot.loading) {
          if (snapshot.introModel.status == 200 &&
              snapshot.introModel.result!.isNotEmpty) {
            return Stack(
              children: [
                PageView.builder(
                  onPageChanged: (index) {
                    if (index != 0) {}
                    currentPage = index;
                    setState(() {});
                  },
                  itemCount: snapshot.introModel.result!.length,
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(10),
                            child: Image.network(snapshot
                                .introModel.result![index].image
                                .toString()),
                          ),
                          SizedBox(
                            height: SizeConfig.blockHorizontal + 1,
                          ),
                          SizedBox(
                            height: 50,
                            child: Text(
                              snapshot.introModel.result![index].title
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: SizeConfig.blockVertical * 3,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            margin:
                                EdgeInsets.all(SizeConfig.blockVertical + 2),
                            child: Text(
                                snapshot.introModel.result![index].description
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockVertical * 1.5,
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  top: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: (snapshot.introModel.result?.length.toInt() ??
                                      0 - 1) ==
                                  currentPage
                              ? null
                              : InkWell(
                                  onTap: () {
                                    onDonePress();
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
                ),
                Positioned.fill(
                  bottom: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: DotsIndicator(
                            dotsCount: snapshot.introModel.result!.length,
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
                ),
                Positioned(
                  bottom: 5,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: currentPage == snapshot.introModel.result!.length - 1
                        ? Center(
                            child: Center(
                                child: Center(
                              child: TextButton(
                                child: Text(
                                  'Done'.tr(),
                                  style: const TextStyle(
                                      color: white, fontSize: 18),
                                ),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        (MediaQuery.of(context).size.width -
                                            40),
                                        60)),
                                    backgroundColor: MaterialStateProperty.all(
                                        colorPrimary)),
                                onPressed: () {
                                  onDonePress();
                                },
                              ),
                            )),
                          )
                        : Center(
                            child: InkWell(
                              onTap: () {
                                if (controller.hasClients) {
                                  controller.animateToPage(
                                    currentPage + 1,
                                    duration: const Duration(milliseconds: 400),
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
                ),
              ],
            );
          } else {
            return NoData(message: snapshot.introModel.message.toString());
          }
        } else {
          return const Text("Error");
        }
      }),
    );
  }
}
