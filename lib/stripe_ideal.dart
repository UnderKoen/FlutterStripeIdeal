import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class StripeIdeal {
  static const MethodChannel _channel = const MethodChannel('stripe_ideal');

  static Future<void> init(String publicKey) async {
    var code = await _channel.invokeMethod('init', {"key": publicKey});
    print(code);
  }

  static Future<Status> confirmPayment(String secret,
      {@required String returnUrl, String bank}) async {
    int code = await _channel.invokeMethod('confirmPaymentIntent', {
      "clientSecret": secret,
      "returnUrl": returnUrl,
      "bank": bank,
    });

    switch (code) {
      case 1:
        return Status.success;
      case 2:
        return Status.failure;
      case 3:
        return Status.canceled;
      case 0:
      default:
        return Status.unknown;
    }
  }
}

enum Status { success, failure, canceled, unknown }
