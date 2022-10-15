//
//  Entity.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation

protocol EntityKey: Hashable {
}

protocol Entity {
    static func entityName() -> String
}

