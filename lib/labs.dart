import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'lab_details.dart';

class Labs extends StatefulWidget {
  @override
  State<Labs> createState() => _LabsState();
}

class _LabsState extends State<Labs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        backgroundColor: Clr().white,
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
            'Labs',
            style: TextStyle(color: Clr().black, fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.all(Dim().d8),
              child: InkWell(
                  onTap: () {
                    // STM().redirect2page(context, Pharmacy());
                  },
                  child: SvgPicture.asset('assets/search.svg')),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          backgroundColor: Clr().white,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 8,
                  ),
                  shrinkWrap: true,
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(ctx).size.width / 2.5,
                      child: Stack(
                        children: [
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Clr().borderColor)),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d12),
                              child: Column(
                                children: [
                                  Image.asset('assets/mybooking.png',
                                      height: 65, width: 100),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'NirAmaya Pathlabs',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Sty().smallText.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Divider(
                                    height: 2,
                                    thickness: 1.5,
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text(
                                    'Offers 20 Tests',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Clr().primaryColor),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      Text(
                                        'Dombivli (w)',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                  // Container(decoration: BoxDecoration(color: Colors.green)),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom( elevation: 0,
                                  //         backgroundColor: Clr().white,
                                  //         side: BorderSide(color: Clr().primaryColor),
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(5),
                                  //         )),
                                  //     onPressed: () {},
                                  //     child: Text(
                                  //       'Add to Cart',
                                  //       style: Sty().mediumText.copyWith(
                                  //           fontWeight: FontWeight.w600,
                                  //           color: Clr().primaryColor),
                                  //     )),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 4,
                              left: 4,
                              child: InkWell(
                                onTap: () {
                                  STM().redirect2page(context, LabsDetails());
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.height / 4.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Clr().grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 25,
                                          offset: Offset(12,
                                              0.5), // changes position of shadow
                                        ),
                                      ],
                                      color: Clr().primaryColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                      'Book',
                                      style: Sty().mediumText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Clr().white),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
