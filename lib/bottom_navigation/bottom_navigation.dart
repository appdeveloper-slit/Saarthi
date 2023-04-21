import 'package:flutter/material.dart';
import 'package:saarathi/my_appointments.dart';
import 'package:saarathi/my_orders.dart';
import '../home.dart';
import '../manage/static_method.dart';
import '../my_booking.dart';
import '../values/colors.dart';

Widget bottomBarLayout(ctx, index) {
  return BottomNavigationBar(
    elevation: 50,
    backgroundColor: Clr().white,
    selectedItemColor: Clr().grey,
    unselectedItemColor: Clr().grey,
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().finishAffinity(ctx, Home());
          break;
        case 1:
          index == 1
              ? STM().replacePage(ctx, MyAppointments())
              : STM().redirect2page(ctx, MyAppointments());
          break;
        case 2:
          index == 2
              ? STM().replacePage(ctx, MyBooking())
              : STM().redirect2page(ctx, MyBooking());
          break;
        case 3:
          index == 3
              ? STM().replacePage(ctx, MyOrders())
              : STM().redirect2page(ctx, MyOrders());
          break;
      }
    },
    items: STM().getBottomList(index),
  );
}
