//
//  ExchangeRatesEndpoint.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

enum ExchangeRatesEndpoint {
    case rate(code:String)
}

extension ExchangeRatesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .rate(let code):
            return "/v6/abc6de875971d74314117c78/latest/\(code)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .rate:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        switch self {
        case .rate:
            return nil
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .rate:
            return nil
        }
    }
}

