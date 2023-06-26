import 'package:flutter/material.dart';
import 'package:saarathi/checkout.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import 'bottom_navigation/bottom_navigation.dart';

class Coupons extends StatefulWidget {
  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  late BuildContext ctx;
  List<dynamic> coupanList = [];
  String? usertoken;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var status = await OneSignal.shared.getDeviceState();
    setState(() {
      // sUserid = sp.getString('user_id');
      usertoken = sp.getString('customerId') ?? '';
      // sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCoupans();
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
    return WillPopScope(
      onWillPop: () async {
        STM().replacePage(ctx, CheckOut());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        appBar: AppBar(
          elevation: 2,
          leading: InkWell(
            onTap: () {
              STM().replacePage(ctx, CheckOut());
            },
            child: Icon(
              Icons.arrow_back,
              color: Clr().black,
            ),
          ),
          title: Text(
            'Coupons',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: coupanList.length,
                itemBuilder: (context, index) {
                  return InkWell(onTap: (){
                    CheckOutpage.controller1.sink.add({
                      'name': coupanList[index]['coupon_code'].toString(),
                      'discount': coupanList[index]['discount'].toString(),
                    });
                    STM().back2Previous(ctx);
                  },
                    child: Card(
                      color: Clr().white,
                      elevation: 0.5,
                      margin: EdgeInsets.symmetric(
                          horizontal: Dim().d0, vertical: Dim().d8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dim().d12),
                          side: BorderSide(color: Color(0xffECECEC))),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(color: Color(0xff161616))),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text('${coupanList[index]['coupon_code']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Text(
                              '${coupanList[index]['description']}',
                              style: TextStyle(
                                  color: Clr().black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// getCoupans
  void getCoupans() async {
    var result =
        await STM().getWithToken(ctx, Str().loading, 'get_coupon', usertoken);
    var success = result['success'];
    if (success) {
      setState(() {
        coupanList = result['coupons'];
      });
    } else {
      STM().errorDialog(ctx, '${result['message']}');
    }
  }
}
