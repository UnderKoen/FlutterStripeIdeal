import 'package:stripe_ideal/stripe_ideal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String publicKey = "pk_test_51HyOYuFgrKMNfpclr9OgLhGeXsegxi7KFl5fwjVTOa4G0qI3rt0sje7q06VPXvqZiu2u6vuivw1UJuVG430uZWQm00FmWAvWtk";
  final String paymentSecret = "pi_1IMvDDFgrKMNfpcl60y1VvzS_secret_KGGrIgNDqUJ37MJg7LFzPtpQ9";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StripeIdeal.init(publicKey),
        builder: (context, snapshot) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Plugin example app'),
              ),
              body: Center(
                child: ElevatedButton(
                  child: Text("pay"),
                  onPressed: () async {
                    Status status = await StripeIdeal.confirmPayment(
                      paymentSecret,
                      returnUrl: "https://example.com",
                    );
                    print(status);
                  },
                ),
              ),
            ),
          );
        }
    );
  }
}
