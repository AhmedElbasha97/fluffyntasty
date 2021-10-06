import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:fbTrade/widgets/newView/productCard2.dart';
import 'package:flutter/material.dart';

class ScreenViewFour extends StatefulWidget {
  List<HomeCategory> list = [];
  ScreenViewFour({this.list});
  @override
  _ScreenViewFourState createState() => _ScreenViewFourState();
}

class _ScreenViewFourState extends State<ScreenViewFour> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Localizations.localeOf(context).languageCode == "en"
                        ? "${widget.list[index].titleEn}"
                        : "${widget.list[index].titleAr}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "${"${AppLocalizations.of(context).translate('seeall')}"}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(id: widget.list[index].id),
                ));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: Localizations.localeOf(context).languageCode == "en"
                      ? "${widget.list[index].picpathEn}"
                      : "${widget.list[index].picpath}",
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                itemCount: 5,
                // widget.list[index].sub.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index2) {
                  return ProductCard2(
                    sub: Sub(
                        id: "1",
                        titlear: "منتج 1",
                        titleen: "product",
                        picpath:
                            "https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-collection-1_large.png?v=1530129113"),
                  );
                },
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
