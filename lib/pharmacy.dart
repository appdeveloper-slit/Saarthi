import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'home.dart';
import 'localstore.dart';
import 'product_page.dart';
import 'your_cart.dart';

class Pharmacy extends StatefulWidget {
  @override
  State<Pharmacy> createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  late BuildContext ctx;
  List<dynamic> pharmacyList = [];
  List<dynamic> filterList = [];
  bool isLoading = true;
  List<dynamic> addToCart = [];
  TextEditingController editingController = TextEditingController();

  Future<void> _updateItem(medicine_id, varientid, name, image, price,
      actualPrice, counter) async {
    await Store.updateItem(
        medicine_id,
        varientid,
        name,
        image,
        price,
        actualPrice,
        counter);
  }

  void _refreshData() async {
    dynamic data = await Store.getItems();
    setState(() {
      addToCart = data;
      print(addToCart);
      isLoading = false;
    });
  }

  Future<void> _addItem(medicine_id, varientid, name, image, price, actualPrice,
      counter) async {
    await Store.createItem(
        medicine_id,
        varientid,
        name,
        image,
        price,
        actualPrice,
        counter);
  }

  String? usertoken, sUUID;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var status = await OneSignal.shared.getDeviceState();
    usertoken = sp.getString('customerId') ?? '';
    setState(() {
      // sUserid = sp.getString('user_id');
      // sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getMedicine();
        _refreshData();
      }
    });
  }

  bool click = false;

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
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: bottomBarLayout(ctx, 0),
          backgroundColor: Clr().background1,
          appBar: AppBar(
            elevation: 2,
            leading: InkWell(
              onTap: () {
                STM().finishAffinity(ctx, Home());
              },
              child: Icon(
                Icons.arrow_back,
                color: Clr().black,
              ),
            ),
            title: click ? TextFormField(
              controller: editingController,
              keyboardType: TextInputType.text,
              onChanged: searchresult,
              style: Sty().mediumText.copyWith(color: Clr().black),
              decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                fillColor: Clr().white,
                filled: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(Dim().d14),
                  child: SvgPicture.asset(
                    'assets/images/search.svg',
                    color: const Color(0xff747474),
                    height: Dim().d16,
                  ),
                ),
                hintText: 'Search...',
                hintStyle:
                Sty().mediumText.copyWith(color: Color(0xff7F7A7A)),
              ),
            ) : Text(
              'Pharmacy',
              style: TextStyle(color: Clr().black, fontSize: 20),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        click = true;
                      });
                    },
                    child: SvgPicture.asset('assets/search.svg')),
              ),
              SizedBox(
                width: Dim().d20,
              ),
              InkWell(
                onTap: () {
                  // STM().redirect2page(context, NotificationPage());
                  STM().redirect2page(ctx, MyCart());
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: addToCart.length > 0 ? SvgPicture.asset(
                        'assets/AddCart.svg') : SvgPicture.asset(
                        'assets/my_cart.svg')),
              ),
            ],
            backgroundColor: Clr().white,
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: Dim().d20,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 270,
                    childAspectRatio: 3 / 5,
                    mainAxisSpacing: 4,
                  ),
                  shrinkWrap: true,
                  itemCount: pharmacyList.length,
                  itemBuilder: (context, index) =>
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(
                                ctx, ProductPage(details: pharmacyList[index]));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Clr().lightGrey),
                                  bottom: BorderSide(color: Clr().lightGrey),
                                  top: BorderSide(color: Clr().lightGrey),
                                )),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d12,
                                      vertical: Dim().d14),
                                  child: Container(
                                    height: Dim().d120,
                                    child: Image.network(
                                        '${pharmacyList[index]['image']
                                            .toString()}',
                                        width: double.infinity),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d12),
                                  child: Text(
                                      '${pharmacyList[index]['name']
                                          .toString()}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Dim().d16,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                                    child: Row(
                                      children: [
                                        Text(
                                            '₹${pharmacyList[index]['selling_price']}',
                                            style: Sty().mediumText.copyWith(
                                                fontSize: Dim().d14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff2D2D2D))),
                                        SizedBox(width: Dim().d12),
                                        Text(
                                            ' ₹${pharmacyList[index]['price']}',
                                            style: TextStyle(
                                              fontSize: Dim().d14,
                                              color: Colors.grey,
                                              decoration:
                                              TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w400,
                                              decorationThickness: 2,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d36,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _refreshData();
                                          addToCart
                                              .map((e) => e['medicine_id'])
                                              .contains(
                                              pharmacyList[index]['id'])
                                              ? Fluttertoast.showToast(
                                              msg:
                                              'Item is already added in cart',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER)
                                              : _addItem(
                                            pharmacyList[index]['id'],
                                            pharmacyList[index]['medicine_variant'][0]['id'],
                                              pharmacyList[index]['medicine_variant'][0]['variant_name']
                                                .toString(),
                                            pharmacyList[index]['image']
                                                .toString(),
                                            pharmacyList[index]['medicine_variant'][0]
                                            ['selling_price']
                                                .toString(),
                                            pharmacyList[index]['medicine_variant'][0]
                                            ['selling_price']
                                                .toString(),
                                            1,
                                          ).then((value) {
                                            _refreshData();
                                            Fluttertoast.showToast(
                                                msg: 'Item added to cart',
                                                toastLength:
                                                Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER);
                                          });
                                        });
                                        // STM().redirect2page(ctx, MyCart());
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          side: BorderSide(
                                              width: 2,
                                              color: Clr().primaryColor),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10))),
                                      child: Text(
                                        'Add to Cart',
                                        style: Sty().smallText.copyWith(
                                            fontSize: Dim().d14,
                                            color: Clr().primaryColor,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ),
                                SizedBox(
                                  height: Dim().d12,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          )),
    );
  }

  void searchresult(String value) {
    if (value.isEmpty) {
      setState(() {
        pharmacyList = filterList;
      });
    } else {
      setState(() {
        pharmacyList = filterList.where((element) {
          final resultTitle = element['name'].toLowerCase();
          final input = value.toLowerCase();
          return resultTitle.toString().toLowerCase().startsWith(input.toString().toLowerCase());
        }).toList();
      });
    }
  }

  /// api
  void getMedicine() async {
    var result = await STM().getWithTokenUrl(
        ctx, Str().loading, 'get_medicine', usertoken, 'customer');
    var success = result['success'];
    if (success) {
      setState(() {
        filterList = result['medicines'];
        pharmacyList = filterList;
      });
    }
  }
}
