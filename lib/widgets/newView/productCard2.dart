import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/get_products.dart';
import 'package:flutter/material.dart';

class ProductCard2 extends StatefulWidget {
  ProductModel? product;
  ProductCard2({this.product});
  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 250,
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150.0,
                      width: 140.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              '${widget.product!.images!.isEmpty ? "" : widget.product!.images!.first}'),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Text(
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? '${widget.product!.titleEn}'
                                  : '${widget.product!.titleAr}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${widget.product!.price}',
                                              style: TextStyle(fontSize: 20)),
                                          double.parse(widget
                                                      .product!.salePrice!) !=
                                                  0
                                              ? Text(
                                                  '${widget.product!.salePrice}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.red,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    GetProducts().addToFav(widget.product!.id);
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            double.parse(widget.product!.salePrice!) == 0
                ? Container()
                : Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                      child: Text(
                        "offer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
