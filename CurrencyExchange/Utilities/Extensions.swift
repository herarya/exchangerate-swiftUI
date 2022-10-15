//
//  Extensions.swift
//  CurrencyExchange
//
//  Created by Herman - Herman on 11/10/2022.
//

import Foundation
import SwiftUI

extension Text {
    func currencyValueStyle() -> some View {
        self.bold()
            .font(.system(size: 100))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundColor(Color.TextColor)
    }
}


extension Double {
    func split() -> [String] {
        return String(self).split{$0 == "."}.map({
            return String($0)
        })
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    static var theme: Color  {
        return Color("theme")
    }
    static var Background: Color  {
        return Color("Background")
    }
    static var BackgroundList: Color  {
        return Color("BackgroundList")
    }
    static var Primary: Color  {
        return Color("Primary")
    }
    static var Secondary: Color  {
        return Color("Secondary")
    }
    static var Surface: Color  {
        return Color("Surface")
    }
    static var TextColor: Color  {
        return Color("TextColor")
    }
    static var PrimaryShadow: Color  {
        return Color("PrimaryShadow")
    }
    static var SublineColor: Color  {
        return Color("SublineColor")
    }
}
