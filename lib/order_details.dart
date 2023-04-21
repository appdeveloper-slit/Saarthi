import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'labs.dart';

class OrderDetails extends StatefulWidget {
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(

      backgroundColor: Clr().white,

      bottomNavigationBar: bottomBarLayout(ctx, 0),
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
          'Order Details',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dim().d16),
                    child: Text(
                      'Order ID - OD6849684984',
                      style: Sty().largeText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff747688)
                          // fontFamily: Outfit
                          ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    thickness: 1.5,
                  ),
                  Card(
                    margin: EdgeInsets.only(top: Dim().d16),
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 32,
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dolo 650 mg 15 Tablets',
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xff3B3B3B))),
                                SizedBox(
                                  height: 12,
                                ),
                                Text('₹ 30',
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xff3B3B3B))),
                              ],
                            ),
                          )),
                          Image.asset(
                            'assets/myoders.png',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dim().d16),
                    child: Text('Delivery Details',
                        style: Sty().mediumText.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff3B3B3B))),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    height: 2,
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d32, vertical: Dim().d12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address',
                            style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xff3B3B3B))),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipi elit. Condimentum vestibulum donec qua.',
                            style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xff3B3B3B))),
                        SizedBox(
                          height: 12,
                        ),
                        Text('Delivery Date',
                            style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xff3B3B3B))),
                        SizedBox(
                          height: 6,
                        ),
                        Text('22/02/22',
                            style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff3B3B3B))),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1.5,
                        color: Color(0xffECECEC),
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/orderdetails.svg',
                                height: 25,
                                width: 25,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Text(
                              'Invoice download',
                              style: TextStyle(
                                  color: Color(0xff3B3B3B),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 20),
                      ],
                    ),
                  ),
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'BIGsaver20',
                  //       style: TextStyle(color: Color(0xff989797)),
                  //     ),
                  //     Icon(Icons.arrow_forward_ios_outlined,size: 20),
                  //   ],
                  // ),
                ),
              ),
              SizedBox(
                height: Dim().d24,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: Dim().d8),
                              child: Text(
                                'Shipping Details',
                                style: Sty().largeText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      // fontFamily: Outfit
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dim().d8),
                          Divider(
                            height: 2,
                            thickness: 1.5,
                          ),
                          SizedBox(height: Dim().d8),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Dim().d20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Aniket Mahakal',
                                    style: Sty().largeText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          // fontFamily: Outfit
                                        ),
                                  ),
                                ),
                                Text(
                                  'Vasant Lawns, DP Road, Opp. TCS,\n Subhash Nagar, Thane West,\n Thane, Maharashtra 400606',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: Dim().d2,
                                ),
                                Text(
                                  'Phone number: 25641387945',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
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
              Divider(
                height: 2,
                thickness: 1.5,
              ),
              SizedBox(height: Dim().d8),
              Padding(
                padding: EdgeInsets.only(left: Dim().d16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Deatails',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: Dim().d12),
              Divider(
                height: 2,
                thickness: 1.5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dim().d28, vertical: Dim().d16),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '₹1000',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text('₹ 0'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Charges',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text('₹ 0'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      height: 2,
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Sty().largeText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '₹ 1000',
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
              Divider(
                height: 2,
                thickness: 1.5,
              ),
              SizedBox(
                height: Dim().d32,
              ),
              SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      STM().redirect2page(ctx, Labs());
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
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Return product',
                      style: Sty().mediumText.copyWith(
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
              SizedBox(
                height: Dim().d32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
