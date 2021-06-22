import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
 
import '../providers/inappbilling.dart';
 
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
 
  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.verifyPurchase();
    super.initState();
  }
 
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
 
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderModel>(context);
 
    return Scaffold(
      appBar: AppBar(
        title: Text("In App Purchase"),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !provider.isPurchased
                  ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           Text(
                            provider.available
                                ? "Store is Available"
                                : "Store is not Available",
                            style: TextStyle(fontSize: 22, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ):SizedBox.shrink(),
              provider.isPurchased
                  ? Center(child: Text("Premium Plan"))
                  : Center(
                    child: Text(
                        "Get Premium Plan Subscription",
                        style: TextStyle(
                            fontSize: 18, backgroundColor: Colors.greenAccent),
                      ),
                  ),
              for (var prod in provider.products)
                if (provider.hasPurchased(prod.id) != null) ...[
                  Center(
                    child: FittedBox(
                      child: Text(
                        'THANK YOU!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 60, color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                  ),
                ] else ...[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Unlock All Features Subscription: ${prod.price} per month",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        FlatButton(
                          onPressed: () => _buyProduct(prod),
                          child: Text('Pay'),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ]
            ],
          ),
        ),
      ),
    );
  }
}