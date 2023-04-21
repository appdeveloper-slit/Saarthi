import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'add_new_address.dart';
import 'bottom_navigation/bottom_navigation.dart';

class MyAddressPage extends StatefulWidget {
  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  late BuildContext ctx;

  // dynamic useraddress ;
  List<dynamic> useraddress = [];


  String? sUserid;



  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,

      // bottomNavigationBar: bottomBarLayout(ctx, 0),
      appBar:AppBar(
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom( elevation: 0,

                      backgroundColor: Color(0xffFBFBFB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  // Text Color (Foreground color)
                  onPressed: () {
                    STM().redirect2page(ctx, AddNewAddress());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Dim().d20,),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/plus.svg"),
                        SizedBox(width: Dim().d12,),
                        Text(
                          "Add a new address", style: TextStyle(
                          color: Color(0xff80C342), fontSize: 16,
                        ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: Dim().d8,),


              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                // itemCount: useraddress.length,
                itemBuilder: (context, index) {
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [


                              Row(

                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/myaddDot.svg'),
                                      SizedBox(width: Dim().d12,),
                                      Text(
                                          // '${useraddress[index]['name']
                                          //     .toString()}',

                                          'Aniket Mahakal',
                                          style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xff2D2D2D))),
                                    ],
                                  ),


                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // STM().redirect2page(ctx, AddNewAddress(sType: 'updateAddress',id: useraddress[index]['id'].toString(),));
                                          // getUpdateAddress(id: useraddress[index]['id'].toString(),city_id:useraddress[index]['city_id'].toString() ,mobile:useraddress[index]['mobile'].toString() ,name:useraddress[index]['name'].toString() ,state_id:useraddress[index]['state_id'].toString() );
                                        },
                                          child: SvgPicture.asset('assets/editadd.svg')),
                                      SizedBox(width: Dim().d20,),
                                      InkWell(
                                          onTap: () {
                                            // getDeleteAddress(
                                            //     id: useraddress[index]['id']
                                            //         .toString());
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: Dim().d16),
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
                                        // '+91 ${useraddress[index]['mobile']
                                        //     .toString()}',
                                        '+91 9632587412',
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
                                        "Vasant Lawns, DP Road, Opp. TCS, Subhash Nagar, Thane West, Thane, Maharashtra 400606",
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
    );
  }


}

