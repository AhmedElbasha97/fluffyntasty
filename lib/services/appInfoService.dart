import 'package:dio/dio.dart';
import 'package:fbTrade/model/Custom/appInfo.dart';

class AppInfoService {
  final String url = "https://fluffyandtasty.com/api/";
  final String info = "settings";

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
}
