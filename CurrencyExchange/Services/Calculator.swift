//
//  Calculator.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 15/10/2022.
//

import Foundation

enum ButtonKey: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case convert = "convert"
    case backspace = "backspace"
    case space = ""
}

enum Operation {
    case add, subtract, multiply, divide, none
}

class Calculator {
    
    var initialValue: Double
    var operationSymbol: Operation
    var operationInProgress: Bool
    var settingNewValue: Bool
    
    init() {
        initialValue = 0
        operationSymbol = .none
        operationInProgress = false
        settingNewValue = false
    }
    
    func calculate(_ number:Double) -> Double {
        if settingNewValue {
            let result = initialValue
            reset()
            return result
        }
        if operationInProgress {
            var result:Double = initialValue
            if operationSymbol == .add {
                result = initialValue + number
            }
            if operationSymbol == .subtract {
                result = initialValue - number
            }
            if operationSymbol == .multiply {
                result = initialValue * number
            }
            if operationSymbol == .divide {
                result = initialValue / number
            }
            reset()
            initialValue = result
            return result
        }
        reset()
        return number
    }
    
    func newAddition(_ number: Double) {
        initialValue = calculate(number)
        operationSymbol = .add
        settingNewValue = true
        operationInProgress = true
    }
    
    func newSubtraction(_ number: Double) {
        initialValue = calculate(number)
        operationSymbol = .subtract
        settingNewValue = true
        operationInProgress = true
    }
    
    func newMultiply(_ number: Double) {
        initialValue = calculate(number)
        operationSymbol = .multiply
        settingNewValue = true
        operationInProgress = true
    }
    
    func newDevide(_ number: Double) {
        initialValue = calculate(number)
        operationSymbol = .divide
        settingNewValue = true
        operationInProgress = true
    }
    
    func reset() {
        initialValue = 0
        operationSymbol = .none
        settingNewValue = false
        operationInProgress = false
    }
    
}

