//
//  ExchangeRateLatestView.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 13/10/2022.
//

import SwiftUI

struct ExchangeRateLatestView: View {
    
    var displayBaseRate:String
    var displayTargetRate:String
    var lastUpdate:String
    
    var body: some View {
        Button(action: {
            print("Rounded Button")
        }, label: {
            HStack {
                VStack(spacing: 0) {
                    Text("\(displayBaseRate) = \(displayTargetRate)").foregroundColor(.white).bold().padding(.top, 8)
                    Text(lastUpdate).foregroundColor(Color.SublineColor).font(.subheadline).padding(.bottom, 8)
                }
                .padding(.leading, 15)
                Image(systemName: "gobackward")
                    .foregroundColor(.white)
                    .font(.largeTitle).padding(.trailing, 10)
            }
            .background(Color.Primary)
            .foregroundColor(Color.white)
            .cornerRadius(35)
            
        })
        .padding(.trailing, 10)
    }
}

struct ExchangeRateLatestView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeRateLatestView(displayBaseRate: "USD", displayTargetRate: "IDR", lastUpdate: "20/02/2022")
    }
}
