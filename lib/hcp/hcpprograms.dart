import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/styles.dart';

class Programs extends StatefulWidget {
  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  late BuildContext ctx;

  List<dynamic> programList = [];

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return  Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: (){
            STM().back2Previous(ctx);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().black,
          ),

        ),
        centerTitle: true,
        title: Text('Programs',
          style: Sty().largeText.copyWith(color: Clr().black),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            programList.isEmpty ? Container(
              height: MediaQuery.of(ctx).size.height/1.3,
              child: Center(
                child: Text('No Programs Added',style: Sty().mediumBoldText),
              ),
            ) : ListView.builder(
              shrinkWrap: true,
              itemCount: 14,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return programLayout(ctx, index, programList);
              },
            ),
          ],
        ),
      ),

    );
  }

  Widget programLayout(ctx, index , List){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().borderColor)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dim().d16, vertical: Dim().d16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lorem ipsum dolor sit amet',
                style: Sty().mediumText,
              ),
              InkWell(
                  onTap: (){
                    // STM().redirect2page(ctx, Program());
                  },
                  child: SvgPicture.asset('assets/arrow1.svg'))
            ],
          ),
        ),
      ),
    );
  }
}