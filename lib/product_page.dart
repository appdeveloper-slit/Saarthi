import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saarathi/checkout.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'localstore.dart';
import 'your_cart.dart';

class ProductPage extends StatefulWidget {
  final details;

  const ProductPage({super.key, this.details});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late BuildContext ctx;

  // List<dynamic> sliderList = [];
  CarouselController sliderCtrl = CarouselController();
  TextEditingController pincodeCtrl = TextEditingController();

  // List<dynamic> sliderList = ['assets/mybooking.png'];
  List<String> sliderList = [];
  int selectedSlider = 0;
  String AppointmentValue = 'Online Appointment';
  List<String> AppointmentList = [
    'Online Appointment',
    'Home Visit',
  ];
  var success;
  List<dynamic> addToCart = [];
  bool isLoading = true;
  String sTotalPrice = "0";
  String? sUserid;
  String message = '';
  String message1 = '';

  Future<void> _updateItem(
      idd, name, image, price, actualPrice, counter) async {
    await Store.updateItem(idd, name, image, price, actualPrice, counter);
  }

  void _refreshData() async {
    var data = await Store.getItems();
    setState(() {
      addToCart = data;
      isLoading = false;
    });
  }

  String? usertoken;

  Future<void> _addItem(idd, name, image, price, actualPrice, counter) async {
    await Store.createItem(idd, name, image, price, actualPrice, counter);
  }

