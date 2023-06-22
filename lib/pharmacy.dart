import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'localstore.dart';
import 'product_page.dart';
import 'your_cart.dart';

class Pharmacy extends StatefulWidget {
  @override
  State<Pharmacy> createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  late BuildContext ctx;
  List<dynamic> pharmacyList = [
    {
      'id': 1,
      'image':'https://stylesatlife.com/wp-content/uploads/2017/03/Bromhexine.jpg',
      'name': 'Bohomexijn horide',
      'price':400,
      'actualprice':700,
    },
    {
      'id': 2,
      'image':'https://i0.wp.com/nimedhealth.com.ng/wp-content/uploads/2021/03/images-2021-03-12T174135.264.jpeg?fit=554%2C554&ssl=1',
      'name': 'Inhaled Corticosteroids',
      'price': 200,
      'actualprice':300,
    },
    {
      'id': 3,
      'image':'https://i0.wp.com/nimedhealth.com.ng/wp-content/uploads/2021/03/images-2021-03-12T174135.264.jpeg?fit=554%2C554&ssl=1',
      'name': 'Codeine Syrup for Cough Control',
      'price': 120,
      'actualprice':500,
    },
    {
      'id': 4,
      'image':'https://stylesatlife.com/wp-content/uploads/2017/03/Bromhexine.jpg',
      'name': 'Syrups and Tablets for Cough Dry or Wet',
      'price': 230,
      'actualprice': 600,
    }
  ];

  bool isLoading = true;
  List<dynamic> addToCart = [];

  Future<void> _updateItem(idd, name,  image, price, actualPrice, counter) async {
    await Store.updateItem(idd, name,  image, price, actualPrice, counter);
  }

  void _refreshData() async {
    dynamic data = await Store.getItems();
    setState(() {
      addToCart = data;
      print(addToCart);
      isLoading = false;
    });
  }

  Future<void> _addItem(idd, name, image, price, actualPrice, counter) async {
    await Store.createItem(idd, name, image, price, actualPrice, counter);
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
            'Pharmacy',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: InkWell(
                  onTap: () {
                    STM().redirect2page(context, Pharmacy());
                  },
                  child: SvgPicture.asset('assets/search.svg')),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                // STM().redirect2page(context, NotificationPage());
                STM().redirect2page(ctx, MyCart());
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SvgPicture.asset('assets/my_cart.svg')),
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
                  crossAxisSpacing: 1,
                  childAspectRatio: 3/4,
                  mainAxisSpacing: 1,
                ),
                shrinkWrap: true,
                itemCount: pharmacyList.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Clr().lightGrey),bottom: BorderSide(color: Clr().lightGrey),top: BorderSide(color: Clr().lightGrey),)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d12,vertical: Dim().d14),
                          child: InkWell(
                              onTap: (){
                                // STM().redirect2page(ctx, ProductPage());
                              },
                              child: Image.network( '${pharmacyList[index]['image'].toString()}', height: 90, width: 120)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                            child: Text('${pharmacyList[index]['name'].toString()}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Dim().d16,fontWeight: FontWeight.w300)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                            child: Row(
                              children: [
                                Text('₹${pharmacyList[index]['price']}',
                                    style: Sty().mediumText.copyWith(
                                        fontSize: Dim().d14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff2D2D2D))),
                                SizedBox(width: Dim().d12),
                                Text(' ₹${pharmacyList[index]['actualprice']}',
                                    style: TextStyle(
                                      fontSize:  Dim().d14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
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
                                  _addItem(
                                    pharmacyList[index]['id'],
                                    pharmacyList[index]['name'].toString(),
                                    pharmacyList[index]['image'].toString(),
                                    pharmacyList[index]['price'].toString(),
                                    pharmacyList[index]['price'].toString(),
                                    1,
                                  ).then((value) {
                                    _refreshData();
                                  });
                                });
                                // STM().redirect2page(ctx, MyCart());
                              },
                              style: ElevatedButton.styleFrom( elevation: 0,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                      width: 1,
                                      color: Clr().primaryColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10))),
                              child: Text(
                                'Add to Cart',
                                style: Sty().smallText.copyWith(
                                    fontSize: Dim().d14,
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w400),
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
            ],
          ),
        ));
  }
}
