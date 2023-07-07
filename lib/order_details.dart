import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'labs.dart';
import 'my_orders.dart';

class OrderDetails extends StatefulWidget {
  final order;

  const OrderDetails({super.key, this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late BuildContext ctx;
  String? usertoken;
  bool? check;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
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
    var totalprice;
    try {
      totalprice = double.parse(widget.order['final_amount']) +
          widget.order['delivery_charges'];
    } catch (_) {
      totalprice =
          widget.order['final_amount'] + widget.order['delivery_charges'];
    }
    ;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, MyOrders());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, MyOrders());
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
                        'Order ID - ${widget.order['order_no'].toString()}',
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
                        child: ListView.builder(
                            itemCount: widget.order['order_medicine'].length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var a = widget.order['order_medicine'][index];
                              var price;
                              try {
                                price = double.parse(a['medicine']
                                            ['selling_price']
                                        .toString()) *
                                    a['medicine']['quantity'];
                              } catch (_) {
                                price =
                                    a['medicine']['selling_price'].toString() *
                                        a['medicine']['quantity'];
                              }
                              ;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: Dim().d14),
                                    child: Row(
                                      children: [
                                        STM().imageDisplay(
                                            list: a['medicine']
                                                        ['medicine_images']
                                                    .isEmpty
                                                ? ''
                                                : a['medicine']
                                                        ['medicine_images'][0]
                                                    ['image'],
                                            url: a['medicine']
                                                        ['medicine_images']
                                                    .isEmpty
                                                ? ''
                                                : a['medicine']
                                                        ['medicine_images'][0]
                                                    ['image'],
                                            h: Dim().d40,
                                            w: Dim().d56),
                                        SizedBox(
                                          width: Dim().d8,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                              '${a['medicine']['name'].toString()}',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dim().d16,
                                                  color: Color(0xff3B3B3B))),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Expanded(
                                          child: Text(
                                              'x${a['medicine']['quantity']}',
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: Dim().d14,
                                                  color: Color(0xff3B3B3B))),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Text('₹${price}',
                                            style: Sty().mediumText.copyWith(
                                                fontWeight: FontWeight.w300,
                                                fontSize: Dim().d14,
                                                color: Color(0xff3B3B3B))),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      itemCount: widget
                                          .order['order_medicine'][index]
                                              ['medicine']['medicine_variant']
                                          .length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index2) {
                                        var b = widget.order['order_medicine']
                                                [index]['medicine']
                                            ['medicine_variant'][index2];
                                        var varientprice;
                                        try {
                                          varientprice = double.parse(
                                                  b['selling_price']
                                                      .toString()) *
                                              b['quantity'];
                                        } catch (_) {
                                          varientprice =
                                              b['selling_price'].toString() *
                                                  b['quantity'];
                                        }
                                        ;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: Dim().d14),
                                          child: Row(
                                            children: [
                                              STM().imageDisplay(
                                                  list: a['medicine'][
                                                              'medicine_images']
                                                          .isEmpty
                                                      ? ''
                                                      : a['medicine'][
                                                              'medicine_images']
                                                          [0]['image'],
                                                  url: a['medicine']['medicine_images']
                                                          .isEmpty
                                                      ? ''
                                                      : a['medicine']
                                                              ['medicine_images']
                                                          [0]['image'],
                                                  h: Dim().d40,
                                                  w: Dim().d56),
                                              SizedBox(
                                                width: Dim().d8,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                    '${b['variant_name'].toString()}',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: Dim().d16,
                                                            color: Color(
                                                                0xff3B3B3B))),
                                              ),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                              Expanded(
                                                child: Text('x${b['quantity']}',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: Dim().d14,
                                                            color: Color(
                                                                0xff3B3B3B))),
                                              ),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                              Text('₹${varientprice}',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: Dim().d14,
                                                          color: Color(
                                                              0xff3B3B3B))),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              );
                            }),
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
                          Text('${widget.order['shipping_address']['address']}',
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
                          Text('${widget.order['delivery_date']}',
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
                Padding(
                  padding: EdgeInsets.only(left: Dim().d16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                              '₹${widget.order['final_amount']}',
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
                            Text('₹ ${widget.order['discount']}'),
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
                            Text('₹${widget.order['delivery_charges']}'),
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
                              '₹ ${totalprice}',
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
                check == true
                    ? Container()
                    : widget.order['order_status'] == 'Cancelled'
                        ? Text('Order Cancelled',
                            style: Sty()
                                .mediumText
                                .copyWith(color: Clr().errorRed))
                        : SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () {
                                  OrderCancel(widget.order['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  'Cancel product',
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
      ),
    );
  }

  void OrderCancel(id) async {
    FormData body = FormData.fromMap({
      'order_id': id,
    });
    var result = await STM().postWithToken(
        ctx, Str().processing, 'cancel_order', body, usertoken, 'Customer');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        check = true;
      });
      AwesomeDialog(
              headerAnimationLoop: true,
              dismissOnTouchOutside: true,
              dismissOnBackKeyPress: true,
              title: 'Success',
              desc: message,
              btnOkText: "OK",
              dialogType: DialogType.success,
              context: context,
              btnOkOnPress: () {
                STM().back2Previous(context);
              },
              btnOkColor: Clr().successGreen)
          .show();
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