  var v;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var status = await OneSignal.shared.getDeviceState();
    //
    setState(() {
      // sUserid = sp.getString('user_id');
      // sUUID = status?.userId;
      usertoken = sp.getString('customerId') ?? '';
      v = widget.details;
      sliderList.add(v['image']);
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        _refreshData();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    int position = addToCart.indexWhere((element) => element['idd'] == v['id']);
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Clr().appbarTextColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          '${v['name'].toString()}',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: Dim().d12,
                  ),
                  CarouselSlider(
                    carouselController: sliderCtrl,
                    options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            selectedSlider = index;
                          });
                        }),
                    items: sliderList
                        .map((e) => ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.loose,
                                children: <Widget>[
                                  Image.network(
                                    e,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: Dim().d8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sliderList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          width: Dim().d8,
                          height: Dim().d8,
                          margin: EdgeInsets.only(
                            right: Dim().d8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedSlider == index
                                ? Clr().primaryColor
                                : Color(0xffB3B3B3),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Text(
                    '${v['name'].toString()}',
                    style:
                        Sty().mediumText.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                if (v['is_variant'] == 1)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    child: Center(
                      child: SizedBox(
                          height: Dim().d44,
                          child: ListView.builder(
                              itemCount: v['medicine_variant'].length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var pack = v['medicine_variant'][index];
                                return Padding(
                                  padding: EdgeInsets.only(right: Dim().d12,),
                                  child: SizedBox(
                                    width: Dim().d220,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {

                                          });
                                        },
                                        child: Text(
                                          '${pack['variant_name']}',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15, color: Color(0xffA6A6A6)),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                                width: 1, color: Color(0xffA6A6A6)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)))),
                                  ),
                                );
                              })),
                    ),
                  ),
                if (v['is_variant'] == 1)
                  SizedBox(
                    height: Dim().d8,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Inclusive of all taxes',
                                    style: TextStyle(
                                      fontSize: Dim().d14,
                                      color: Colors.grey,
                                    )),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '₹ ${v['selling_price'].toString()}',
                                        style: Sty().mediumText.copyWith(
                                            fontSize: Dim().d14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(' ₹ ${v['price'].toString()}',
                                          style: TextStyle(
                                            fontSize: Dim().d14,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2,
                                          )),
                                    ),
                                    Text(
                                      '15%OFF',
                                      style: Sty().mediumText.copyWith(
                                          fontSize: Dim().d14,
                                          color: Clr().red),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        width: Dim().d8,
                      ),
                      addToCart.map((e) => e['idd']).contains(v['id'])
                          ? SizedBox(
                              width: Dim().d76,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: SvgPicture.asset(
                                      'assets/yourcart_minus.svg',
                                      height: 20,
                                      width: 20,
                                    ),
                                    onTap: () {
                                      removeItem(position);
                                    },
                                  ),
                                  Text(
                                      '${addToCart[position]['counter'].toString()}'),
                                  InkWell(
                                    child: SvgPicture.asset(
                                      'assets/yourcart_plus.svg',
                                      height: 20,
                                      width: 20,
                                    ),
                                    onTap: () {
                                      addItem(position);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: Dim().d44,
                              child: ElevatedButton(
                                  onPressed: () {
                                    // STM().redirect2page(ctx, MyCart());
                                    _refreshData();
                                    _addItem(
                                      v['id'],
                                      v['name'].toString(),
                                      v['image'].toString(),
                                      v['selling_price'].toString(),
                                      v['selling_price'].toString(),
                                      1,
                                    ).then((value) {
                                      _refreshData();
                                      Fluttertoast.showToast(
                                          msg: 'Item added to cart',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: Sty().smallText.copyWith(
                                        fontSize: Dim().d14,
                                        color: Clr().white,
                                        fontWeight: FontWeight.w400),
                                  )),
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Clr().borderColor)),
                    // shape: Border.all(
                    //     color: Colors.black12),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Dim().d16,
                          bottom: Dim().d16,
                          left: Dim().d8,
                          right: Dim().d8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Dim().d4),
                            child: Text(
                              'Check Delivery Availability',
                              style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: pincodeCtrl,
                            keyboardType: TextInputType.name,
                            maxLength: 6,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              fillColor: Clr().white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Clr().primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              hintText: "Enter Pincode Here",
                              suffixIcon: InkWell(
                                onTap: () {
                                  pincodeCtrl.text.isEmpty
                                      ? Fluttertoast.showToast(
                                          msg: 'Enter the pincode',
                                          gravity: ToastGravity.CENTER)
                                      : checkAvailbility();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Check',
                                      style: TextStyle(
                                          fontSize: Dim().d14,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              hintStyle: Sty().mediumText.copyWith(
                                  color: Clr().shimmerColor,
                                  fontSize: Dim().d12),
                              counterText: "",
                            ),
                          ),
                          if (message.isNotEmpty)
                            SizedBox(
                              height: Dim().d12,
                            ),
                          if (message.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(left: Dim().d4),
                              child: Text(
                                '${message}',
                                style: Sty().smallText.copyWith(
                                    fontSize: 12,
                                    color: success == false
                                        ? Clr().errorRed
                                        : Clr().primaryColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d12,
            ),
            v['description'] == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dim().d8, horizontal: Dim().d16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Text(
                          '${v['description'].toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(offset: Offset(0, 0), color: Colors.black)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: Dim().d32,
            ),
            addToCart.map((e) => e['idd']).contains(v['id'])
                ? Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Clr().grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 12,
                            offset:
                                Offset(12, 0.5), // changes position of shadow
                          ),
                        ],
                        color: Clr().primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d24, vertical: Dim().d16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹ ${addToCart.isEmpty ? 00 : addToCart[position]['price']}',
                            style: Sty().mediumText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Clr().white),
                          ),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                                onPressed: () {
                                  STM().redirect2page(ctx, MyCart());
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Clr().white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Text(
                                  'Continue',
                                  style: Sty().smallText.copyWith(
                                      color: Clr().primaryColor,
                                      fontWeight: FontWeight.w600),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  displayToast() {
    Fluttertoast.showToast(
        msg: 'Add this product on cart', gravity: ToastGravity.CENTER);
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

  // getcheck
  void checkAvailbility() async {
    FormData body = FormData.fromMap({
      'pincode': pincodeCtrl.text,
    });
    var result = await STM().postWithToken(ctx, Str().processing,
        'check_availability', body, usertoken, 'customer');
    success = result['success'];
    if (success) {
      setState(() {
        message = result['message'];
      });
    } else {
      setState(() {
        message = result['message'];
        pincodeCtrl.clear();
      });
    }
  }
}
