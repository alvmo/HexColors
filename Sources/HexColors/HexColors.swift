// The Swift Programming Language
// https://docs.swift.org/swift-book
#if canImport(SwiftUI)
import SwiftUI

@freestanding(expression)
public macro color(_ stringLiteral: StringLiteralType ) -> Color = #externalMacro(module: "HexColorsMacros", type: "ColorHexMacro")

@freestanding(expression)
public macro color(_ hexadecimalIntegerLiteral: IntegerLiteralType ) -> Color = #externalMacro(module: "HexColorsMacros", type: "HexIntExpressionMacro")

#endif

#if canImport(UIKit)
import UIKit

@freestanding(expression)
public macro uiColor(_ stringLiteral: StringLiteralType ) -> UIColor = #externalMacro(module: "HexColorsMacros", type: "UIColorHexMacro")

@freestanding(expression)
public macro uiColor(_ hexadecimalIntegerLiteral: IntegerLiteralType ) -> UIColor = #externalMacro(module: "HexColorsMacros", type: "UIColorHexMacro")
#endif

#if canImport(AppKit)
import AppKit

@freestanding(expression)
public macro nsColor(_ stringLiteral: StringLiteralType ) -> NSColor = #externalMacro(module: "HexColorsMacros", type: "NSColorHexMacro")


@freestanding(expression)
public macro nsColor(_ hexadecimalIntegerLiteral: IntegerLiteralType ) -> NSColor = #externalMacro(module: "HexColorsMacros", type: "NSColorHexMacro")
#endif


#if canImport(CoreGraphics)
import CoreGraphics

@freestanding(expression)
public macro cgColor(_ stringLiteral: StringLiteralType ) -> CGColor = #externalMacro(module: "HexColorsMacros", type: "CGColorHexMacro")

@freestanding(expression)
public macro cgColor(_ hexadecimalIntegerLiteral: IntegerLiteralType ) -> CGColor = #externalMacro(module: "HexColorsMacros", type: "CGColorHexMacro")
#endif

