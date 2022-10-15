//
//  HomeView.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 11/10/2022.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @StateObject var model: HomeViewModel = .init()
    @State private var baseCode:String = Constants.DEFAULT_BASE_CURRENCY_CODE
    @State private var targetCode:String = Constants.DEFAULT_TARGET_CURRENCY_CODE
    
    var body: some View {
        ZStack {
            Color.Background.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                converterView
                CalculatorView(onTap: {
                    button in
                    onPressKey(button: button)
                }).frame(maxHeight: UIScreen.main.bounds.height / 2)
            }
        }
        .task { await model.action(.loadData(baseCode: baseCode, targetCode: targetCode)) }
    }
    
    func onPressKey(button:ButtonKey){
        switch button {
        case .backspace:
            onAction(action: .backspacePress)
        case .clear:
            onAction(action: .clearPress)
        case .decimal:
            onAction(action: .dotPress)
        case .add:
            onAction(action: .addPress)
        case .subtract:
            onAction(action: .subtractPress)
        case .equal:
            onAction(action: .equalPress)
        case .mutliply:
            onAction(action: .multiplePress)
        case .divide:
            onAction(action: .devidePress)
        default:
            onAction(action: .digitPress(newInput: button.rawValue))
        }
       
    }
    
    func onAction(action: HomeViewModel.Action){
        Task {
            await model.action(action)
        }
    }
    
    @ViewBuilder
    var converterView: some View {
        VStack {
            ConverterView(currencies: model.state.currencies, targetCurrencies:  model.state.currencies, baseCode: $baseCode, targetCode: $targetCode,
                          displayInputValue: model.state.displayInputValue, displayOutputValue: model.state.displayOutputValue, displayBaseRate: model.state.displayBaseRate, displayTargetRate: model.state.displayTargetRate, onChangeCurrency: {
                base, target in
                self.baseCode = base
                self.targetCode = target
                Task {
                    await model.action(.switchPressed(base: base, target: target))
                }
            }, lastUpdate: model.state.lastUpdate)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(.vertical, 25)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.colorScheme, .dark).previewDevice("iPhone 11")
        HomeView().environment(\.colorScheme, .light).previewDevice("iPhone 11")
    }
}
