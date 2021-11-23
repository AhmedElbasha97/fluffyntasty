import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/I10n/AppLanguage.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/Custom/homecategory.dart';
import 'package:fbTrade/model/product.dart';
import 'package:fbTrade/services/get_photo_slider.dart';
import 'package:fbTrade/services/get_products.dart';
import 'package:fbTrade/splash_screen.dart';
import 'package:fbTrade/ui/NewViewScreens/NewView1.dart';
import 'package:fbTrade/ui/NewViewScreens/NewView4.dart';
import 'package:fbTrade/ui/NewViewScreens/NewView5.dart';
import 'package:fbTrade/ui/NewViewScreens/NewViewScreen2.dart';
import 'package:fbTrade/ui/NewViewScreens/newView3.dart';
import 'package:fbTrade/ui/about_app_screen.dart';
import 'package:fbTrade/ui/contact_us_screen.dart';
import 'package:fbTrade/ui/edit_profile_screen.dart';
import 'package:fbTrade/ui/favProductsList.dart';
import 'package:fbTrade/ui/logIn_screen.dart';
import 'package:fbTrade/ui/myProducts_screen.dart';
import 'package:fbTrade/ui/notificationsScreen.dart';
import 'package:fbTrade/ui/privacyPolicy.dart';
import 'package:fbTrade/ui/signUp_screen.dart';
import 'package:fbTrade/ui/supportChat.dart';
import 'package:fbTrade/ui/terms_screen.dart';
import 'package:fbTrade/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/services/get_categories.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class MenOrWomen extends StatefulWidget {
  String id;
  MenOrWomen({this.id});
  @override
  _MenOrWomenState createState() => _MenOrWomenState();
}

