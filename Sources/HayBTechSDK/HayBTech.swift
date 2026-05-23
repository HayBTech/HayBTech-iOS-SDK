import Foundation

/**
 * HayBTech iOS SDK - Hardened for Security.
 */
public final class HayBTech {
    public static let shared = HayBTech()
    
    private var publicKey: String?
    
    private init() {}
    
    /**
     * SECURITY WARNING: Never use your Secret Key (sk_...) in an iOS app.
     * All sensitive operations must be done on your backend server.
     */
    public func configure(publicKey: String) {
        if !publicKey.hasPrefix("pk_") {
            fatalError(
                "[HayBTech] Invalid Public Key. For security reasons, the iOS SDK only accepts Public Keys (pk_...). " +
                "Do NOT use your Secret Key in mobile apps as it can be easily extracted by decompiling the binary."
            )
        }
        self.publicKey = publicKey
    }
    
    internal func getPublicKey() throws -> String {
        guard let key = publicKey else {
            throw HayBTechError.notConfigured
        }
        return key
    }
}

public enum HayBTechError: Error {
    case notConfigured
    case invalidUrl
}
