//
//  PaymentMethodList.swift
//  Stripe
//
//  Created by Kasey on 6/8/20.
//

import Foundation

public struct PaymentMethodList: StripeModel {
    public var object: String
    public var hasMore: Bool
    public var totalCount: Int?
    public var url: String?
    public var data: [StripePaymentMethod]?
    
    public enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case totalCount = "total_count"
        case url
        case data
    }
}
