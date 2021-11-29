import 'package:fbTrade/I10n/app_localizations.dart';
import 'package:fbTrade/global.dart';
import 'package:fbTrade/model/orders.dart';
import 'package:fbTrade/services/get_myOrders.dart';
import 'package:fbTrade/ui/pervious_order_details.dart';
import 'package:fbTrade/widgets/myOder_category_card.dart';
import 'package:flutter/material.dart';

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<OrdersModel> ordersModelList = List<OrdersModel>();
  bool isLoading = true;

  getMyOrders() async {
    ordersModelList = await GetMyOrders().getMyOrders();
    isLoading = false;
    setState(() {});
  }

  received(String id) async {
    isLoading = true;
    setState(() {});
    await GetMyOrders().orderRecieved(id: id);
    getMyOrders();
  }

  @override
  void initState() {
    super.initState();
    getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "${AppLocalizations.of(context).translate('myProducts')}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersModelList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PreviousOrderDetails(
                        ordersModelList[index].products,
                        ordersModelList[index].totalPrice),
                  )),
                  child: MyOrderCategoryCard(
                    isMyOrder: true,
                    extraWidget: ordersModelList[index].status == "delivered"
                        ? Container(
                            child: InkWell(
                              onTap: () {
                                received(ordersModelList[index].id);
                              },
                              child: Icon(Icons.check),
                            ),
                          )
                        : Container(),
                    title: ordersModelList[index].id,
                    date: ordersModelList[index].date,
                    photo: ordersModelList[index].photo,
                    status: ordersModelList[index].status,
                  ),
                );
              },
            ),
    );
  }
}
