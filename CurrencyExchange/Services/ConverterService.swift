//
//  ConverterService.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 13/10/2022.
//

import Foundation


protocol ConverterServiceable {
    func setInputCurrency(code:String, rate:Double, decimals: Int)-> Void
    func setOutputCurrency(code:String, rate:Double, decimals: Int)-> Void
    func addInput(_ newInput: String)
    func formattedInput() -> String
    func formattedOutput() -> String
    func clear()
    func removeLastInput()
    func beginDecimalInput()
    func formatCurrency(value: Double, decimals: Int
            ) -> String
    func parsedInput() -> Double
    func setInputValue(_ value: Double)
    func swapInputWithOutput()
    func convertToOutputCurrency(_ number: Double) -> Double
    
}

final class ConverterService: ConverterServiceable{
    
    var inputValue = "0"
    var inputDecimal = ""
    var inputDecimalMode = false
    var inputDecimalInputs = 0
    var inputCurrency: Coin
    var outputCurrency: Coin
    
    init(){
        inputCurrency = Coin(withCode: Constants.DEFAULT_BASE_CURRENCY_CODE, rate: 0, decimals: 0)
        outputCurrency =  Coin(withCode: Constants.DEFAULT_TARGET_CURRENCY_CODE, rate: 0, decimals: 0)
    }
    
    func setInputCurrency(code:String, rate:Double, decimals: Int)-> Void {
        inputCurrency.setTo(code, rate: rate, decimals: decimals)
    }
    
    func setOutputCurrency(code:String, rate:Double, decimals: Int)-> Void {
        outputCurrency.setTo(code, rate: rate, decimals: decimals)
    }



    // MARK: Convert.

    func convertToInputCurrency(_ number: Double) -> Double {
        let result: Double = (number / outputCurrency.rate) * inputCurrency.rate
        return result
    }

    func convertToOutputCurrency(_ number: Double) -> Double {
        print("convertToOutputCurrency \(number)")
        let result: Double = (number / inputCurrency.rate) * outputCurrency.rate
        print("inputCurrency.code \(inputCurrency.code)")
        print("inputCurrency.rate \(inputCurrency.rate)")
        print("outputCurrency.code \(outputCurrency.code)")
        print("outputCurrency.rate \(outputCurrency.rate)")
        return result
    }


    // MARK: Format as currency.

    func parsedInput() -> Double {
        var inputString: String
        if let integer = Int(inputValue) {
            inputString = "\(integer)"
        } else {
            inputString = "0"
        }
        if !inputDecimal.isEmpty {
            inputString = inputString + "." + "\(inputDecimal)"
        }
        return Double(inputString)!
    }

    func formattedInput() -> String {
        let inputValue: Double! = parsedInput()
        print("Input value:", inputValue)
        let formattedInput = formatToCurrency(
                inputValue,
                code: inputCurrency.code,
                decimals: inputCurrency.decimals
            )
        return formattedInput
    }

    func formattedOutput() -> String {
        let inputValue: Double! = parsedInput()
        let outputValue: Double = convertToOutputCurrency(inputValue)
        let formattedOutput = formatToCurrency(
                outputValue,
                code: outputCurrency.code,
                decimals: outputCurrency.decimals
            )
        return formattedOutput
    }

    fileprivate func formatToCurrency(
                _ value: Double,
                code: String,
                decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = ""
        var offset = 0
        var formattedCurrency: String! = formatter.string(from: NSNumber(value: value))

        if code == inputCurrency.code {
            formattedCurrency = truncateDecimalsToDecimalInputLength(formattedCurrency, decimals: decimals, offset: offset)
        } else {
            formattedCurrency = truncateEmptyDecimalsFromCurrency(formattedCurrency, decimals: decimals, offset: offset)
        }

        return formattedCurrency!
    }

