//
//  ExternalAccountRoutes.swift
//  Stripe
//
//  Created by Kasey on 2/22/20.
//

import Vapor

public enum StripeBankAccountHolderType: String, StripeModel {
    case individual
    case company
}

public protocol ExternalAccountRoutes {
    /// Creates a new bank account. When you create a new bank account, you must specify a [Custom account](https://stripe.com/docs/connect/custom-accounts) to create it on.
    ///
    /// - Parameters:
    ///   - account: The connect account this bank account should be created for.
    ///   - bankAccount: Either a token, like the ones returned by [Stripe.js](https://stripe.com/docs/stripe-js/reference), or a dictionary containing a user’s bank account details
    ///   - defaultForCurrency: When set to true, or if this is the first external account added in this currency, this account becomes the default external account for its currency.
    ///   - metadata: A set of key-value pairs that you can attach to an external account object. It can be useful for storing additional information about the external account in a structured format.
    /// - Returns: A `StripeBankAccount`.
    func create(account: String, bankAccount: Any, defaultForCurrency: Bool?, metadata: [String: String]?) -> EventLoopFuture<StripeBankAccount>
    
    /// Retrieves an existing bank account.
    ///
    /// - Parameters:
    ///   - account: The unique identifier of the account the person is associated with.
    ///   - externalAccount: The ID of an external account to retrieve.
    /// - Returns: Returns a bank account object.
    /// - Throws: A `StripeError`
    func retrieve(account: String, externalAccount: String) throws -> EventLoopFuture<StripeExternalBankAccount>
    
    /// Updates the metadata, account holder name, and account holder type of a bank account belonging to a [Custom account](https://stripe.com/docs/connect/custom-accounts), and optionally sets it as the default for its currency.
    /// Other bank account details are not editable by design. \n You can re-enable a disabled bank account by performing an update call without providing any arguments or changes.
    ///
    /// - Parameters:
    ///   - account: The connect account associated with this bank account.
    ///   - id: The ID of the bank account to update.
    ///   - accountHolderName: The name of the person or business that owns the bank account. This will be unset if you POST an empty value.
    ///   - accountHolderType: The type of entity that holds the account. This can be either `individual` or `company`. This will be unset if you POST an empty value.
    ///   - defaultForCurrency: When set to true, this becomes the default external account for its currency.
    ///   - metadata: A set of key-value pairs that you can attach to an external account object. It can be useful for storing additional information about the external account in a structured format.
    /// - Returns: A `StripeBankAccount`.
    func update(account: String,
                id: String,
                accountHolderName: String?,
                accountHolderType: StripeBankAccountHolderType?,
                defaultForCurrency: Bool?,
                metadata: [String: String]?) throws -> EventLoopFuture<StripeBankAccount>
    
    /// Deletes a bank account. You can delete destination bank accounts from a [Custom account](https://stripe.com/docs/connect/custom-accounts).
    /// If a bank account's `default_for_currency` property is true, it can only be deleted if it is the only external account for that currency, and the currency is not the Stripe account's default currency. Otherwise, before deleting the account, you must set another external account to be the default for the currency.
    ///
    /// - Parameters:
    ///   - account: The connect account associated with this bank account.
    ///   - id: The ID of the bank account to be deleted.
    /// - Returns: A `StripeDeletedObject`.
    func deleteBankAccount(account: String, id: String) throws -> EventLoopFuture<StripeDeletedObject>
}

extension ExternalAccountRoutes {
    public func create(account: String, bankAccount: Any, defaultForCurrency: Bool? = nil, metadata: [String: String]? = nil) -> EventLoopFuture<StripeBankAccount> {
        return create(account: account, bankAccount: bankAccount, defaultForCurrency: defaultForCurrency, metadata: metadata)
    }
    
    public func retrieve(account: String, externalAccount: String) throws -> EventLoopFuture<StripeExternalBankAccount> {
        return try retrieve(account: account, externalAccount: externalAccount)
    }
    
    public func update(account: String,
                       id: String,
                       accountHolderName: String? = nil,
                       accountHolderType: StripeBankAccountHolderType? = nil,
                       defaultForCurrency: Bool? = nil,
                       metadata: [String: String]? = nil) throws -> EventLoopFuture<StripeBankAccount> {
        return try update(account: account,
                          id: id,
                          accountHolderName: accountHolderName,
                          accountHolderType: accountHolderType,
                          defaultForCurrency: defaultForCurrency,
                          metadata: metadata)
    }
    
    public func deleteBankAccount(account: String, id: String) throws -> EventLoopFuture<StripeDeletedObject> {
        return try deleteBankAccount(account: account, id: id)
    }
}

public struct StripeExternalAccountRoutes: ExternalAccountRoutes {
    private let request: StripeRequest
    
    init(request: StripeRequest) {
        self.request = request
    }
    
    public func create(account: String, bankAccount: Any, defaultForCurrency: Bool? = nil, metadata: [String : String]? = nil) throws -> EventLoopFuture<StripeBankAccount> {
        var body: [String: Any] = [:]
        
        if let bankToken = bankAccount as? String {
            body["external_account"] = bankToken
        } else if let bankDetails = bankAccount as? [String: Any] {
            bankDetails.forEach { body["external_account[\($0)]"] = $1 }
        }
        
        if let defaultForCurrency = defaultForCurrency {
            body["default_for_currency"] = defaultForCurrency
        }
        
        if let metadata = metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }

        return try request.send(method: .POST, path: StripeAPIEndpoint.externalAccounts(account).endpoint, body: body.queryParameters)
    }
    
    public func retrieve(account: String, externalAccount: String) throws -> EventLoopFuture<StripeExternalBankAccount> {
        return try request.send(method: .GET, path: StripeAPIEndpoint.externalAccount(account, externalAccount).endpoint)
    }
    
    public func update(account: String,
                       id: String,
                       accountHolderName: String?,
                       accountHolderType: StripeBankAccountHolderType?,
                       defaultForCurrency: Bool?,
                       metadata: [String: String]?) throws -> EventLoopFuture<StripeBankAccount> {
        var body: [String: Any] = [:]
        
        if let accountHolderName = accountHolderName {
            body["account_holder_name"] = accountHolderName
        }
        
        if let accountHolderType = accountHolderType {
            body["account_holder_type"] = accountHolderType.rawValue
        }
        
        if let defaultForCurrency = defaultForCurrency {
            body["default_for_currency"] = defaultForCurrency
        }
        
        if let metadata = metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.externalAccounts(account).endpoint, body: body.queryParameters)
    }
    
    public func deleteBankAccount(account: String, id: String) throws -> EventLoopFuture<StripeDeletedObject> {
        return try request.send(method: .DELETE, path: StripeAPIEndpoint.externalAccounts(account).endpoint)
    }
}
