import SwiftUI
import WebKit

/**
 * HayBTech Checkout View (SwiftUI).
 * 
 * Securely renders the payment gateway and monitors navigation states.
 */
public struct HayBTechCheckoutView: UIViewRepresentable {
    let paymentUrl: String
    var onSuccess: ((String) -> Void)?
    var onCancel: (() -> Void)?
    var onFailure: ((String) -> Void)?

    public init(
        paymentUrl: String,
        onSuccess: ((String) -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        onFailure: ((String) -> Void)? = nil
    ) {
        self.paymentUrl = paymentUrl
        self.onSuccess = onSuccess
        self.onCancel = onCancel
        self.onFailure = onFailure
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: paymentUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HayBTechCheckoutView

        init(_ parent: HayBTechCheckoutView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                if url.contains("/success") || url.contains("status=success") {
                    parent.onSuccess?(url)
                    decisionHandler(.cancel)
                    return
                } else if url.contains("/cancel") || url.contains("status=cancelled") {
                    parent.onCancel?()
                    decisionHandler(.cancel)
                    return
                } else if url.contains("/failed") || url.contains("status=failed") {
                    parent.onFailure?(url)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
