import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview/pages/home_page.dart';
import 'package:webview/provider/apiprovider.dart';
import 'package:webview/utils/colors.dart';

import '../utils/adhelper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    var apiprovide = Provider.of<ApiProvider>(context, listen: false);
    apiprovide.getNotificationList();
    AdHelper.createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: colorPrimary,
      ),
      body: Consumer<ApiProvider>(
        builder: (context, snapshot, child) {
          if (!snapshot.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            AdHelper.showRewardedAd();
            return ListView.builder(
                itemCount: snapshot.notificationModel.result?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _launchUrl(Uri.parse(snapshot
                              .notificationModel.result?[index].url
                              .toString() ??
                          ""));
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (snapshot.notificationModel.result?[index].image ??
                                        "")
                                    .isNotEmpty
                                ? Image.network(
                                    snapshot.notificationModel.result?[index]
                                            .image
                                            .toString() ??
                                        "",
                                    fit: BoxFit.fill,
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                snapshot.notificationModel.result?[index].title
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                    color: black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                snapshot.notificationModel.result?[index].title
                                        .toString() ??
                                    "",
                                style: TextStyle(
                                    color: gray,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, right: 10),
                                  child: Text(
                                    (snapshot.notificationModel.result?[index]
                                                .createdAt
                                                .toString() ??
                                            "")
                                        .split('T')
                                        .first,
                                    style: TextStyle(
                                        color: gray,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
