import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/I10n/AppLanguage.dart';
import 'package:fbTrade/model/Custom/appInfo.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/services/appInfoService.dart';
import 'package:fbTrade/services/get_photo_slider.dart';
import 'package:fbTrade/splash_screen.dart';
import 'package:fbTrade/ui/about_app_screen.dart';
import 'package:fbTrade/ui/contact_us_screen.dart';
import 'package:fbTrade/ui/edit_profile_screen.dart';
import 'package:fbTrade/ui/logIn_screen.dart';
import 'package:fbTrade/ui/myProducts_screen.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:fbTrade/ui/terms_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/services/get_categories.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class MenOrWomen extends StatefulWidget {
  MenOrWomen();
  @override
  _MenOrWomenState createState() => _MenOrWomenState();
}

class _MenOrWomenState extends State<MenOrWomen> {
  List<HomeCategory> list = [];
  List imgList;
  List child;
  int _current = 0;
  String whatsappNubmer = "";
  AppInfo appInfo;
  bool isCircleView = false;
  bool isNormalView = true;
  bool isDetailsView = true;

  String name;
  String token;

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context).translate('newUser')}";
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  getPhotoSlider() async {
    imgList = await GetPhotoSlider().getPhotoSlider();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  photoSlider() async {
    await getPhotoSlider();
    print(imgList.first);
    child = map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i,
              fit: BoxFit.cover,
              width: 1000.0,
              placeholder: (context, url) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getMainCategories();
  }

  getMainCategories() async {
    list = await GetCategories().getHomeCategory();
    await photoSlider();
    appInfo = await AppInfoService().getAppInfo();
    isLoading = false;
    setState(() {});
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFa44088),
        iconTheme: new IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/icon/appBarLogo.png",
          scale: 30,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            SizedBox(
              height: 150,
              child: Container(
                child: Image.asset(
                  "assets/icon/logo.png",
                  scale: 3,
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            token == null || token.isEmpty
                ? ListTile(
                    title: Text(
                      "$name",
                      style: TextStyle(
                          color: Color(0xFFFa44088),
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () {
                      if (token.isEmpty)
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                    })
                : Container(),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            token == null || token.isEmpty
                ? ListTile(
                    title: Text(
                      "${AppLocalizations.of(context).translate('login')}",
                      style: TextStyle(
                          color: Color(0xFFFa44088),
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LogInScreen(),
                      ));
                    },
                  )
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('editProfile')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.edit,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      bool done =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ));
                      getUserData();
                    },
                  ),
            token == null || token.isEmpty
                ? Container()
                : Divider(
                    height: 1,
                    thickness: 2,
                    endIndent: 30,
                    indent: 30,
                  ),
            token == null || token.isEmpty
                ? Container()
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('myProducts')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      bool done =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProductsScreen(),
                      ));
                      getUserData();
                    },
                  ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('home')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.home,
                color: Color(0xFFFa44088),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ));
              },
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('changeLang')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.language,
                color: Color(0xFFFa44088),
              ),
              onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => changeLangPopUp()),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('terms')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.description,
                color: Color(0xFFFa44088),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TermsScreen(),
              )),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text(
                  "${AppLocalizations.of(context).translate('whoAreWe')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.category,
                color: Color(0xFFFa44088),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutAppScreen(),
              )),
            ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            token == null || token.isEmpty
                ? Container()
                : ListTile(
                    title: Text(
                        "${AppLocalizations.of(context).translate('signOut')}",
                        style: TextStyle(
                            color: Color(0xFFFa44088),
                            fontWeight: FontWeight.bold)),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Color(0xFFFa44088),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SplashScreen(),
                      ));
                    },
                  ),
            Divider(
              height: 1,
              thickness: 2,
              endIndent: 30,
              indent: 30,
            ),
            ListTile(
              title: Text("${AppLocalizations.of(context).translate('callUs')}",
                  style: TextStyle(
                      color: Color(0xFFFa44088), fontWeight: FontWeight.bold)),
              leading: Icon(
                Icons.phone,
                color: Color(0xFFFa44088),
              ),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactUsScreen(),
                ));
              },
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
                InkWell(
                  onTap: () => _launchURL("${appInfo.facebook}"),
                  child: Image.asset(
                    "assets/icon/facebook.png",
                    scale: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => _launchURL("${appInfo.instagram}"),
                  child: Image.asset(
                    "assets/icon/instagram.png",
                    scale: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () => _launchURL("${appInfo.twitter}"),
                  child: Image.asset(
                    "assets/icon/twitter.png",
                    scale: 1.5,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${AppLocalizations.of(context).translate('policy1')}",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text("${AppLocalizations.of(context).translate('policy2')}",
                      style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: () => _launchURL("https://www.syncqatar.com/"),
                    child: Text(
                      "سينك",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : list.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "${AppLocalizations.of(context).translate('noCats')}"),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CarouselSlider(
                        items: child,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: Color(0xFFFa44088),
                                size: 30,
                              ),
                              onPressed: () {
                                isNormalView = true;
                                isDetailsView = false;
                                isCircleView = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_module,
                                color: Color(0xFFFa44088),
                                size: 30,
                              ),
                              onPressed: () {
                                isNormalView = false;
                                isDetailsView = true;
                                isCircleView = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.circle,
                                color: Color(0xFFFa44088),
                                size: 30,
                              ),
                              onPressed: () {
                                isNormalView = false;
                                isDetailsView = false;
                                isCircleView = true;
                                setState(() {});
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  _launchURL(
                                      "https://wa.me/${appInfo.whatsapp}");
                                },
                                icon: Image.asset(
                                  "assets/icon/whatsapp.png",
                                  scale: 2.0,
                                )),
                            IconButton(
                              icon: Icon(
                                Icons.info,
                                color: Color(0xFFFa44088),
                                size: 30,
                              ),
                              onPressed: () {
                                _showMyDialog();
                              },
                            ),
                          ],
                        ),
                      ),
                      isNormalView
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(id: list[index].id),
                                    ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image.network(
                                        Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? "${list[index].picpathEn}"
                                            : "${list[index].picpath}"),
                                  ),
                                );
                              },
                            )
                          : isDetailsView
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? "${list[index].titleEn}"
                                                : "${list[index].titleAr}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                  id: list[index].id),
                                            ));
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: CachedNetworkImage(
                                              imageUrl: Localizations.localeOf(
                                                              context)
                                                          .languageCode ==
                                                      "en"
                                                  ? "${list[index].picpathEn}"
                                                  : "${list[index].picpath}",
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: ListView.builder(
                                            itemCount: list[index].sub.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return Card(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 80,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.network(
                                                            "${list[index].sub[index2].picpath}"),
                                                      ),
                                                    ),
                                                    Text(Localizations.localeOf(
                                                                    context)
                                                                .languageCode ==
                                                            "en"
                                                        ? "${list[index].sub[index2].titleen}"
                                                        : "${list[index].sub[index2].titlear}")
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    );
                                  },
                                )
                              : GridView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: list.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(id: list[index].id),
                                        ));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Color(0xFFFa44088),
                                          backgroundImage: NetworkImage(
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? "${list[index].picpathEn}"
                                                  : "${list[index].picpath}"),
                                        ),
                                      ),
                                    );
                                    ;
                                  },
                                ),
                    ],
                  ),
                ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
                  '${AppLocalizations.of(context).translate('aboutTheApp')}')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${appInfo.aboutApp}",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: FlatButton(
                child: Text('${AppLocalizations.of(context).translate('back')}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget changeLangPopUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('${AppLocalizations.of(context).translate('language')}'),
      message: new Text(
          '${AppLocalizations.of(context).translate('changeLanguage')}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('عربى'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }
}
