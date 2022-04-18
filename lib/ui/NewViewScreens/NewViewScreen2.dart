import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/ui/NewViewScreens/CategoryDetails.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:fbTrade/ui/productDetails.dart';
import 'package:fbTrade/widgets/newView/productCard1.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../products_screen.dart';

class NewViewScreenTwo extends StatefulWidget {
  List<HomeCategory>? list = [];
  NewViewScreenTwo({this.list});
  @override
  _NewViewScreenTwoState createState() => _NewViewScreenTwoState();
}

class _NewViewScreenTwoState extends State<NewViewScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.list!.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Localizations.localeOf(context).languageCode == "en"
                        ? "${widget.list![index].titleen}"
                        : "${widget.list![index].titlear}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoryDetails(
                            widget.list![index],
                            Localizations.localeOf(context).languageCode),
                      ));
                    },
                    child: Text(
                      "${"${AppLocalizations.of(context)!.translate('seeall')}"}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoryDetails(widget.list![index],
                      Localizations.localeOf(context).languageCode),
                ));
              },
              child: Container(
                height: (Localizations.localeOf(context).languageCode == "en" &&
                            widget.list![index].picpathEn!.isEmpty) ||
                        (Localizations.localeOf(context).languageCode == "ar" &&
                            widget.list![index].picpath!.isEmpty)
                    ? 10
                    : MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: Localizations.localeOf(context).languageCode == "en"
                      ? "${widget.list![index].picpathEn}"
                      : "${widget.list![index].picpath}",
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                itemCount: widget.list![index].products!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index2) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductsDetails(
                            product: widget.list![index].products![index2]),
                      ));
                    },
                    child: ProductCard1(
                      product: widget.list![index].products![index2],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
