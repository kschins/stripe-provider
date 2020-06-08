//
//  PaymentMethod.swift
//  Stripe
//
//  Created by Kasey on 6/8/20.
//

/** Payment Method Object
*  https://stripe.com/docs/api/payment_methods/object
*/

import Foundation

public struct StripePaymentMethod: StripeModel {
    public var id: String
    public var object: String
    public var created: Date?
    public var customer: String
    public var metadata: [String: String]?
    public var card: StripeCard?
    public var billingDetails: StripeBillingDetails?
    public var livemode: Bool?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case customer
        case metadata
        case card
        case billingDetails = "billing_details"
        case livemode
    }
}

public struct StripeBillingDetails: StripeModel {
    public var address: StripeAddress?
    public var email: String?
    public var name: String?
    public var phone: String?
}
