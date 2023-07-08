import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'add_new_address.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'checkout.dart';

class MyAddressPage extends StatefulWidget {
  final route;
  const MyAddressPage({super.key, this.route});
  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  late BuildContext ctx;

  // dynamic useraddress ;
  List<dynamic> useraddress = [];
  List<dynamic> check = [];
  String? sUserid;
  String? usertoken, sUUID;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
      // sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getapi(apiname: 'get_shipping_address', type: 'get');
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
      widget.route == 1 ? STM().replacePage(ctx, CheckOut()) : STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
        // bottomNavigationBar: bottomBarLayout(ctx, 0),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              widget.route == 1 ? STM().replacePage(ctx, CheckOut()) : STM().finishAffinity(ctx, Home());
            },
            child: Icon(
              Icons.arrow_back,
              color: Clr().black,
            ),
          ),
          title: Text(
            'My Address',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Clr().white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dim().d20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    STM().replacePage(ctx, AddNewAddress());
                  },
                  child: Card(
                    color: Color(0xffECECEC).withOpacity(0.1),
                    borderOnForeground: true,
                    margin: EdgeInsets.only(top: Dim().d16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Clr().grey, width: 0.2),
                        borderRadius: BorderRadius.circular(Dim().d12)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d20, horizontal: Dim().d20),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/plus.svg"),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          Text(
                            "Add a new address",
                            style: TextStyle(
                              color: Color(0xff80C342),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: useraddress.length,
                  // itemCount: useraddress.length,
                  itemBuilder: (context, index) {
                    var v = useraddress[index];
                    return Column(
                      children: [
                        Card(
                          color: Color(0xffFBFBFB),
                          margin: EdgeInsets.only(top: Dim().d16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dim().d12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                       check.contains(v['name']) ? SvgPicture.asset('assets/myaddDot.svg') : InkWell(onTap: (){
                                         setState(() {
                                           check.clear();
                                           check.add(v['name']);
                                         });
                                         CheckOutpage.controller.sink.add({
                                           'id': v['id'],
                                           'address': '${v['address']} ${v['city']['name']} ${v['state']['name']} ${v['pincode']}'
                                         });
                                         STM().back2Previous(ctx);
                                       },child: SvgPicture.asset('assets/dotcircle.svg')),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Text('${v['name'].toString()}',
                                            style: Sty().mediumText.copyWith(fontWeight: FontWeight.w500,fontSize: 16, color: Color(0xff2D2D2D))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              STM().redirect2page(ctx, AddNewAddress(details: v,));
                                              // getUpdateAddress(id: useraddress[index]['id'].toString(),city_id:useraddress[index]['city_id'].toString() ,mobile:useraddress[index]['mobile'].toString() ,name:useraddress[index]['name'].toString() ,state_id:useraddress[index]['state_id'].toString() );
                                            },
                                            child: SvgPicture.asset(
                                                'assets/editadd.svg')),
                                        SizedBox(
                                          width: Dim().d20,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              getapi(
                                                  type: 'post',
                                                  apiname:
                                                      'delete_shipping_address',
                                                  value: [v['id']]);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: Dim().d16),
                                              child: SvgPicture.asset(
                                                  'assets/deleteadd.svg'),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 32.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${v['mobile'].toString()}',
                                          style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Color(0xff2D2D2D)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${v['address']}  ${v['city']['name']} ${v['state']['name']} ${v['pincode']}",
                                          style: Sty().mediumText.copyWith(
                                              height: 1.5,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color(0xff2D2D2D)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// api
  /// get TimeTableList
  void getapi({value, type, apiname}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    /// required key's of every api using their api name
    var data = FormData.fromMap({});
    switch (apiname) {
      case "delete_shipping_address":
        data = FormData.fromMap({
          'id': value[0],
        });
        break;
    }

    /// adding data to the dio body layout..
    FormData body = data;

    ///  response of get and post api in result using what type of api have...
    var result = type == 'get'
        ? await STM()
            .getWithTokenUrl(ctx, Str().loading, apiname, usertoken, 'customer')
        : await STM().postWithToken(
            ctx, Str().loading, apiname, body, usertoken, 'customer');
    var success = result['success'];

    /// get response in list using apiname (get_timetable , "get_classroom" is api)
    setState(() {
      switch (apiname) {
        case "get_shipping_address":
          if (success) {
            setState(() {
              useraddress = result['address'];
            });
          } else {
            STM().errorDialog(ctx, '${result['message'].toString()}');
          }
          break;
        case "delete_shipping_address":
          if (success) {
            STM().successDialogWithReplace(
                ctx, '${result['message'].toString()}', widget);
          } else {
            STM().errorDialog(ctx, '${result['message'].toString()}');
          }
          break;
      }
    });
  }
}
