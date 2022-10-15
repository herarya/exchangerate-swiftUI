//
//  CurrencyScrollView.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 13/10/2022.
//

import SwiftUI
import SwiftUIWheelPicker

enum Position {
  case top
  case bottom
}

struct CurrencyScrollView: View {
    
    var items: [Currency]
    @Binding var position: Int
    var scrollPosition:Position = .top
    
    var onScrollChange: (Currency) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            SwiftUIWheelPicker($position, items: items) { value in
                GeometryReader { reader in
                    VStack {
                        if scrollPosition == .top {
                            HStack {
                                if findIndex(currency: value) == position {
                                    Text(value.code).bold().foregroundColor(.gray)
                                }
                            }.frame(height: 15)
                        }
                        Image("\(value.code.lowercased())").resizable().clipShape(Circle())
                        if scrollPosition == .bottom {
                            HStack {
                                if findIndex(currency: value) == position {
                                    Text(value.code).bold().foregroundColor(.gray)
                                }
                            }.frame(height: 15)
                        }
                    }

                }
            }
            .scrollAlpha(0.1)
            .onValueChanged { item in
                self.onScrollChange(item)
            }
        }
    }
    
    
    func findIndex(currency:Currency)-> Int {
        return self.items.firstIndex(of: currency)!
    }
}
