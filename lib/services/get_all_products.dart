import 'package:dio/dio.dart';
import 'package:fbTrade/model/product.dart';

class GetAllProducts {
  final String url = "https://fluffyandtasty.com/api/";
  final String category = "products/page/";
  final String byCategory = "products/category";

  Future getAllProducts(int page, String token) async {
    Response response;
    List<ProductModel> productModelList = List<ProductModel>();

    try {
      if (token.isEmpty)
        response = await Dio().get("$url$category$page");
      else
        response = await Dio().get(
          "$url$category$page",
          options: Options(headers: {"token": "$token"}),
        );
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response.data}');
    }
    return productModelList;
  }

  Future getProductsbyCategory(int page, String token, String id) async {
    Response response;
    List<ProductModel> productModelList = List<ProductModel>();

    String link = "$url$byCategory/$id/page/$page";

    try {
      if (token == null)
        response = await Dio().get(link);
      else
        response = await Dio().get(
          link,
          options: Options(headers: {"token": "$token"}),
        );

      print(link);
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response.data}');
    }
    return productModelList;
  }
}
