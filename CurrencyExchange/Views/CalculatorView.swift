//
//  CalculatorView.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 11/10/2022.
//

import SwiftUI

struct CalculatorView: View {
    
    let buttons: [[ButtonKey]] = [
        [.clear, .backspace, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.space, .zero, .decimal, .equal],
    ]
    
    var onTap: (ButtonKey) -> Void
    
    var body: some View {
        VStack(spacing:0) {
            // MARK: Our buttons
            ForEach(buttons, id: \.self) { row in
                HStack(spacing:0) {
                    ForEach(row, id: \.self) { item in
                        ButtonView(button: item, onTap: {
                            print(item.rawValue)
                            self.onTap(item)
                        })
                    }
                }
            }
        }
        .background(Color(hex: "#b2bec3"))
        
    }
}

struct ButtonView: View {
    
    
    var button: ButtonKey
    
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            self.onTap()
        }, label: {
            if button == .backspace {
                Image(systemName: "arrow.left")
                    .font(.system(size: 32)).foregroundColor(Color.TextColor)
            }else{
                Text(button.rawValue)
                    .font(.system(size: 32)).bold()
                    .foregroundColor(Color.TextColor)
            }
            
        })
        .foregroundColor(.black)
        .frame(maxWidth: buttonWidth(item: button), maxHeight: buttonHeight())
        .background(self.buttonColor(button: button))
        
    }
    
    func buttonColor(button: ButtonKey) -> Color{
        switch button {
            case .add, .subtract, .mutliply, .divide, .equal:
            return Color.BackgroundList
            default:
            return .Surface
            }
    }
    
    func buttonWidth(item: ButtonKey) -> CGFloat {
        if item == .backspace {
            return (UIScreen.main.bounds.width / 4) * 2
        }
        return UIScreen.main.bounds.width / 4
    }
    
    func buttonHeight() -> CGFloat {
        return .infinity / 5
    }
    
}

//struct CalculatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculatorView().environment(\.colorScheme, .dark)
//        CalculatorView().environment(\.colorScheme, .light)
//    }
//}
