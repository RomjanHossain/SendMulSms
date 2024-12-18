// import 'package:flutter_sms/flutter_sms.dart';

import 'package:flutter_background_messenger/flutter_background_messenger.dart';

Future<bool> sendRealSMS(String message, List<String> recipents) async {
  final messenger = FlutterBackgroundMessenger();
  for (var recipent in recipents) {
    await messenger
        .sendSMS(message: message, phoneNumber: recipent)
        .catchError((onError) {
      print(onError);
      return false;
    });
  }
  return true;
}
