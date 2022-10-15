//
//  Currency.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation
import CoreData

enum CurrencyDataKey: String, CodingKey {
    case symbol
    case name
    case code
    case namePlural
    case decimalDigits
    case rate
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(Currency)
class Currency: NSManagedObject, Entity, Codable {
    @NSManaged var symbol: String
    @NSManaged var name: String
    @NSManaged var code: String
    @NSManaged var namePlural: String
    @NSManaged var decimalDigits: Int32
    @NSManaged var rate:Double
    
    static func entityName() -> String {
        return "Currencies"
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Currency.entityName(),
                                                      in: managedObjectContext) else {
                  fatalError("Failed to decode CurrenciesData Data")
              }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CurrencyDataKey.self)
        do {
            symbol = try values.decode(String.self, forKey: .symbol)
            name = try values.decode(String.self, forKey: .name)
            code = try values.decode(String.self, forKey: .code)
            namePlural = try values.decode(String.self, forKey: .namePlural)
            decimalDigits = try values.decode(Int32.self, forKey: .decimalDigits)
            rate = try values.decode(Double.self, forKey: .rate)
        } catch {
            debugPrint("Error")
        }
    }
}



