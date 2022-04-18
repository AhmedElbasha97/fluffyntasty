import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/ui/NewViewScreens/CategoryDetails.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:flutter/material.dart';

class NewViewScreenThree extends StatefulWidget {
  List<HomeCategory>? list = [];

  NewViewScreenThree({this.list});

  @override
  _NewViewScreenThreeState createState() => _NewViewScreenThreeState();
}

class _NewViewScreenThreeState extends State<NewViewScreenThree> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: widget.list!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoryDetails(widget.list![index], 
                    Localizations.localeOf(context).languageCode),
              ));
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: mainColor,
                    backgroundImage: NetworkImage(
                        Localizations.localeOf(context).languageCode == "en"
                            ? "${widget.list![index].picpathEn}"
                            : "${widget.list![index].picpath}"),
                  ),
                ),
                Text(
                  Localizations.localeOf(context).languageCode == "en"
                      ? "${widget.list![index].titleen}"
                      : "${widget.list![index].titlear}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
