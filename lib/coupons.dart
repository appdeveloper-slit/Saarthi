import 'package:flutter/material.dart';

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
                physics: NeverScrollableScrollPhysics(  ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    color: Clr().white,
                    elevation: 0.5,
                    margin: EdgeInsets.symmetric(horizontal: Dim().d0, vertical: Dim().d8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dim().d12),side: BorderSide(
                        color: Color(0xffECECEC)
                    )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                side: BorderSide(color: Color(0xff161616))),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [


                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('#SONIBOR12365',
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
                            height: 12,
                          ),
                          Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum nibh duis Lorem ',
                            style: TextStyle(
                                color: Clr().black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400

                            ),),


                        ],
                      ),
                    ),
                  );

                },
              )
            ],
          ),

        ),
      );
  }
}
