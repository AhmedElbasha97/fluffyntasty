import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/notifications.dart';
import 'package:fbTrade/services/appInfoService.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  getNotification() async {
    list = await AppInfoService().getNotification();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${list[index].message}"),
                    trailing: Icon(Icons.notifications),
                  ),
                );
              },
            ),
    );
  }
}
