import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'product_page.dart';
import 'your_cart.dart';

class Pharmacy extends StatefulWidget {
  @override
  State<Pharmacy> createState() => _PharmacyState();
}

class _PharmacyState extends State<Pharmacy> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Color(0xffd0d0d0),
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
                  mainAxisExtent: 210,
                  mainAxisSpacing: 1,
                ),
                shrinkWrap: true,
                itemCount: 16,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: (){
                            STM().redirect2page(ctx, ProductPage());
                          },
                          child: Image.asset('assets/myoders.png', height: 90, width: 120)),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Baidynath Kesari Kalp Royal Prash 500 g',
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            Row(
                              children: [
                                Text('₹400',
                                    style: Sty().mediumText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff2D2D2D))),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Text(' ₹ 700',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 40,
                                width: 120,
                                child: ElevatedButton(
                                    onPressed: () {
                                      STM().redirect2page(ctx, MyCart());
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
                                          color: Clr().primaryColor,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
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
              SizedBox(
                height: 1,
              ),
              SizedBox(
                height: Dim().d20,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
