//
//  TokenRoutes.swift
//  Stripe
//
//  Created by Anthony Castelli on 5/12/17.
//
//

import Vapor

public protocol TokenRoutes {
    func createCard(card: [String: Any]?, customer: String?, connectAccount: String?) throws -> Future<StripeToken>
    func createBankAccount(bankAccount: [String: Any]?, customer: String?, connectAccount: String?) throws -> Future<StripeToken>
    func createConnectAccount(account: [String: Any]?) throws -> Future<StripeToken>
    func createPII(personalId: String?) throws -> Future<StripeToken>
    func retrieve(token: String) throws -> Future<StripeToken>
}

extension TokenRoutes {
    public func createCard(card: [String: Any]? = nil,
                           customer: String? = nil,
                           connectAccount: String? = nil) throws -> Future<StripeToken> {
        return try createCard(card: card,
                              customer: customer,
                              connectAccount: connectAccount)
    }
    
    public func createBankAccount(bankAccount: [String: Any]? = nil,
                                  customer: String? = nil,
                                  connectAccount: String? = nil) throws -> Future<StripeToken> {
        return try createBankAccount(bankAccount: bankAccount,
                                     customer: customer,
                                     connectAccount: connectAccount)
    }
    
    public func createConnectAccount(account: [String: Any]?) throws -> Future<StripeToken> {
        return try createConnectAccount(account: account)
    }
    
    public func createPII(personalId: String? = nil) throws -> Future<StripeToken> {
        return try createPII(personalId: personalId)
    }
    
    public func retrieve(token: String) throws -> Future<StripeToken> {
        return try retrieve(token: token)
    }
}

public struct StripeTokenRoutes: TokenRoutes {
    private let request: StripeRequest
    
    init(request: StripeRequest) {
        self.request = request
    }

    /// Create a card token
    /// [Learn More →](https://stripe.com/docs/api/curl#create_card_token)
    public func createCard(card: [String: Any]?,
                           customer: String?,
                           connectAccount: String?) throws -> Future<StripeToken> {
        var body: [String: Any] = [:]
        var headers: HTTPHeaders = [:]
        
        if let card = card {
            card.forEach { body["card[\($0)]"] = $1 }
        }
        
        if let customer = customer {
            body["customer"] = customer
        }
        
        if let connectAccount = connectAccount {
            headers.add(name: .stripeAccount, value: connectAccount)
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.tokens.endpoint, body: body.queryParameters, headers: headers)
    }
    
    /// Create a bank account token
    /// [Learn More →](https://stripe.com/docs/api/curl#create_bank_account_token)
    public func createBankAccount(bankAccount: [String: Any]?,
                                  customer: String?,
                                  connectAccount: String?) throws -> Future<StripeToken> {
        var body: [String: Any] = [:]
        var headers: HTTPHeaders = [:]
        
        if let bankAccount = bankAccount {
            bankAccount.forEach { body["bank_account[\($0)]"] = $1 }
        }
        
        if let customer = customer {
            body["customer"] = customer
        }
        
        if let connectAccount = connectAccount {
            headers.add(name: .stripeAccount, value: connectAccount)
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.tokens.endpoint, body: body.queryParameters, headers: headers)
    }
    
    /// Create a Connect account token
    /// [Learn More →] (https://stripe.com/docs/api/tokens/create_account)
    public func createConnectAccount(account: [String : Any]?) throws -> Future<StripeToken> {
        var body: [String: Any] = [:]
        
        if let account = account {
            account.forEach { body["account[\($0)]"] = $1 }
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.tokens.endpoint, body: body.queryParameters)
    }
    
    /// Create a PII token
    /// [Learn More →](https://stripe.com/docs/api/curl#create_pii_token)
    public func createPII(personalId: String?) throws -> Future<StripeToken> {
        var body: [String: Any] = [:]
        
        if let personalId = personalId {
            body["personal_id_number"] = personalId
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.tokens.endpoint, body: body.queryParameters)
    }
    
    /// Retrieve a token
    /// [Learn More →](https://stripe.com/docs/api/curl#retrieve_token)
    public func retrieve(token: String) throws -> Future<StripeToken> {
        return try request.send(method: .GET, path: StripeAPIEndpoint.token(token).endpoint)
    }
}
