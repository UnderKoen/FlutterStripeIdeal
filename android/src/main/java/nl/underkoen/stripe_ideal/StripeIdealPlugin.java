package nl.underkoen.stripe_ideal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.stripe.android.ApiResultCallback;
import com.stripe.android.PaymentIntentResult;
import com.stripe.android.Stripe;
import com.stripe.android.model.ConfirmPaymentIntentParams;
import com.stripe.android.model.PaymentMethod;
import com.stripe.android.model.PaymentMethodCreateParams;
import com.stripe.android.model.StripeIntent;

import org.jetbrains.annotations.NotNull;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * StripeIdealPlugin
 */
public class StripeIdealPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Stripe stripe;
  private Context context;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "stripe_ideal");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    if ("init".equals(call.method)) {
      stripe = new Stripe(context, getAsString(call, "key"));
      result.success(1);
    } else if ("confirmPaymentIntent".equals(call.method)) {
      PaymentMethodCreateParams.Ideal ideal = new PaymentMethodCreateParams.Ideal(getAsString(call, "bank"));
      PaymentMethodCreateParams methodCreateParams = PaymentMethodCreateParams.create(ideal);

      PaymentActivity.stripe = stripe;
      PaymentActivity.result = result;
      PaymentActivity.params = ConfirmPaymentIntentParams.createWithPaymentMethodCreateParams(
              methodCreateParams,
              getAsString(call, "clientSecret"),
              getAsString(call, "returnUrl"));
      Intent intent = new Intent(context, PaymentActivity.class);
      activity.startActivity(intent);
    } else {
      result.notImplemented();
    }
  }

  public String getAsString(MethodCall call, String key) {
    Object argument = call.argument(key);
    if (argument == null) return null;
    return (String) argument;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() { }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() { }

  public static class PaymentActivity extends Activity {
    public static Result result;
    public static Stripe stripe;
    public static ConfirmPaymentIntentParams params;

    public static final int SUCCESS = 1;
    public static final int FAILURE = 2;
    public static final int CANCELED = 3;
    public static final int UNKNOWN = 0;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      stripe.confirmPayment(this, params);
    }

    @Override
    protected void onActivityResult(final int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);
      stripe.onPaymentResult(requestCode, data, new ApiResultCallback<PaymentIntentResult>() {
        @Override
        public void onSuccess(@NotNull PaymentIntentResult paymentIntentResult) {
          if (result != null)  {
            StripeIntent.Status status = paymentIntentResult.getIntent().getStatus();
            if (status == StripeIntent.Status.Succeeded) {
              result.success(SUCCESS);
            } else if (status == StripeIntent.Status.RequiresPaymentMethod) {
              result.success(FAILURE);
            } else if (status == StripeIntent.Status.Canceled) {
              result.success(CANCELED);
            } else {
              result.success(UNKNOWN);
            }
          }
          finish();
        }

        @Override
        public void onError(@NotNull Exception e) {
          if (result != null) result.error(e.getMessage(), null, e);
          finish();
        }
      });
    }
  }
}
