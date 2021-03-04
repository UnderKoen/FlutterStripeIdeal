
import 'dart:async';

import 'package:flutter/services.dart';

class StripeIdeal {
  static const MethodChannel _channel =
      const MethodChannel('stripe_ideal');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
