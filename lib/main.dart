import 'package:flutter/material.dart';
import 'package:flutter_incoming_call/flutter_incoming_call.dart';
import 'package:saarathi/video/call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'hcp/hcpappointmentavailability.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'hcp/hcpeducational.dart';
import 'hcp/hcphome.dart';
import 'hcp/hcppersonalinfo.dart';
import 'hcp/hcpprofessional.dart';
import 'home.dart';
import 'log_in.dart';
import 'physical_details.dart';
import 'select_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool login = sp.getBool('login') ?? false;
  bool personal = sp.getBool('personal') ?? false;
  bool physical = sp.getBool('physical') ?? false;
  bool location = sp.getBool('location') ?? false;
  bool hcppersonal = sp.getBool('hcp_personalinfo') ?? false;
  bool hcpprofessional = sp.getBool('hcp_professionalinfo') ?? false;
  bool hcpeducational = sp.getBool('hcp_educationalinfo') ?? false;
  bool hcpaccount = sp.getBool('hcpaccount') ?? false;
  bool hcplogin = sp.getBool('hcplogin') ?? false;
  //cde5a8cc-c64f-484d-b552-7800c0c52ef9

  OneSignal.shared.setAppId("cde5a8cc-c64f-484d-b552-7800c0c52ef9");
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event1) {
    if (event1.notification.additionalData != null) {
      Map<String, dynamic> result = event1.notification.additionalData!;
      incomingCall(result);
      FlutterIncomingCall.onEvent.listen((BaseCallEvent event) {
        if (event is CallEvent) {
          if (event.action == CallAction.accept) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => CallPage(result),
              ),
            );
          }
        }
      });
    }
    event1.complete(null);
  });

  OneSignal.shared.setNotificationOpenedHandler((value) {
    if (value.notification.additionalData != null) {
      Map<String, dynamic> result = value.notification.additionalData!;
      incomingCall(result);
      FlutterIncomingCall.onEvent.listen((BaseCallEvent event) {
        if (event is CallEvent) {
          if (event.action == CallAction.accept) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => CallPage(result),
              ),
            );
          }
        }
      });
    }
  });

  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: login
          ? Home()
          : personal
              ? physical
                  ? SelectLocation()
                  : PhysicalDetails()
              : hcplogin
                  ? HomeVisit()
                  : hcppersonal
                      ? hcpeducational
                          ? ApptAvailability()
                          : hcpprofessional
                              ? EducationalInfo()
                              : ProfessionalInfo()
                      : hcpaccount
                          ? hcp_Personalinfo()
                          : SignIn(),
    ),
  );

  FlutterIncomingCall.configure(
      appName: 'Saarthi',
      duration: 30000,
      android: ConfigAndroid(
        vibration: true,
        ringtonePath: 'default',
        channelId: 'calls',
        channelName: 'Calls channel name',
        channelDescription: 'Calls channel description',
      ),
      ios: ConfigIOS(
        iconName: 'AppIcon40x40',
        ringtonePath: null,
        includesCallsInRecents: false,
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
      ));
}

incomingCall(result) {
  final uid = Uuid().v4();
  final name = result['doctor_name'];
  final avatar = result['doctor_profile_pic'];
  final handle = 'Incoming Call';
  final type = HandleType.number;
  final isVideo = true;
  FlutterIncomingCall.displayIncomingCallAdvanced(uid, name,
      avatar: avatar,
      handle: handle,
      handleType: type,
      hasVideo: isVideo,
      supportsGrouping: true,
      supportsHolding: true);
}
