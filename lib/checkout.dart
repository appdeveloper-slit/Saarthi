import 'package:flutter/material.dart';
import 'package:saarathi/coupons.dart';
import 'package:saarathi/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'localstore.dart';
import 'my_address.dart';

class CheckOut extends StatefulWidget {
  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  late BuildContext ctx;
  bool isChecked = false;
  String?  sPayment;
  List<dynamic> paymentList = ["Online Payment",];

  List<dynamic> addToCart = [];
  bool isLoading = true;
  String sTotalPrice = "0";
  String? sUserid;
  bool click = false;

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

      appBar:  AppBar(
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
          'Checkout',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              Card(
                elevation: 1,
                color: Color(0xFFFBFBFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product',
                        style: Sty().largeText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          // fontFamily: Outfit
                        ),
                      ),
                      SizedBox(
                        height: Dim().d16,
                      ),
                      ListView.builder(itemCount: addToCart.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16,vertical: Dim().d12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(flex:4,
                                child: Text('${addToCart[index]['name'].toString()}',
                                    style: TextStyle(
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w300)),
                              ),
                              Expanded(flex:1,
                                child: Text(
                                  'x${addToCart[index]['counter'].toString()}',
                                  style: TextStyle(
                                      fontSize: Dim().d12, fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                '₹ ${addToCart[index]['price']}',
                                style: TextStyle(
                                    fontSize: Dim().d14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, MyAddressPage());
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
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10))),
                    child: Text(
                      'Select delivery address',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration:  BoxDecoration(

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 0), // changes position of shadow

                            ),
                          ],
                        ),

                        child: TextFormField(

                          // controller: mobileCtrl,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,borderRadius: BorderRadius.circular(5)
                            ),


                            fillColor: Clr().white,

                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Clr().primaryColor, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            // label: Text('Enter Your Number'),

                            hintText: "Enter coupon code",
                            hintStyle: Sty()
                                .mediumText
                                .copyWith(color: Clr().shimmerColor, fontSize: 14),
                            counterText: "",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 46,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            // STM().redirect2page(ctx, AddNewPatient());
                          },
                          style: ElevatedButton.styleFrom( elevation: 0,
                            backgroundColor: Clr().primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            'APPLY',
                            style: Sty().smallText.copyWith(
                                color: Clr().white, fontWeight: FontWeight.w600),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: InkWell(
                  onTap: (){
                    STM().redirect2page(ctx, Coupons());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'View all coupons',
                      style: Sty()
                          .smallText
                          .copyWith(fontSize: 12, color: Clr().primaryColor),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 1,
                color: Color(0xFFFBFBFB),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Price Summary',
                              style: Sty().largeText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                // fontFamily: Outfit
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '₹ ${sTotalPrice}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '₹ 0',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charges',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  '₹ 0',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 2,
                      thickness: 1.5,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: Dim().d2,bottom: Dim().d16,left:Dim().d16,right: Dim().d16 ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Sty().largeText.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '₹ ${sTotalPrice}',
                                  style: Sty().largeText.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                elevation: 1,
                color: Color(0xFFFBFBFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12, vertical: Dim().d12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Payment Options',
                          style: Sty().largeText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'outfit'
                            // fontFamily: Outfit
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        color: Clr().white,
                        child: Column(
                          children: [
                            // RadioListTile<dynamic>(
                            //   dense: true,
                            //
                            //   contentPadding: EdgeInsets.zero,
                            //   activeColor: Clr().primaryColor,
                            //   value: "Cash on Delivery",
                            //   groupValue: sPayment,
                            //
                            //   onChanged: (value) {
                            //     setState(() {
                            //       sPayment = value!;
                            //     });
                            //   },
                            //   title: Transform.translate(
                            //     offset: Offset(-18,3),
                            //     child: Text(
                            //       paymentList[0],
                            //       style: Sty().mediumText,
                            //     ),
                            //   ),
                            // ),
                            RadioListTile<dynamic>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              activeColor: Clr().primaryColor,
                              value: "Online Payment",
                              groupValue: sPayment,
                              onChanged: (value) {
                                setState(() {
                                  sPayment = value!;
                                  click = true;
                                });
                              },
                              title: Transform.translate(
                                offset: Offset(-18,3),
                                child: Text(
                                  paymentList[0],
                                  style: Sty().mediumText.copyWith(
                                    fontFamily: 'outfit',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),
              click ?  SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, CheckOut());
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
                    style: ElevatedButton.styleFrom( elevation: 0,
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10))),
                    child: Text(
                      'Place Order',
                      style: Sty().mediumText.copyWith(
                        color: Clr().white,
                        fontWeight: FontWeight.w600,),
                    )),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