    fileprivate func truncateDecimalsToDecimalInputLength(_ formattedCurrency: String, decimals: Int, offset: Int) -> String {
        guard decimals > 0 else {
            print("No decimals to truncate from price string")
            return formattedCurrency
        }

        let truncationLenght: Int! = (inputDecimalMode ? decimals : decimals + 1) - inputDecimalInputs

        guard truncationLenght > 0 else {
            print("Truncation length is a negative value");
            return formattedCurrency
        }

        let symbol: String! = String(formattedCurrency.dropFirst(formattedCurrency.count - offset))
        let number: String! = String(formattedCurrency.dropLast(offset)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let truncatedNumber: String! = String(number.dropLast(truncationLenght))
        let truncatedPrice: String! = truncatedNumber + symbol

        return truncatedPrice
    }

    fileprivate func truncateEmptyDecimalsFromCurrency(_ formattedCurrency: String, decimals: Int, offset: Int) -> String {
        guard decimals > 0 else {
            print ("There are no decimals to truncate from this currency")
            return formattedCurrency
        }
        
        let truncationLenght: Int! = decimals + 1
        let symbol: String! = String(formattedCurrency.dropFirst(formattedCurrency.count - offset))
        let number: String! = String(formattedCurrency.dropLast(offset)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lastCharacters: String! = String(number.suffix(truncationLenght))
        let decimalDivider: String! = String(lastCharacters.prefix(1))
        let emptyDecimals = decimalDivider + String(repeating: "0", count: decimals)
    
        if (lastCharacters == emptyDecimals) {
            let truncatedNumber: String! = String(number.dropLast(truncationLenght))
            let truncatedPrice: String! = truncatedNumber + symbol
            return truncatedPrice
        } else {
            return formattedCurrency
        }
    }

    // MARK: Add input.

    func addInput(_ newInput: String) {

        if inputDecimalMode {
            addDecimalInput(newInput)
        } else {
            addIntegerInput(newInput)
        }

    }

    fileprivate func addIntegerInput(_ newInput: String) {
        if inputValue == "0" && newInput == "0" {
            print("Value string is already zero or empty.")
            return
        }
        if inputValue == "0" && newInput != "0" {
            inputValue = newInput
            return
        }

        inputValue = inputValue + newInput
    }

    fileprivate func addDecimalInput(_ newInput: String) {
        print("Adding decimal input: \(newInput).")
        guard inputDecimal.count < inputCurrency.decimals else {
            print("Decimal input string has already reached the maximum length.")
            return
        }

        inputDecimal = inputDecimal + newInput
        print("New decimal input is: \(inputDecimal)")
        inputDecimalInputs = inputDecimalInputs + 1
        print("New number of decimal inputs so far is: \(inputDecimalInputs).")
    }

    // MARK: Remove input.

    func removeLastInput() {
        if inputDecimalMode && inputCurrency.decimals > 0 {
            if inputDecimal.isEmpty {
                inputDecimalMode = false
            } else {
                removeLastDecimalInput()
            }
        } else {
            removeLastIntegerInput()
        }
    }

    fileprivate func removeLastIntegerInput() {
        if inputValue == "0" {
            print("Input integer value string is already zero.")
            return
        }
        if inputValue.count == 1 {
            inputValue = "0"
            print("Input integer value was set to zero because it was a single digit value.")
            return
        }
        inputValue = String(inputValue.dropLast())
        print("sadfasdfasd\(inputValue)")
    }

    fileprivate func removeLastDecimalInput() {
        guard !inputDecimal.isEmpty else {
            print("Input decimal value is already empty.")
            return
        }
        inputDecimal = String(inputDecimal.dropLast())
        inputDecimalInputs = inputDecimalInputs - 1
    }

    // MARK: Swap input with output.

    func setInputValue(_ value: Double) {
        // First split the double into an integer and decimal string.
        let valueInteger: String = String(value.split()[0])
        let valueDecimal: String = String(value.split()[1])
        // Then define the values to be set.
        let newInteger: String = valueInteger
        let newDecimal: String = valueDecimal == "0" ? "" : valueDecimal
        let newNumberOfDecimalInputs: Int! = newDecimal.count
        let isDecimalModeOn: Bool! = newNumberOfDecimalInputs == 0 ? false : true
        // Finally, set the values.
        inputValue = newInteger
        inputDecimal = newDecimal
        inputDecimalInputs = newNumberOfDecimalInputs
        inputDecimalMode = isDecimalModeOn
    }

    func swapInputWithOutput() {
        let oldOutput = parseCurrency(
                formattedOutput(),
                code: outputCurrency.code,
                decimals: outputCurrency.decimals
        )

        setInputValue(oldOutput)
    }

    fileprivate func parseCurrency(
                _ formattedCurrency: String,
                code: String,
                decimals: Int
            ) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        formatter.usesGroupingSeparator = true;
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = ""
        if let number = formatter.number(from: formattedCurrency) {
            return (number.doubleValue)
        } else {
            print("Could not parse double from formatted currency string.")
            return 0.0
        }

    }

    // MARK: Reset.

    func clear() {
        inputValue = "0"
        inputDecimal = ""
        inputDecimalMode = false
        inputDecimalInputs = 0
    }

    func beginDecimalInput() {
        guard inputCurrency.decimals != 0 else {
            print("Input currency does not have decimals")
            return
        }
        inputDecimal = ""
        inputDecimalMode = true
        inputDecimalInputs = 0
    }
    
    func formatCurrency(value: Double, decimals: Int
            ) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        formatter.currencySymbol = ""
        return formatter.string(from: NSNumber(value: value))!
    }
    
    
}



