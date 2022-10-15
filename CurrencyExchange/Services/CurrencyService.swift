//
//  CurrencyService.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation

enum DBError: Error {
    case jsonFileMissing
    case failedInitialization
}

protocol CurrencyServiceProtocol {
  func loadCurrencies() async throws -> [Currency]
  func updateRates(rates: [String:Double]) async throws -> Void
  func getTargetRate(code: String) async -> Currency?
}

final class CurrencyService: CurrencyServiceProtocol {
    
    let dataBase:DatabaseManager = DatabaseManager()
    

    func loadCurrencies() async throws -> [Currency] {
        let currencies = self.dataBase.fetch(ofType: Currency.self)
        guard currencies.isEmpty else {
            print("total data currencies \(currencies.count) ✅")
            return currencies
        }
        guard let file = Bundle.main.url(forResource: "currencies", withExtension: "json") else {
            print("currencies.json is missing")
            throw DBError.jsonFileMissing
        }
        do {
            let data = try Data(contentsOf: file)
            self.dataBase.insert(data: data)
            let currencies = self.dataBase.fetch(ofType: Currency.self)
            return currencies
        } catch {
            throw DBError.failedInitialization
        }
    }
    
    func updateRates(rates: [String:Double]) async throws -> Void {
        for (key,value) in rates {
            print("key =? \(key)")
            print("value =? \(value)")
            self.dataBase.updateRate(code: key, rate: value)
        }
    }
    
    func getTargetRate(code: String) async -> Currency? {
        let currencies = self.dataBase.fetch(ofType: Currency.self, withPredicate: NSPredicate(format: "code = %@", code))
        guard currencies.isEmpty else {
            return currencies.first
        }
        return nil
    }
}

