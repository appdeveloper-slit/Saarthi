import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saarathi/home.dart';
import 'package:saarathi/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manage/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'bottom_navigation/bottom_navigation.dart';


class BookingDetails extends StatefulWidget {
  final dynamic labdetails;
  const BookingDetails({super.key, this.labdetails});
  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late BuildContext ctx;
  dynamic labdetails;
  String? usertoken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      usertoken = sp.getString('customerId') ?? '';
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        print(usertoken);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    labdetails = widget.labdetails;
    getSession();
    super.initState();
  }

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
          'Booking Details',
          style: TextStyle(color: Clr().black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Clr().white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d4,vertical: Dim().d4),
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
                      Image.network(labdetails['lab']['image_path'].toString(),height:Dim().d80,width: Dim().d120),
                      SizedBox(
                        width:Dim().d12,
                      ),
                      Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(labdetails['lab']['name'].toString(),
                                  style:
                                  Sty().mediumText.copyWith(
                                      fontWeight:
                                      FontWeight.w600,
                                      color: Color(0xff2D2D2D)
                                  )),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(labdetails['lab']['available_days'].toString(),style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Text(labdetails['lab']['available_time'].toString(),style: TextStyle(fontSize: 16)),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Row(
                                children: [
                                  Text('Starts at',style: TextStyle(fontSize: Dim().d16)),
                                  SizedBox(width: Dim().d4,),
                                  Text('₹ ${labdetails['lab']['starts_at'].toString()}',style: TextStyle(fontSize: Dim().d16)),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Text(labdetails['type'] == '1' ? 'Completed' : labdetails['type'] == '2' ? 'Cancelled' : 'Pending',
                                  // 'Completed',
                                  style:
                                  Sty().mediumText.copyWith(
                                      fontWeight:
                                      FontWeight.w600,fontSize: 16,
                                      color: labdetails['type'] == '1' ? Clr().green : labdetails['type'] == '2' ? Clr().red : Color(0xffFFC107)
                                  )),
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
            SizedBox(
              height: Dim().d16,
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Color(0xFFFBFBFB),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:  EdgeInsets.only(left: Dim().d8),
                            child: Text(
                              'Payment Deatails',
                              style: Sty().largeText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                // fontFamily: Outfit
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Test Charges',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '₹ ${labdetails['charge']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '₹ 0',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),

                      ],
                    ),
                  ),

                  Divider(
                    height: 2,
                    thickness: 1.5,
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: Dim().d2,bottom: Dim().d16,left:Dim().d16,right: Dim().d16 ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: Sty().largeText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₹ ${labdetails['total']}',
                                style: Sty().largeText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d16,
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Color(0xFFFBFBFB),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Address',
                        style: Sty().largeText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          // fontFamily: Outfit
                        ),
                      ),
                    ),
                    SizedBox(height: Dim().d12),
                    Text(
                      labdetails['lab']['address'].toString(),
                      style: TextStyle(fontSize: Dim().d16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            labdetails['type'] == '0' ? SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    AppointmentCancel(labdetails['id']);
                  },
                  style: ElevatedButton.styleFrom( elevation: 0,
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10))),
                  child: Text(
                    'Cancel',
                    // 'Download Invoice',
                    style: Sty().mediumText.copyWith(
                      color: Clr().white,
                      fontWeight: FontWeight.w600,),
                  )),
            ) : labdetails['type'] == '1' ? Container() : Container(),
            SizedBox(
              height: Dim().d24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              child: Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ',
               textAlign: TextAlign.center     ,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: Dim().d16,
            ),
            Text('Contact Support',
                style:
                Sty().mediumText.copyWith(
                    fontWeight:
                    FontWeight.w600,fontSize: 16,
                    color: Color(0xff80C342)
                )),
            SizedBox(
              height: Dim().d32,
            ),
          ],
        ),
      ),
    );
  }

  // appointment cancel

 void AppointmentCancel(id) async {
    FormData data = FormData.fromMap({
      'appointment_id': id,
    });
    var result = await STM().postWithToken(ctx, Str().processing, 'cancel_lab_appointment', data, usertoken, 'customer');
    var success = result['success'];
    var message = result['message'];
    if(success){
      STM().successDialogWithReplace(ctx, message, Home());
    }else{
      STM().errorDialog(ctx, message);
    }
 }

}
