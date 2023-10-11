//
//  HexColorsMacros.swift
//
//
//  Created by Alexander Alvmo on 2023-09-27.
//
import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct HexColorPlugin: CompilerPlugin {
    
    public let providingMacros: [Macro.Type] = [
        ColorHexMacro.self,
        UIColorHexMacro.self,
        NSColorHexMacro.self,
        CGColorHexMacro.self,
        HexIntExpressionMacro.self
    ]
}

/// Implementation of the `color`, `uiColor`, `nsColor`, `cgColor` macros, which takes a string or hexadecimal integer literal
/// and produces a color instance. For example
///
///     #color("#FFF") -> SwiftUI.Color( red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0 )
///     #color(0xfff) -> SwiftUI.Color( red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0 )
///
///     #uiColor("#FFF") -> UIkit.UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
///     #uiColor(0xfff) -> UIkit.UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
///
///     #nsColor("#FFF") -> AppKit.NSColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
///     #nsColor(0xfff) -> AppKit.NSColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
///
///     #cgColor("#FFF") -> CoreGraphics.CGColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
///     #cgColor(0xfff) -> CoreGraphics.CGColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )

//HexExpressionMacro
public struct HexIntExpressionMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        guard
            let argument = node.argumentList.first?.expression,
            let integerLiteral: TokenSyntax = argument.as(IntegerLiteralExprSyntax.self)?.literal
        else {
            fatalError("compiler bug: macro needs an integer literal")
        }
        dump(argument)
        var string = integerLiteral.text
        
        guard string.hasPrefix("0x") else {
            let error = HexColorsError.integerLiteralMustBeHexadecimal( string )
            context.diagnose( error.diagnose(at: node ) )
            throw error
        }
        
        string = string.replacingOccurrences(of: "0x", with: "#")
        
        switch rgba(for: string ){
        case .success(( let r, let g, let b, let a )):
            return "SwiftUI.Color(red: \(raw: r), green: \(raw: g), blue: \(raw: b), opacity: \(raw: a) )"
        case .failure( let error ):
            context.diagnose( error.diagnose(at: node ) )
            throw error
        }
    }
    
    
}
public protocol HexExpressionMacro: ExpressionMacro {
    static func colorExpressionSyntax( red: Double, green: Double, blue: Double, alpha: Double ) -> SwiftSyntax.ExprSyntax
}

extension HexExpressionMacro {
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
    
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: macro needs one argument")
        }
        
        var string: String
        if let stringLiteralExpressionSyntax = argument.as( StringLiteralExprSyntax.self ){
            let segments = stringLiteralExpressionSyntax.segments
            guard segments.count == 1, case .stringSegment(let literalSegment)? = segments.first else {
                fatalError("compiler bug: macro needs a static string")
            }
            
            string = literalSegment.content.text
        } else if let intergerLiteralExpressionSyntex = argument.as( IntegerLiteralExprSyntax.self ){
            string = intergerLiteralExpressionSyntex.literal.text
            
            guard string.hasPrefix("0x") else {
                let error = HexColorsError.integerLiteralMustBeHexadecimal( string )
                context.diagnose( error.diagnose(at: node ) )
                throw error
            }
            
            string = string.replacingOccurrences(of: "0x", with: "#")
        } else {
            fatalError("compiler bug: unknown argument type")
        }
    
        switch rgba( for: string ){
        case .success(( let r, let g, let b, let a )):
            return colorExpressionSyntax(red: r, green: g, blue: b, alpha: a )
        case .failure( let HexColorsError ):
            context.diagnose( HexColorsError.diagnose(at: node ) )
            throw HexColorsError
        }
    }
}

public struct ColorHexMacro: HexExpressionMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "SwiftUI.Color(red: \(raw: red), green: \(raw: green), blue: \(raw: blue), opacity: \(raw: alpha) )"
    }
}

public struct UIColorHexMacro: HexExpressionMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "UIKit.UIColor(red: \(raw: red), green: \(raw: green), blue: \(raw: blue), alpha: \(raw: alpha) )"
    }
}
public struct NSColorHexMacro: HexExpressionMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "AppKit.NSColor(red: CGFloat(\(raw: red)), green: CGFloat(\(raw: green)), blue: CGFloat(\(raw: blue)), alpha: CGFloat(\(raw: alpha)))"
    }
}

public struct CGColorHexMacro: HexExpressionMacro {
    public static func colorExpressionSyntax(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftSyntax.ExprSyntax {
        return "CoreGraphics.CGColor(red: CGFloat(\(raw: red)), green: CGFloat(\(raw: green)), blue: CGFloat(\(raw: blue)), alpha: CGFloat(\(raw: alpha)))"
    }
}

internal func rgba( for string: String ) -> Swift.Result<( Double, Double, Double, Double ), HexColorsError>{
    guard string.hasPrefix("#") else {
        return .failure( HexColorsError.stringLiteralMustStartWithHashtag( string ) )
    }
    
    let startAfterHashtag = string.index( string.startIndex, offsetBy: 1)
    let stringWithoutHashtag = String(string[startAfterHashtag...])
    
    let hexCharacters: Set<Character> = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ]
    for char in stringWithoutHashtag.lowercased() {
        guard hexCharacters.contains( char ) else {
            return .failure(  HexColorsError.invalidCharacters( string ) )
        }
    }
    
    guard stringWithoutHashtag.count > 0 else {
        return .failure( HexColorsError.invalidLength( string ) )
    }
    
    let scanner = Scanner(string: stringWithoutHashtag )
    var hexNumber: UInt64 = 0
    
    guard scanner.scanHexInt64(&hexNumber) else {
        return .failure( HexColorsError.failedToScanHex( string ) )
    }

    let r, g, b, a: Double
    // 4 diffrent lengths after removing the #
    switch stringWithoutHashtag.count {
    case 3: // RGB
        let R = Double((hexNumber & 0xf00) >> 8 )
        r = (( R * 16 ) + R ) /  255
        
        let G = Double((hexNumber & 0x0f0) >> 4 )
        g = (( G * 16 ) + G ) / 255
        
        let B = Double(hexNumber & 0x00f)
        b = (( B * 16 ) + B ) / 255
        
        a = 1
    case 4: // RGBA
        let R = Double((hexNumber & 0xf000) >> 12 )
        r = (( R * 16 ) + R ) /  255
        
        let G = Double((hexNumber & 0x0f00) >> 8 )
        g = (( G * 16 ) + G ) / 255
        
        let B = Double((hexNumber & 0x00f0) >> 4 )
        b = (( B * 16 ) + B ) / 255
        
        let A = Double(hexNumber & 0x000f)
        a = (( A * 16 ) + A ) / 255
    case 6: // RRGGBB ( alpha -> 100% )
        r = Double((hexNumber & 0xff0000) >> 16 ) / 255
        g = Double((hexNumber & 0x00ff00) >> 8 ) / 255
        b = Double(hexNumber & 0x0000ff) / 255
        a = 1
    case 8: // RRGGBBAA
        r = Double((hexNumber & 0xff000000) >> 24) / 255
        g = Double((hexNumber & 0x00ff0000) >> 16) / 255
        b = Double((hexNumber & 0x0000ff00) >> 8) / 255
        a = Double(hexNumber & 0x000000ff) / 255
    default:
        return .failure(  HexColorsError.invalidLength( string ) )
    }
    return .success( ( r, g, b, a ) )
}
