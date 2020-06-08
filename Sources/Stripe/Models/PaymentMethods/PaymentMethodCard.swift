//
//  PaymentMethodCard.swift
//  Stripe
//
//  Created by Kasey on 6/8/20.
//

public struct StripePaymentMethodCard: StripeModel {
    public var brand: String
    public var checks: StripeCardChecks?
    public var country: String
    public var expMonth: Int
    public var expYear: Int
    public var fingerprint: String
    public var funding: FundingType
    public var last4: String
    //public var generatedFrom: [String: String]?
    //public var threeDSecureUsage: [String: String]?
    public var wallet: StripeCardWallet?
    
    public enum CodingKeys: String, CodingKey {
        case brand
        case checks
        case country
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case fingerprint
        case funding
        case last4
        //case generatedFrom = "generated_from"
        //case threeDSecureUsage = "three_d_secure_usage"
        case wallet
    }
}

public struct StripeCardChecks: StripeModel {
    public var addressLine1Check: CardValidationCheck?
    public var addressPostalCodeCheck: CardValidationCheck?
    public var cvcCheck: CardValidationCheck?
}
