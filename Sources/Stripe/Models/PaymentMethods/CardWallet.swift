//
//  CardWallet.swift
//  Stripe
//
//  Created by Kasey on 6/8/20.
//

public struct StripeCardWallet: StripeModel {
    public var type: String?
    public var dynamicLast4: String?
    public var amexExpressCheckout: [String: String]?
    public var applePay: [String: String]?
    public var googlePay: [String: String]?
    
    public enum CodingKeys: String, CodingKey {
        case type
        case dynamicLast4 = "dynamic_last4"
        case amexExpressCheckout = "amex_express_checkout"
        case applePay = "apple_pay"
        case googlePay = "google_pay"
    }
    
}
