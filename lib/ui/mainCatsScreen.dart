import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/ui/men_or_women.dart';
import 'package:flutter/material.dart';

class MainCategoriesScreen extends StatefulWidget {
  @override
  _MainCategoriesScreenState createState() => _MainCategoriesScreenState();
}

class _MainCategoriesScreenState extends State<MainCategoriesScreen> {
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MenOrWomen(id: list[index].id),
              ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: CachedNetworkImage(
                  imageUrl: Localizations.localeOf(context).languageCode == "en"
                      ? "${list[index].picpathEn}"
                      : "${list[index].picpath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
