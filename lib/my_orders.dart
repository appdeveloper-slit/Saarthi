import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'my_booking.dart';
import 'order_details.dart';

class MyOrders extends StatefulWidget {
  final index;

  const MyOrders({super.key, this.index});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late BuildContext ctx;
  List myOrderList = [];
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getMyOrders();
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().directionRoute(widget.index, ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 3),
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 2,
          leading: InkWell(
            onTap: () {
              STM().directionRoute(widget.index, ctx);
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
                itemCount: myOrderList.length,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: InkWell(
                      onTap: () {
                        STM().redirect2page(
                            context,
                            OrderDetails(
                              order: myOrderList[index],
                            ));
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
                              STM().imageDisplay(
                                  list: myOrderList[index]['cover_image']
                                          .isEmpty
                                      ? ''
                                      : myOrderList[index]['cover_image'],
                                  url: myOrderList[index]['cover_image']
                                          .isEmpty
                                      ? ''
                                      : myOrderList[index]['cover_image'],
                                  h: Dim().d120,
                                  w: Dim().d100),
                              SizedBox(
                                width: Dim().d12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text('Order :',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff2D2D2D))),
                                        SizedBox(
                                          width: Dim().d2,
                                        ),
                                        Text(
                                            '${myOrderList[index]['order_no']}',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff2D2D2D)),
                                            maxLines: 2),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                            '${DateFormat('dd-MM-yyyy').format(DateTime.parse(myOrderList[index]['transaction_date'].toString()))}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                        SizedBox(
                                          width: Dim().d4,
                                        ),
                                        Text(
                                            '${DateFormat.jm().format(DateTime.parse(myOrderList[index]['transaction_date'].toString()))}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text('Order Total :',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(
                                          width: Dim().d4,
                                        ),
                                        Text(
                                            '₹${myOrderList[index]['final_amount']}',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text('Order Status :',
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(
                                          width: Dim().d8,
                                        ),
                                        Text(
                                            '${myOrderList[index]['order_status']}',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: myOrderList[index]
                                                            ['order_status'] ==
                                                        'Pending'
                                                    ? Color(0xffFFC107)
                                                    : myOrderList[index][
                                                                'order_status'] ==
                                                            'Completed'
                                                        ? Clr().green
                                                        : Clr().errorRed)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// myorders
  void getMyOrders() async {
    var result =
        await STM().getWithToken(ctx, Str().loading, 'my_order', usertoken);
    var success = result['success'];
    if (success) {
      setState(() {
        myOrderList = result['orders'];
      });
    }
  }
}
