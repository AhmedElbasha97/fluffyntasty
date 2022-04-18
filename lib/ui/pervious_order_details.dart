import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/orders.dart';
import 'package:fbTrade/widgets/myProduct_card.dart';
import 'package:flutter/material.dart';

class PreviousOrderDetails extends StatefulWidget {

  List<ProductsModel>? products;
  String? totalPrice;


  PreviousOrderDetails(this.products, this.totalPrice);

  @override
  _PreviousOrderDetailsState createState() => _PreviousOrderDetailsState();
}

class _PreviousOrderDetailsState extends State<PreviousOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("${AppLocalizations.of(context)!.translate('myProducts')}",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.products!.length,
              itemBuilder: (context,index){
                return MyProductCard(
                  titleAr: widget.products![index].titleAr,
                  titleEn: widget.products![index].titleEn,
                  price: widget.products![index].price,
                  photo: widget.products![index].photo,
                );
              },
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              alignment: Alignment.center,
              child: Text(
                "${AppLocalizations.of(context)!.translate('totalPrice')} : ${widget.totalPrice}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          ],
        ),
      ),
    );
  }
}
