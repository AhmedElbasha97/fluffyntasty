import 'package:dio/dio.dart';
import 'package:fbTrade/model/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  final String url = "https://fluffyandtasty.com/api/";
  final String viewCartEndpoint = "mycart";
  final String addToCartEndpoint = "cart";
  final String removeFromCartEndpoint = "deletecart";
  final String decreaseFromCartEnPoint = "updatecart";
  static int? totalPrice;
  static int? totalQuantity;

  Future<List<CartProductModel>> viewCart(bool inCartSelected) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

      List<CartProductModel> cartProductModelList = <CartProductModel>[];
    try {
      response = await Dio().post("$url$viewCartEndpoint",
          options: Options(headers: {"token": "$token"}));
      List? data = response.data['data'];
      totalPrice = response.data['total'];
      totalQuantity = response.data['total_quantity'];
      if (data != null)
        data.forEach((element) {
          cartProductModelList.add(CartProductModel.fromJson(element));
        });
    } on DioError catch (e) {
      print('error from viewcart => ${e.response}');
    }
    return cartProductModelList;
  }

  addToCart(var productId, [String? colorId, String? sizeId]) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      var body = FormData.fromMap({
        "product_id": "$productId",
        "quantity": "1",
        "color_id": colorId,
        "size_id": sizeId
      });
      response = await Dio().post('$url$addToCartEndpoint',
          data: body, options: Options(headers: {"token": "$token"}));
      print(response);
    } on DioError catch (e) {
      print('error from addToCart => ${e.response}');
    }
  }

  decreaseFromCart(var productId, int? quantity) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      response = await Dio().post('$url$decreaseFromCartEnPoint',
          data: {"product_id": "$productId", "quantity": "$quantity"},
          options: Options(headers: {"token": "$token"}));
      print(response.data);
    } on DioError catch (e) {
      print('error from removeFromCart => ${e.response}');
    }
  }

  removeFromCart(var productId) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      response = await Dio().post('$url$removeFromCartEndpoint',
          data: {"product_id": "$productId"},
          options: Options(headers: {"token": "$token"}));
      print(response.data);
    } on DioError catch (e) {
      print('error from removeFromCart => ${e.response}');
    }
  }
}
