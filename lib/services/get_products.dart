import 'package:dio/dio.dart';
import 'package:fbTrade/model/Custom/favoratieProduct.dart';
import 'package:fbTrade/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProducts {
  final String url = "https://fluffyandtasty.com/api/";
  final String category = "products/category/";
  final String subCategory = "products/subcategory/";
  final String fav = "myfav";
  final String addFav = "addfav";
  final String search = "search";
  static List categoryPhotos;
  static String offerDialogAr;
  static String offerDialogEn;

  Future<List<ProductModel>> getProducts(String categoryId, int page,
      [bool isSubCats = false]) async {
    Response response;
    List<ProductModel> productModelList = List<ProductModel>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";

    try {
      token.isEmpty
          ? response = await Dio().get("$url$category$categoryId/page/$page")
          : response = await Dio().get("$url$category$categoryId/page/$page",
              options: Options(headers: {"token": "$token"}));
      List data = response.data['products'];
      categoryPhotos = response.data['category_slider'];
      offerDialogAr = response.data['category_slider_details_ar'];
      offerDialogEn = response.data['category_slider_details_en'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response.data}');
    }

    return productModelList;
  }

  Future<List<ProductModel>> searchForProducts(String searchKey) async {
    Response response;
    List<ProductModel> productModelList = List<ProductModel>();
    try {
      response = await Dio().post("$url$search", data: {"keyword": searchKey});
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in search products => ${e.response.data}');
    }

    return productModelList;
  }

  Future<List<ProductModel>> getSubCategoryProducts(
      String categoryId, int page) async {
    Response response;
    List<ProductModel> productModelList = List<ProductModel>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";

    try {
      token.isEmpty
          ? response = await Dio().get("$url$subCategory$categoryId/page/$page")
          : response = await Dio().get("$url$subCategory$categoryId/page/$page",
              options: Options(headers: {"token": "$token"}));
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response.data}');
    }

    return productModelList;
  }

  Future<List<FavProduct>> getFavProducts() async {
    List<FavProduct> FavProducts = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    var body = FormData.fromMap({"member_id": userId});
    if (userId != "") {
      try {
        Response response = await Dio().post('$url$fav', data: body);
        List data = response.data["data"];
        data.forEach((element) {
          FavProducts.add(FavProduct.fromJson(element));
        });
      } on DioError catch (e) {
        print('error in fav product => ${e.response}');
      }
    }
    return FavProducts;
  }

  Future<String> addToFav(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    var body = FormData.fromMap({"product_id": id, "member_id": userId});
    if (userId != "") {
      try {
        Response res = await Dio().post('$url$addFav', data: body);
        print(res.data);
        return res.data['message'];
      } on DioError catch (e) {
        print('error in fav product => ${e.response}');
      }
    }
  }
}
