//
//  Coin.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 15/10/2022.
//

import Foundation

class Coin {
    var code: String!
    var rate: Double!
    var decimals: Int!
    
    init(withCode code: String, rate: Double, decimals: Int) {
        self.code = code
        self.rate = rate
        self.decimals = decimals
    }
    
    func setTo(_ code: String, rate:Double = 0, decimals: Int = 0) {
        self.code = code
        self.rate = rate
        self.decimals = decimals
    }
}
