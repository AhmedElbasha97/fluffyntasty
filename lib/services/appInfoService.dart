import 'package:dio/dio.dart';
import 'package:fbTrade/model/Custom/appInfo.dart';
import 'package:fbTrade/model/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInfoService {
  final String url = "https://fluffyandtasty.com/api/";
  final String info = "settings";
  final String notifyLink = "notifications/user/";

  Future<AppInfo> getAppInfo() async {
    Response response;
    AppInfo infoData;
    try {
      response = await Dio().get(
        '$url$info',
      );
      var data = response.data;
      infoData = AppInfo.fromJson(data);
    } on DioError catch (e) {
      print('error in App Info => ${e.response}');
    }
    return infoData;
  }

  Future<List<NotificationModel>> getNotification() async {
    List<NotificationModel> notificationlist = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    if (userId != "") {
      try {
        Response response = await Dio().get(
          '$url$notifyLink$userId',
        );
        var data = response.data;
        data.forEach((element) {
          notificationlist.add(NotificationModel.fromJson(element));
        });
      } on DioError catch (e) {
        print('error in App Info => ${e.response}');
      }
    }
    return notificationlist;
  }
}
