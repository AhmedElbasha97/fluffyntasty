import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/ui/home_screen.dart';
import 'package:flutter/material.dart';

class NewViewOne extends StatefulWidget {
  List<HomeCategory> list = [];

  NewViewOne({this.list});
  @override
  _NewViewOneState createState() => _NewViewOneState();
}

class _NewViewOneState extends State<NewViewOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(id: widget.list[index].id),
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
                      ? "${widget.list[index].picpathEn}"
                      : "${widget.list[index].picpath}",
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
