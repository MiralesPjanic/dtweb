import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview/api_services/api_methods.dart';
import 'package:webview/models/get_notification_list_model.dart';
import 'package:webview/utils/colors.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: colorPrimary,
      ),
      body: FutureBuilder<GetNotificationListModel?>(
        future: ApiMethods.getNotificationList(),
        builder: (context, AsyncSnapshot<GetNotificationListModel?> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.result!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _launchUrl(Uri.parse(
                          snapshot.data!.result![index].url.toString()));
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
                            snapshot.data!.result![index].image!.isNotEmpty
                                ? Image.network(
                                    snapshot.data!.result![index].image
                                        .toString(),
                                    fit: BoxFit.fill,
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                snapshot.data!.result![index].title.toString(),
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
                                snapshot.data!.result![index].title.toString(),
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
                                    snapshot.data!.result![index].createdAt
                                        .toString()
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
          } else {
            return const Center(child: CircularProgressIndicator());
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
