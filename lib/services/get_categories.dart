import 'package:dio/dio.dart';
import 'package:fbTrade/model/category.dart';
import 'package:fbTrade/model/main_model.dart';

class GetCategories {
  final String url = "https://fb-trade.com/api/";
  final String category = "category";
  final String main = "main/";
  final String location = "/location";

  Future<List<CategoryModel>> getCategory(String id) async {
    Response response;
    List<CategoryModel> categoryModelList = List<CategoryModel>();
    try {
      response = await Dio().get('$url$category/$id');
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<MainCategory>> getMainCategory() async {
    Response response;
    List<MainCategory> categoryModelList = List<MainCategory>();
    try {
      response =
          await Dio().get('$url$main$category');
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(MainCategory.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<CategoryModel>> searchCategory(String keyword) async {
    Response response;
    List<CategoryModel> categoryModelList = List<CategoryModel>();
    try {
      response = await Dio().get('$url$category?keyword=$keyword');
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<CategoryModel>> getCategoryByLocation(
      double lat, double long, String id) async {
    Response response;
    List<CategoryModel> categoryModelList = List<CategoryModel>();
    try {
      response = await Dio().post('$url$category$location',
          data: {"lat": "$lat", "long": "$long", "main_category_id": "$id"});
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }
}
