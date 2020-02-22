//
//  ExternalBankAccount.swift
//  Stripe
//
//  Created by Andrew Edwards on 1/20/18.
//

// Only used for creating/updating Account external sources.
// Not expected to be returned by the API at all.
public struct StripeExternalBankAccount: ExternalAccount, StripeModel {
    public var object: String = "bank_account"
    public var country: String?
    public var currency: StripeCurrency?
    public var accountHolderName: String?
    public var accountHolderType: String?
    public var routingNumber: String?
    public var bankName: String?
    
    public enum CodingKeys: String, CodingKey {
        case object
        case country
        case currency
        case accountHolderName = "account_holder_name"
        case accountHolderType = "account_holder_type"
        case routingNumber = "routing_number"
        case bankName = "bank_name"
    }
}
