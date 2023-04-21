import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';


class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0),
      backgroundColor: Clr().white,

      appBar: AppBar(
          elevation: 2,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Clr().black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Notification',
          style: Sty().largeText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(  ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.0,
                    margin: EdgeInsets.symmetric(horizontal: Dim().d0, vertical: Dim().d8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dim().d12),side: BorderSide(
                        color: Color(0xffECECEC)
                    )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 12, left: 20,right: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Lorem Ipsum is simply dummy text ',
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w500,fontSize: 18
                              ),
                            ),
                          ),

                          SizedBox(
                            height: Dim().d8,
                          ),
                          Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. At amet, id lorem placerat neque morbi. Gravida integer lectus tristique ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff747688),

                            ),),
                          SizedBox(height: 16,),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text('Today, 11:44 am',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xff979797),
                                ),))
                        ],
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
}
