import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:flutter/material.dart';

class ProductCard1 extends StatefulWidget {
  Sub sub;
  ProductCard1({this.sub});
  @override
  _ProductCard1State createState() => _ProductCard1State();
}

class _ProductCard1State extends State<ProductCard1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          height: 180,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                height: 130.0,
                width: 130.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('${widget.sub.picpath}'),
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
                          Localizations.localeOf(context).languageCode == "en"
                              ? '${widget.sub.titleen}'
                              : '${widget.sub.titlear}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          starIcon(Colors.yellow[700]),
                                          starIcon(Colors.yellow[700]),
                                          starIcon(Colors.yellow[700]),
                                          starIcon(Colors.yellow[700]),
                                          starIcon(Colors.grey[200]),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Icon(Icons.add_shopping_cart)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Icon starIcon(Color color) {
    return Icon(
      Icons.star,
      size: 10.0,
      color: color,
    );
  }
}
