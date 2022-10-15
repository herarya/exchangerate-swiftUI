//
//  HomeViewModel.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 12/10/2022.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var state: State
    let currencyService: CurrencyServiceProtocol
    let exchangeRateService: ExchangeRateServiceable
    let converterService: ConverterServiceable
    let calculator: Calculator
    
    var userDefaults: UserDefaults = UserDefaults.standard

    init(state: State = .init(), currencyService: CurrencyServiceProtocol = CurrencyService(), exchangeRateService: ExchangeRateServiceable = ExchangeRateService(), converterService: ConverterServiceable = ConverterService(), calculator:Calculator = Calculator()
    ) {
        self.state = state
        self.currencyService = currencyService
        self.exchangeRateService = exchangeRateService
        self.converterService = converterService
        self.calculator = calculator
    }
    
    // MARK: UI <- ViewModel
    
    struct State {
        var loading:Bool = false
        var currencies:[Currency] = []
        var displayBaseRate:String = ""
        var displayTargetRate:String = ""
        var displayInputValue:String = "0"
        var displayOutputValue:String = "0"
        var lastUpdate:String = ""
    }
    
    // MARK: UI -> ViewModel
    
    enum Action {
        case loadData(baseCode: String,targetCode: String)
        case digitPress(newInput: String)
        case backspacePress
        case clearPress
        case onAppear
        case dotPress
        case addPress
        case subtractPress
        case equalPress
        case multiplePress
        case devidePress
        case switchPressed(base:String, target:String)
    }
    
    @MainActor func action(_ action: Action) async {
        switch action {
        case .loadData(let baseCode, let targetCode):
            self.state.loading = true
            do {
                let currencies = try await currencyService.loadCurrencies()
                state.currencies = currencies
                state.loading = false
                setInputCurrency(base: baseCode, rate: 1.0, decimals: 2)
                await fetchRate(baseCode: baseCode, targetCode: targetCode)
            } catch {
                print(error.localizedDescription)
                state.loading = false
            }
        case .digitPress(let newInput):
            if calculator.settingNewValue {
                converterService.clear()
                calculator.settingNewValue = false
            }
            converterService.addInput(newInput)
            updateValueDisplay()
        case .backspacePress:
            guard !calculator.settingNewValue else {
                calculator.reset()
                updateValueDisplay()
                return
            }
            converterService.removeLastInput()
            updateValueDisplay()
        case .clearPress:
            converterService.clear()
            calculator.reset()
            updateValueDisplay()
        case .dotPress:
            converterService.beginDecimalInput()
            updateValueDisplay()
        case .addPress:
            calculator.newAddition(converterService.parsedInput())
            converterService.setInputValue(calculator.initialValue)
            updateValueDisplay()
        case .subtractPress:
            calculator.newSubtraction(converterService.parsedInput())
            converterService.setInputValue(calculator.initialValue)
            updateValueDisplay()
        case .multiplePress:
            calculator.newMultiply(converterService.parsedInput())
            converterService.setInputValue(calculator.initialValue)
            updateValueDisplay()
        case .devidePress:
            calculator.newDevide(converterService.parsedInput())
            converterService.setInputValue(calculator.initialValue)
            updateValueDisplay()
        case .equalPress:
            let result = calculator.calculate(Double(converterService.parsedInput()))
            converterService.setInputValue(result)
            updateValueDisplay()
        case .switchPressed(let base, let target):
            setInputCurrency(base: base, rate: 1.0, decimals: 2)
//            calculator.initialValue = converterService.convertToOutputCurrency(calculator.initialValue)
            converterService.swapInputWithOutput()
            await fetchRate(baseCode: base, targetCode: target)
            updateValueDisplay()
        case .onAppear:
            break
        }
    }
    
    fileprivate func fetchRate(baseCode: String, targetCode: String) async -> Void {
        let result = await exchangeRateService.getRates(code: baseCode)
        switch result {
        case .success(let response):
            do {
                try await currencyService.updateRates(rates: response.conversionRate)
                userDefaults.set(response.timeLastUpdateUnix, forKey: "lastUpdateCurrency")
                await self.onGetCurrencyFromLocal(base: baseCode, target: targetCode)
            }catch {
                print("error insert db")
            }
        case .failure(let error):
            //get from local storage
            await self.onGetCurrencyFromLocal(base: baseCode, target: targetCode)
        }
        
    }
    
    func updateValueDisplay(){
        let input = converterService.formattedInput()
        let output = converterService.formattedOutput()
        self.state.displayInputValue = input
        self.state.displayOutputValue = output
    }
    
    fileprivate func setInputCurrency(base:String, rate:Double, decimals: Int){
        self.state.displayBaseRate = "1 \(base)"
        converterService.setInputCurrency(code: base, rate: rate, decimals: decimals)
    }
    
    fileprivate func setOutputCurrency(target:String, rate:Double, decimals: Int){
        converterService.setOutputCurrency(code: target, rate: rate, decimals: decimals)
        let formatCurrency = converterService.formatCurrency(value: rate, decimals: Int(decimals))
        self.state.displayTargetRate = "\(formatCurrency) \(target)"
        self.updateDataLastUpdateDate()
    }
    
    fileprivate func onGetCurrencyFromLocal(base:String, target: String) async -> Void {
        let targetRate = await currencyService.getTargetRate(code: target)
        if let rate = targetRate {
            print("set output \(target) \(rate.rate)")
            setOutputCurrency(target: target, rate: rate.rate, decimals: 2)
        }
    }

    
    fileprivate func updateDataLastUpdateDate()-> Void {
        if let timeLastUpdateUnix = userDefaults.string(forKey: "lastUpdateCurrency") {
            let date = Date(timeIntervalSince1970: Double(timeLastUpdateUnix)!)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            self.state.lastUpdate = strDate
        }
    }
}
    
