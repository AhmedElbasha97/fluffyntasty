import 'package:dio/dio.dart';
import 'package:fbTrade/model/product.dart';

class GetAllProducts {
  final String url = "https://fb-trade.com/api/";
  final String category = "products/page/";

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
}
