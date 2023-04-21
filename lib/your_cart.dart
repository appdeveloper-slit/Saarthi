import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'checkout.dart';

class MyCart extends StatefulWidget {
  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late BuildContext ctx;
  int selectedTab = 0;
  List<String> imageList = ['assets/home.png'];
  List<dynamic> resultList = [];

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,
      // bottomNavigationBar: bottomBarLayout(ctx, 0),
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
          'Your Cart',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              padding: EdgeInsets.all(Dim().d16),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      child: Card(
                        color: Clr().background,
                        margin: EdgeInsets.only(top:Dim().d12),
                        elevation: 3,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.asset('assets/myoders.png',height: 90,width: 110),
                              SizedBox(
                                width:Dim().d12,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child:  SvgPicture.asset('assets/delete.svg',height: 15,width: 15,),),
                                      Text('Dolo 650 mg 15 Tablets',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d8,
                                      ),

                                      Text('₹ 28.98',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_minus.svg',height: 20,width: 20,),
                                          ),
                                          Text('1'),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_plus.svg',height: 20,width: 20,),
                                          ),
                                        ],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      child: Card(
                        color: Clr().background,
                        margin: EdgeInsets.only(top:Dim().d12),
                        elevation: 3,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.asset('assets/myoders2.png',height: 90,width: 110),
                              SizedBox(
                                width:Dim().d12,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child:  SvgPicture.asset('assets/delete.svg',height: 15,width: 15,),),
                                      Text('Dolo 650 mg 15 Tablets',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d8,
                                      ),

                                      Text('₹ 28.98',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_minus.svg',height: 20,width: 20,),
                                          ),
                                          Text('1'),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_plus.svg',height: 20,width: 20,),
                                          ),
                                        ],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      child: Card(
                        color: Clr().background,
                        margin: EdgeInsets.only(top:Dim().d12),
                        elevation: 3,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dim().d12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.asset('assets/myoders3.png',height: 90,width: 110),
                              SizedBox(
                                width:Dim().d12,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child:  SvgPicture.asset('assets/delete.svg',height: 15,width: 15,),),
                                      Text('Dolo 650 mg 15 Tablets',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d8,
                                      ),

                                      Text('₹ 28.98',overflow: TextOverflow.ellipsis,maxLines: 2,
                                          style:
                                          Sty().mediumText.copyWith(
                                              fontWeight:
                                              FontWeight.w600,
                                              color: Color(0xff2D2D2D)
                                          )),

                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_minus.svg',height: 20,width: 20,),
                                          ),
                                          Text('1'),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset('assets/yourcart_plus.svg',height: 20,width: 20,),
                                          ),
                                        ],
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


                  ],
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32,vertical: 8),

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total (4 items) :',
                        style: Sty().largeText.copyWith(
                            fontWeight:
                            FontWeight.w600,fontSize: 17),),
                      Text('₹250',
                        style: Sty().largeText,),

                    ],
                  ),
                ),
                SizedBox(height: 20,width: 60,),
                SizedBox(
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
                        'Proceed to checkout',
                        style: Sty().mediumText.copyWith(
                          color: Clr().white,
                          fontWeight: FontWeight.w600,),
                      )),
                ),
                SizedBox(height: 20,),

              ],
            ),
          ),
        ],
      ),
    );

  }
}
