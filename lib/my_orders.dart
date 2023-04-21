import 'package:flutter/material.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'order_details.dart';

class MyOrders extends StatefulWidget {
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 3),
        backgroundColor: Clr().white,
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
            'My Orders',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ListView.builder(
                itemCount: 2,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(context, OrderDetails());
                          },
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
                                  Image.asset('assets/myoders.png',
                                      height: 70, width: 110),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Order :',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                          SizedBox(
                                            width: Dim().d2,
                                          ),
                                          Text(' #1234',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Text('20-Dec-2022,',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('03:00 Pm',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Total :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('₹30',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Status :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d8,
                                          ),
                                          Text('Pending',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Color(0xffFFC107))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(context, OrderDetails());
                          },
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
                                  Image.asset('assets/myoders2.png',
                                      height: 70, width: 110),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Order :',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                          SizedBox(
                                            width: Dim().d2,
                                          ),
                                          Text(' #1234',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Text('20-Dec-2022,',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('03:00 Pm',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Total :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('₹30',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Status :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d8,
                                          ),
                                          Text('Completed',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Color(0xff80C342))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(context, OrderDetails());
                          },
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
                                  Image.asset('assets/myoders3.png',
                                      height: 70, width: 110),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Order :',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                          SizedBox(
                                            width: Dim().d2,
                                          ),
                                          Text(' #1234',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff2D2D2D))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Text('20-Dec-2022,',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('03:00 Pm',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Total :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d4,
                                          ),
                                          Text('₹30',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Row(
                                        children: [
                                          Text('Order Status :',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(
                                            width: Dim().d8,
                                          ),
                                          Text('Cancelled',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Color(0xffC20909))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
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
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
