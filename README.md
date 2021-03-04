# StripeIdeal

A implementation of stripe's ideal flow.

## Getting Started

### Initialise

```dart
StripeIdeal.init("your public stripe token")
```

### Confirm Payment

```dart
//For more information about the possible banks look at https://stripe.com/docs/sources/ideal#specifying-customer-bank
StripeIdeal.confirmPayment("the client secret", returnUrl: "https://example.com/return", bank: "ing")
```