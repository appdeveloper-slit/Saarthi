import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'checkout.dart';
import 'localstore.dart';

class MyCart extends StatefulWidget {
  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late BuildContext ctx;
  List<dynamic> addToCart = [];
  bool isLoading = true;
  String sTotalPrice = "0";

  String? sUserid;

  Future<void> _updateItem(
      idd, name, image, price, actualPrice, counter) async {
    await Store.updateItem(idd, name, image, price, actualPrice, counter);
  }

  void _refreshData() async {
    var data = await Store.getItems();
    var price = await Store.getTotalPrice();
    setState(() {
      addToCart = data;
      isLoading = false;
      sTotalPrice = price;
    });
  }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var status = await OneSignal.shared.getDeviceState();
    setState(() {
      // sUserid = sp.getString('user_id');
      // sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        // getHome();
        _refreshData();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,
      // bottomNavigationBar: bottomBarLayout(ctx, 0),
      appBar: AppBar(
        elevation: 2,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),
        ),
        title: Text(
          'Your Cart',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: addToCart.length,
              padding: EdgeInsets.all(Dim().d16),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Card(
                        color: Clr().background,
                        margin: EdgeInsets.only(top: Dim().d12),
                        elevation: 3,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.network(
                                  '${addToCart[index]['image'].toString()}',
                                  height: 90,
                                  width: 110),
                              SizedBox(
                                width: Dim().d12,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/delete.svg',
                                          height: 15,
                                          width: 15,
                                        )),
                                    onTap: () {
                                      setState(() {
                                        Store.deleteItem(
                                          addToCart[index]['idd'],
                                        );
                                        _refreshData();
                                      });
                                    },
                                  ),
                                  Text('${addToCart[index]['name'].toString()}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff2D2D2D))),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text(
                                      '₹ ${addToCart[index]['price'].toString()}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Sty().mediumText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff2D2D2D))),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            'assets/yourcart_minus.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        onTap: () {
                                          removeItem(index);
                                        },
                                      ),
                                      Text(
                                          '${addToCart[index]['counter'].toString()}'),
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            'assets/yourcart_plus.svg',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        onTap: () {
                                          addItem(index);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total (${addToCart.length} items) :',
                        style: Sty().largeText.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                      Text(
                        '₹${sTotalPrice}',
                        style: Sty().largeText,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 60,
                ),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        // STM().redirect2page(ctx, CheckOut());
                        // if (formKey.currentState!
                        //     .validate()) {
                        //   STM()
                        //       .checkInternet(
                        //       context, widget)
                        //       .then((value) {
                        //     if (value) {
                        //       sendOtp();
                        //     }
                        //   });
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Proceed to checkout',
                        style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w600,
                            ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // remove item
  removeItem(index) {
    int counter = addToCart[index]['counter'];
    var acutal = int.parse(addToCart[index]['actualPrice'].toString());
    var price = int.parse(addToCart[index]['price'].toString());
    counter--;
    var newPrice = price - acutal;
    if (counter > 0) {
      _updateItem(
              addToCart[index]['idd'],
              addToCart[index]['name'].toString(),
              addToCart[index]['image'].toString(),
              newPrice.toString(),
              addToCart[index]['actualPrice'].toString(),
              counter)
          .then((value) {
        newPrice = 0;
        counter = 0;
        _refreshData();
      });
    }
  }

  // add item
  addItem(index) {
    int counter = addToCart[index]['counter'];
    var acutal = int.parse(addToCart[index]['actualPrice'].toString());
    var price = int.parse(addToCart[index]['price'].toString());
    counter++;
    var newPrice = price + acutal;
    _updateItem(
            addToCart[index]['idd'],
            addToCart[index]['name'].toString(),
            addToCart[index]['image'].toString(),
            newPrice.toString(),
            addToCart[index]['actualPrice'].toString(),
            counter)
        .then((value) {
      newPrice = 0;
      counter = 0;
      _refreshData();
    });
  }
}