class _MenOrWomenState extends State<MenOrWomen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  List<HomeCategory> list = [];
  List<ProductModel> products = [];
  List imgList;
  List child;
  int _current = 0;
  String whatsappNubmer = "";
  bool isCircleView = false;
  bool isNormalView = true;
  bool isDetailsView = false;
  bool isFullView = false;
  bool isFullCircleView = false;
  bool isBodyLoading = false;
  bool isLoading = true;
  bool isSearchClicked = false;

  String name;
  String token;

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context).translate('newUser')}";
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  getProducts(searchKey) async {
    isBodyLoading = true;
    setState(() {});
    products = await GetProducts().searchForProducts(searchKey);
    isBodyLoading = false;
    setState(() {});
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

  @override
  void initState() {
    super.initState();
    getMainCategories();
    getUserData();
  }

  getMainCategories() async {
    list = await GetCategories().getHomeCategory();
    await photoSlider();
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: mainColor,
        iconTheme: new IconThemeData(color: Colors.white),
        title: appInfo.logo == null || appInfo.logo == ""
            ? Image.asset(
                "assets/icon/appBarLogo.png",
                scale: 30,
              )
            : Container(
                color: Colors.white,
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                  imageUrl: "${appInfo.logo}",
                  fit: BoxFit.scaleDown,
                ),
              ),
        centerTitle: true,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 150,
                child: Container(
                  child: appInfo.logo == null || appInfo.logo == ""
                      ? Image.asset(
                          "assets/icon/logo.png",
                          scale: 3,
                        )
                      : CachedNetworkImage(
                          imageUrl: "${appInfo.logo}",
                          fit: BoxFit.scaleDown,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  token == null || token.isEmpty
                      ? InkWell(
                          onTap: () {
                            if (token.isEmpty)
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainColor),
                                color: mainColor),
                            child: Center(
                              child: Text(
                                "$name",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  token == null || token.isEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LogInScreen(),
                            ));
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: mainColor),
                                color: mainColor),
                            child: Center(
                              child: Text(
                                "${AppLocalizations.of(context).translate('login')}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            bool done = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ));
                            getUserData();
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                color: mainColor),
                            child: Center(
                              child: Text(
                                  "${AppLocalizations.of(context).translate('editProfile')}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                ],
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
                              color: mainColor, fontWeight: FontWeight.bold)),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: mainColor,
                      ),
                      onTap: () async {
                        bool done =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyProductsScreen(),
                        ));
                        getUserData();
                      },
                    ),
              SizedBox(
                height: 10,
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
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.home,
                  color: mainColor,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MenOrWomen(),
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
                    "${AppLocalizations.of(context).translate('whoAreWe')}",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.category,
                  color: mainColor,
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
              ListTile(
                title: Text(
                    "${AppLocalizations.of(context).translate('terms')}",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.description,
                  color: mainColor,
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
                    "${AppLocalizations.of(context).translate('privacyPolicy')}",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.description,
                  color: mainColor,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PolicyScreen(),
                )),
              ),
              Divider(
                height: 1,
                thickness: 2,
                endIndent: 30,
                indent: 30,
              ),
              ListTile(
                title: Text("Chat Support",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(Icons.support, color: mainColor),
                onTap: () {
                  _launchURL("${appInfo.support}");
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
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.language,
                  color: mainColor,
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
              token == null || token.isEmpty
                  ? Container()
                  : ListTile(
                      title: Text(
                          "${AppLocalizations.of(context).translate('signOut')}",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold)),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: mainColor,
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
                title: Text(
                    "${AppLocalizations.of(context).translate('callUs')}",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold)),
                leading: Icon(
                  Icons.phone,
                  color: mainColor,
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
                      onTap: () {
                        _launchURL("https://wa.me/${appInfo.whatsapp}");
                      },
                      child: Image.asset(
                        "assets/icon/whatsapp.png",
                        scale: 1.5,
                      )),
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
              : GestureDetector(
                  onTap: () => searchFocusNode.unfocus(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isSearchClicked
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField(
                                  controller: searchController,
                                  focusNode: searchFocusNode,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    getProducts(searchController.text);
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          getProducts(searchController.text);
                                        },
                                        icon: Icon(
                                          Icons.search,
                                          color: searchFocusNode.hasFocus
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                      hintText: "search...",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 1)),
                                ),
                              )
                            : Container(),
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
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _launchURL("${appInfo.support}");
                                  },
                                  icon: Icon(
                                    Icons.chat,
                                    color: mainColor,
                                    size: 30,
                                  )),
                              IconButton(
                                icon: Icon(
                                  Icons.info,
                                  color: mainColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _showMyDialog();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: mainColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  isSearchClicked = !isSearchClicked;
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.notifications,
                                  color: mainColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (token == null) {
                                    showMysigninDialog(context);
                                  } else {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationsScreen(),
                                    ));
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: mainColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (token == null) {
                                    showMysigninDialog(context);
                                  } else {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => FavProductsScreen(),
                                    ));
                                  }
                                },
                              ),
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.tune,
                              //     color: mainColor,
                              //     size: 30,
                              //   ),
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                        ),
                        isSearchClicked
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: LinearProductCard(
                                        id: products[index].id,
                                        titleEn: products[index].titleEn,
                                        titleAr: products[index].titleAr,
                                        detailsEn: products[index].detailsEn,
                                        detailsAr: products[index].detailsAr,
                                        price: products[index].price,
                                        video: products[index].video ?? "",
                                        salePrice: products[index].salePrice,
                                        isAllChecked: false,
                                        totalAmountInCart:
                                            products[index].quantity ?? 0,
                                        addItemToCart: () {},
                                        removeItemFromCart: () {},
                                        imgList: products[index].images,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : appInfo.themeId == "1"
                                ? NewViewOne(
                                    list: list,
                                  )
                                : appInfo.themeId == "2"
                                    ? NewViewScreenTwo(list: list)
                                    : appInfo.themeId == "3"
                                        ? ScreenViewFour(list: list)
                                        : appInfo.themeId == "4"
                                            ? NewViewScreen5(list: list)
                                            : NewViewScreenThree(list: list)
                      ],
                    ),
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
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: mainColor,
                      ))
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: mainColor,
                child: Center(
                    child: Text(
                        '${AppLocalizations.of(context).translate('aboutTheApp')}',
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: "${appInfo.aboutApp}",
              ),
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
