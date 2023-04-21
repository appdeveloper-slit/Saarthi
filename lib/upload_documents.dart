import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'manage/static_method.dart';
import 'select_location.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class UploadDocuments extends StatefulWidget {
  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return  Scaffold(
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
            color: Clr().appbarTextColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Upload Documents',
          style: Sty().largeText.copyWith(
              color: Clr().appbarTextColor, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     BoxShadow(
              //       color: Clr().grey.withOpacity(0.1),
              //       spreadRadius: 0.5,
              //       blurRadius: 12,
              //       offset: Offset(0, 8), // changes position of shadow
              //     ),
              //   ],
              // ),
              child: Card(

                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Clr().borderColor
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                    child: SvgPicture.asset('assets/upload.svg'),
                  ),
                  Expanded(child: Text('UPLOAD PRECIPITIN',style: Sty().mediumText,)),

                ],
              ),),
            ),
            SizedBox(height: 12,),
            Container(
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     BoxShadow(
              //       color: Clr().grey.withOpacity(0.1),
              //       spreadRadius: 0.5,
              //       blurRadius: 12,
              //       offset: Offset(0, 8), // changes position of shadow
              //     ),
              //   ],
              // ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Clr().borderColor
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                      child: SvgPicture.asset('assets/upload.svg'),
                    ),
                    Expanded(child: Text('UPLOAD GOVERNMENT ID',style: Sty().mediumText,)),

                  ],
                ),),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                  onPressed: () {
                    STM().redirect2page(ctx, SelectLocation());
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
                    'Submit',
                    style: Sty().mediumText.copyWith(
                      color: Clr().white,
                      fontWeight: FontWeight.w600,),
                  )),
            ),
          ],
        ),
      ),

    );
  }
}