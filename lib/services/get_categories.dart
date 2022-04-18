import 'package:dio/dio.dart';
import 'package:fbTrade/model/Custom/homecategory.dart' as home;
import 'package:fbTrade/model/category.dart';
import 'package:fbTrade/model/main_model.dart';
import 'package:fbTrade/model/orders.dart';
import 'package:fbTrade/model/product.dart';

class GetCategories {
  final String url = "https://fluffyandtasty.com/api/";
  final String category = "category";
  final String main = "main/";
  final String location = "/location";
  final String products = "products/";

  Future<List<CategoryModel>> getCategory(String id) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
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
    List<MainCategory> categoryModelList = <MainCategory>[];
    try {
      response = await Dio().get('$url$main$category');
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(MainCategory.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<ProductModel>> getSubCategoryProducts(String? id, int page) async {
    Response response;
    List<ProductModel> productslList = [];
    try {
      print('$url$products$category/$id/page/$page');
      response = await Dio().get('$url$products$category/$id/page/$page');
      List data = response.data["products"];
      data.forEach((element) {
        productslList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return productslList;
  }

  Future<List<CategoryModel>> searchCategory(String keyword) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
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
      double lat, double long, String? id) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
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

  Future<List<home.HomeCategory>> getHomeCategory() async {
    Response response;
    List<home.HomeCategory> categoriesList = [];
    try {
      response = await Dio().get(
        '$url$main$category',
      );
      List data = response.data;
      data.forEach((element) {
        categoriesList.add(home.HomeCategory.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in Home category => ${e.response}');
    }
    return categoriesList;
  }
}
