# HayBTech iOS SDK (Swift)

Official Swift SDK for the HayBTech Payment Gateway -- integrate mobile money payments  into your iOS apps.

[![Swift](https://img.shields.io/badge/Swift-5.7+-FA7343.svg)](https://swift.org/)
[![Platform](https://img.shields.io/badge/platform-iOS%2013+-lightgrey.svg)](https://developer.apple.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## SECURITY WARNING

**NEVER use your Secret Key (`sk_...`) in an iOS app.**
Secrets stored in mobile binaries can be easily extracted by attackers.

The iOS SDK only accepts **Public Keys (`pk_...`)**. All sensitive operations (like creating a payment) must be performed on your backend server using our server-side SDKs (PHP, Node.js, Python, Ruby, Java, Go, .NET).

---

## Installation

### Swift Package Manager (recommended)

1. In Xcode, select **File > Add Packages...**
2. Enter the URL: `https://github.com/haybtech/ios-sdk`
3. Select the version and add to your project.

### CocoaPods

```ruby
pod 'HayBTechSDK', '~> 1.0'
```

---

## Secure Workflow

```
iOS App                         Your Backend                  HayBTech API
    |                               |                            |
    |-- 1. Send order details ----->|                            |
    |                               |-- 2. Create payment ------>|
    |                               |<--- paymentUrl ------------|
    |<-- 3. Return paymentUrl ------|                            |
    |                               |                            |
    |-- 4. Show CheckoutView ----->|                            |
    |   (WKWebView with URL)        |                            |
```

1. **Your iOS App** sends order details to **Your Backend**.
2. **Your Backend** creates a payment via HayBTech API (using Secret Key) and returns the `paymentUrl`.
3. **Your iOS App** receives the `paymentUrl` and opens the checkout using `HayBTechCheckoutView`.

---

## Usage

### SwiftUI

#### 1. Configure SDK

```swift
import HayBTechSDK

// In your App init or AppDelegate
HayBTech.shared.configure(publicKey: "pk_test_your_public_key")
```

#### 2. Show Checkout

```swift
import SwiftUI
import HayBTechSDK

struct PaymentScreen: View {
    @State private var showCheckout = false
    @State private var paymentUrl = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Button("Pay 5,000 XOF") {
                Task {
                    await createPayment()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showCheckout) {
            HayBTechCheckoutView(
                paymentUrl: paymentUrl,
                onSuccess: { url in
                    showCheckout = false
                    alertMessage = "Payment successful!"
                    showAlert = true
                },
                onCancel: {
                    showCheckout = false
                }
            )
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    func createPayment() async {
        // Call your backend to get the paymentUrl
        guard let url = URL(string: "https://api.yourbackend.com/create-payment") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let (data, _) = try? await URLSession.shared.data(for: request),
           let response = try? JSONDecoder().decode(PaymentResponse.self, from: data) {
            paymentUrl = response.paymentUrl
            showCheckout = true
        }
    }
}
```

### UIKit

```swift
import UIKit
import HayBTechSDK

class PaymentViewController: UIViewController {
    
    func startCheckout(paymentUrl: String) {
        let checkoutVC = HayBTechCheckoutViewController(
            paymentUrl: paymentUrl,
            onSuccess: { [weak self] url in
                self?.dismiss(animated: true) {
                    // Show success
                }
            },
            onCancel: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        present(checkoutVC, animated: true)
    }
}
```

---


---

## Security Features

- **Public Key Enforcement**: Uses `fatalError` if an `sk_` key is used during configuration.
- **WKWebView Isolation**: Monitors navigation actions to detect terminal states without exposing sensitive data.
- **No Persistence**: The SDK does not store any payment or transaction data in `UserDefaults` or the Keychain.
- **App Transport Security**: All communication is over HTTPS by default.

---

## Requirements

| Requirement | Version |
|:------------|:--------|
| iOS         | 13.0+   |
| Swift       | 5.7+    |
| Xcode       | 14.0+   |

---

MIT License
