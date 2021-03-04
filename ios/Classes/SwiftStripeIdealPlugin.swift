import Flutter
import UIKit
import Stripe

public class SwiftStripeIdealPlugin: NSObject, FlutterPlugin, STPAuthenticationContext {
    var flutterViewController: UIViewController

    public func authenticationPresentingViewController() -> UIViewController {
        return self.flutterViewController
    }

    init(flutterViewController: UIViewController) {
        self.flutterViewController = flutterViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let flutterViewController = UIApplication.shared.delegate?.window?!.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(name: "stripe_ideal", binaryMessenger: registrar.messenger())
        let instance = SwiftStripeIdealPlugin(flutterViewController: flutterViewController)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary

        switch call.method {
            case "init":
                setStripeSettings(arguments: arguments, result: result)
                result(1)
            case "confirmPaymentIntent":
                confirmPaymentIntent(arguments: arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func setStripeSettings(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let stripePublishableKey = arguments?["key"] as? String else {
            result(FlutterError.init(code: "incorrectKey", message: "Key is required", details: nil))
            return
        }

        Stripe.setDefaultPublishableKey(stripePublishableKey)
        result(1)
    }

    func confirmPaymentIntent(arguments: NSDictionary?, result: @escaping FlutterResult) {
        guard let clientSecret = arguments?["clientSecret"] as? String else {
            result(FlutterError.init(code: "incorrectSecret", message: "Secret is required", details: nil))
            return
        }

        let params = STPPaymentIntentParams(clientSecret: clientSecret)

        let ideal = STPPaymentMethodiDEALParams()
        ideal.bankName = arguments?["bank"] as? String

        params.paymentMethodParams = STPPaymentMethodParams(iDEAL: ideal, billingDetails: nil, metadata: nil)
        params.returnURL = arguments?["returnUrl"] as? String

        STPPaymentHandler.shared().confirmPayment(withParams: params, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
                case .failed:
                    result(3)
                case .canceled:
                    result(2)
                case .succeeded:
                    result(1)
                default:
                    result(0);
            }
        }
    }
}
