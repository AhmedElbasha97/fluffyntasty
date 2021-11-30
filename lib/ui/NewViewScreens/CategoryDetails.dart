import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/Custom/homecategory.dart' as home;
import 'package:fbTrade/services/get_categories.dart';
import 'package:fbTrade/ui/cart_screen.dart';
import 'package:fbTrade/widgets/GridProductCard.dart';
import 'package:fbTrade/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:fbTrade/model/product.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetails extends StatefulWidget {
  home.HomeCategory category;
  String lang;
  CategoryDetails(this.category, this.lang);
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Widget> tabsList = [];
  bool isLoading = false;
  bool isbodyLoading = false;
  bool isLinear = true;
  int apiPage = 1;
  int totalProductsInCart = 0;
  List<ProductModel> productsList = [];
  String selectedSubCategoryId;
  String token;

  @override
  void initState() {
    productsList = widget.category.products;
    super.initState();
    getToken();
    tabController =
        TabController(length: (widget.category.sub.length + 1), vsync: this);
    initListOfTabs();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ? "${widget.category.titleen}"
              : "${widget.category.titlear}",
          style: TextStyle(color: Colors.white, fontFamily: 'tajawal'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (token == "") {
                showMysigninDialog(context);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartScreen(
                    id: widget.category.mainCategoryId,
                    name: widget.lang == "en"
                        ? widget.category.titleen
                        : widget.category.titlear,
                  ),
                ));
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 13,
                  child: Text(
                    "$totalProductsInCart",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              ],
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LazyLoadScrollView(
              onEndOfPage: () {
                apiPage++;
                getProductsBySubCategory(selectedSubCategoryId);
              },
              child: ListView(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  widget.category.slider == null ||
                          widget.category.slider.isEmpty
                      ? Container()
                      : CarouselSlider.builder(
                          itemCount: widget.category.slider.length,
                          itemBuilder: (BuildContext context, int itemIndex) =>
                              Container(
                            margin: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: CachedNetworkImage(
                                imageUrl: widget.category.slider[itemIndex],
                                fit: BoxFit.cover,
                                width: 1000.0,
                                placeholder: (context, url) => SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {},
                          ),
                        ),
                  DefaultTabController(
                    length: tabsList.length,
                    child: PreferredSize(
                      preferredSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.15),
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.black,
                        controller: tabController,
                        tabs: tabsList,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.view_module,
                              color: mainColor,
                              size: 40,
                            ),
                            onPressed: () {
                              isLinear = false;
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.format_list_bulleted,
                              color: mainColor,
                              size: 40,
                            ),
                            onPressed: () {
                              isLinear = true;
                              setState(() {});
                            },
                          )
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  isbodyLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : isLinear
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: LinearProductCard(
                                    id: productsList[index].id,
                                    titleEn: productsList[index].titleEn,
                                    titleAr: productsList[index].titleAr,
                                    detailsEn: productsList[index].detailsEn,
                                    detailsAr: productsList[index].detailsAr,
                                    price: productsList[index].price,
                                    video: productsList[index].video ?? "",
                                    salePrice: productsList[index].salePrice,
                                    isAllChecked: false,
                                    totalAmountInCart:
                                        productsList[index].quantity ?? 0,
                                    addItemToCart: () {
                                      totalProductsInCart++;
                                      setState(() {});
                                    },
                                    removeItemFromCart: () {
                                      totalProductsInCart--;
                                      setState(() {});
                                      Future.delayed(Duration(seconds: 1),
                                          () async {
                                        setState(() {});
                                      });
                                    },
                                    imgList: productsList[index].images,
                                  ),
                                );
                              },
                            )
                          : GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.7)),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: GridProductCard(
                                    id: productsList[index].id,
                                    titleEn: productsList[index].titleEn,
                                    titleAr: productsList[index].titleAr,
                                    detailsEn: productsList[index].detailsEn,
                                    detailsAr: productsList[index].detailsAr,
                                    price: productsList[index].price,
                                    video: productsList[index].video ?? "",
                                    totalAmount: 0,
                                    addItemToCart: () {
                                      totalProductsInCart++;
                                      setState(() {});
                                    },
                                    removeItemFromCart: () {
                                      totalProductsInCart--;
                                      setState(() {});
                                    },
                                    imgList: productsList[index].images,
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
    );
  }

  initListOfTabs() {
    tabsList.add(InkWell(
      onTap: () async {
        tabController.animateTo(0);
        apiPage = 1;
        // await getProducts(isSwitch: true);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: mainColor,
            child: Icon(
              Icons.category,
              color: Colors.white,
            ),
          ),
          Text(
            "${widget.lang == "en" ? "all categories" : "كل الاقسام"}",
            style: TextStyle(fontSize: 14, color: mainColor),
          )
        ],
      ),
    ));

    for (int i = 0; i < widget.category.sub.length; i++) {
      tabsList.add(InkWell(
        onTap: () async {
          tabController.animateTo(i + 1);
          apiPage = 1;
          isbodyLoading = true;
          setState(() {});
          productsList.clear();
          selectedSubCategoryId = widget.category.sub[i].id;
          await getProductsBySubCategory(selectedSubCategoryId);
          isbodyLoading = false;
          setState(() {});
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage("${widget.category.sub[i].picpath}"),
            ),
            Text(
              "${widget.lang == "en" ? widget.category.sub[i].titleen : widget.category.sub[i].titlear}",
              style: TextStyle(fontSize: 14, color: mainColor),
            )
          ],
        ),
      ));
    }
  }

  getProductsBySubCategory(String id) async {
    productsList
        .addAll(await GetCategories().getSubCategoryProducts(id, apiPage));
  }
}
