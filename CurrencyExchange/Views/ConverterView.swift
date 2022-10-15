//
//  ConverterView.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 11/10/2022.
//

import SwiftUI
import SwiftUIWheelPicker

struct ConverterView: View {
    
    var currencies:[Currency] = []
    var targetCurrencies:[Currency] = []
    
    @Binding var baseCode:String
    @Binding var targetCode:String
    
    var displayInputValue:String
    var displayOutputValue:String
    var displayBaseRate:String
    var displayTargetRate:String
    var onChangeCurrency : (String, String) -> Void
    var lastUpdate:String
    
    @State private var selectedIndexBase = 0
    @State private var selectedIndexTarget = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    VStack {
                        if currencies.count > 0 {
                            CurrencyScrollView(items: currencies, position: $selectedIndexBase, onScrollChange: {
                                currency in
                                onChange(base: currency.code, target:targetCode)
                            }).onAppear{
                                self.changeSelectedIndex(code: baseCode)
                            }
                        }
                        Spacer()
                        Text(displayInputValue).currencyValueStyle()
                            .padding(.horizontal, 10)
                            .padding(.bottom, 25)
                    }
                    
                    
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                Divider().overlay(Color.Surface)
                HStack(alignment: .center) {
                    VStack {
                        
                        Text(displayOutputValue).currencyValueStyle()
                            .padding(.horizontal, 10)
                            .padding(.top, 25)
                        Spacer()
                        if targetCurrencies.count > 0 {
                            CurrencyScrollView(items: targetCurrencies, position: $selectedIndexTarget, scrollPosition: .bottom, onScrollChange: {
                                currency in
                                onChange(base: baseCode, target: currency.code)
                            }).onAppear{
                                self.changeSelectedIndex(code: targetCode, isTarget: true)
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
            }
            HStack {
                
                ExchangeRateLatestView(displayBaseRate: displayBaseRate, displayTargetRate: displayTargetRate, lastUpdate: lastUpdate)
                Button(action: {
                    swapCurrency()
                } ){
                    Image(systemName: "arrow.up.arrow.down.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding(5)
                }
                .background(Circle())
                .foregroundColor(Color.Primary)
                
            }
            .padding(5)
            
        }
        
    }
    
    func changeSelectedIndex(code: String, isTarget: Bool = false){
        let index = findIndexCurrencies(code: code, isTarget: isTarget)
        if isTarget {
            self.selectedIndexTarget = index
        }else{
            self.selectedIndexBase = index
        }
    }
    
    func swapCurrency(){
        self.changeSelectedIndex(code: targetCode)
        self.changeSelectedIndex(code: baseCode, isTarget: true)
        self.onChange(base: targetCode, target: baseCode)
    }
    
    func onChange(base: String, target: String){
        self.onChangeCurrency(base, target)
    }
    
    func findIndexCurrencies(code:String, isTarget:Bool)-> Int {
        let items = isTarget ? targetCurrencies : currencies
        return items.firstIndex(where: {$0.code == code})!
    }
}

//struct ConverterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConverterView(baseCode: "USD", targetCode: "IDR", displayBaseRate: "base", displayTargetRate: "1500 USD", onChangeCurrency: {
//            base, target in
//            print(base)
//        })
//    }
//}
