//
//  ExchangeRate.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation

struct ExchangeRate: Codable {
    var result: String
    var timeLastUpdateUnix: Int
    var baseCode: String
    var conversionRate: [String:Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case timeLastUpdateUnix = "time_last_update_unix"
        case baseCode = "base_code"
        case conversionRate = "conversion_rates"
    }
}
