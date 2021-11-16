import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/cart_product.dart';
import 'package:fbTrade/model/category.dart';
import 'package:fbTrade/model/cerditData.dart';
import 'package:fbTrade/services/cart_services.dart';
import 'package:fbTrade/services/checkout.dart';
import 'package:fbTrade/ui/payment_screen.dart';
import 'package:fbTrade/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fbTrade/global.dart';


class CartScreen extends StatefulWidget {
  List<WrokHours> shifts;
  String id;
  String name;
  CartScreen({this.shifts, this.id, this.name});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  String token;
  int totalPrice;
  List<CartProductModel> productModelList = List<CartProductModel>();
  List<String> cart = List<String>();
  // CreditData credit;

  getData() async {
    await checkToken();
    if (token.isNotEmpty) {
      await getProducts();
      // await getCredit();
    }
    isLoading = false;
    setState(() {});
  }

  // getCredit() async {
  //   if (token.isNotEmpty) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String userId = prefs.getString('id') ?? "";
  //     print(userId);
  //     print( widget.id);
  //     print(token);
  //     credit = await Checkout().getCreditData(
  //       id: userId,
  //       token: token,
  //       categoryId: widget.id,
  //     );
  //   }
  // }

  getProducts() async {
    productModelList = await CartServices().viewCart(true);
    productModelList.forEach((element) {
      cart.add(element.id);
    });
    totalPrice = CartServices.totalPrice;
  }

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "سله المشتريات",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  productModelList == null || productModelList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              "${AppLocalizations.of(context).translate('noProducts')}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        )
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productModelList.length,
                          itemBuilder: (context, index) {
                            print(productModelList[index].id);
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: LinearProductCard(
                                id: productModelList[index].id,
                                titleEn: productModelList[index].titleEn,
                                titleAr: productModelList[index].titleAr,
                                detailsEn: productModelList[index].categoryEn,
                                detailsAr: productModelList[index].categoryAr,
                                price: productModelList[index].price,
                                totalAmount: productModelList[index].quantity,
                                salePrice: productModelList[index].salePrice,
                                video: "",
                                addItemToCart: () {
                                  totalPrice = totalPrice +
                                      double.parse(
                                              productModelList[index].price)
                                          .toInt();
                                  setState(() {});
                                  Future.delayed(
                                      Duration(
                                        microseconds: 500,
                                      ), () async {
                                    if (token.isNotEmpty) await getProducts();
                                    print(productModelList.length);
                                    setState(() {});
                                  });
                                },
                                removeItemFromCart: () async {
                                  totalPrice = totalPrice <= 0
                                      ? 0
                                      : totalPrice -
                                          double.parse(
                                                  productModelList[index].price)
                                              .toInt();
                                  setState(() {});
                                  Future.delayed(
                                      Duration(
                                        microseconds: 500,
                                      ), () async {
                                    if (token.isNotEmpty) await getProducts();
                                    print(productModelList.length);
                                    setState(() {});
                                  });
                                },
                                imgList: List(),
                                image: productModelList[index].image,
                              ),
                            );
                          },
                        ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${"${AppLocalizations.of(context).translate('totalPrice')}"} : $totalPrice",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            await checkToken();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                  // creditData: credit,
                                  cart: cart,
                                  name: widget.name,
                                  totalPrice: totalPrice,
                                  isSale: 0,
                                  shifts: widget.shifts),
                            ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${AppLocalizations.of(context).translate('buy')}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(top: 40)),
                ],
              ),
            ),
    );
  }
}
