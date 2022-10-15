//
//  ExchangeRateServices.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation

protocol ExchangeRateServiceable {
    func getRates(code:String) async -> Result<ExchangeRate, RequestError>
}

struct ExchangeRateService: HTTPClient, ExchangeRateServiceable {
    func getRates(code:String) async -> Result<ExchangeRate, RequestError>{
        return await request(endpoint: ExchangeRatesEndpoint.rate(code: code), responseModel: ExchangeRate.self)
    }
}
