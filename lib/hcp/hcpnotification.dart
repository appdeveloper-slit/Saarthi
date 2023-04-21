import 'package:flutter/material.dart';
import 'package:saarathi/manage/static_method.dart';
import 'package:saarathi/values/colors.dart';
import 'package:saarathi/values/dimens.dart';
import 'package:saarathi/values/styles.dart';

class HcpNotification extends StatefulWidget {
  const HcpNotification({Key? key}) : super(key: key);

  @override
  State<HcpNotification> createState() => _HcpNotificationState();
}

class _HcpNotificationState extends State<HcpNotification> {
  late BuildContext ctx;
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
        title: Text('Notifications',
          style: Sty().largeText.copyWith(color: Clr().black),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
             SizedBox(
              height: MediaQuery.of(ctx).size.height / 1.3,
              child: Center(
                child: Text('No Notifications',style: Sty().mediumBoldText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
