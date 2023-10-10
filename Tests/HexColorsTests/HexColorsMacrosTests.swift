import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HexColorsMacros)
import HexColorsMacros

let testMacros: [ String: Macro.Type] = [
    "color" : ColorHexMacro.self,
    "uiColor" : UIColorHexMacro.self,
    "nsColor" : NSColorHexMacro.self,
    "cgColor" : CGColorHexMacro.self
]
#endif

final class HexColorsMacrosTests: XCTestCase {
    
    func testColorMacro() throws {
        #if canImport(SwiftUI)
        assertMacroExpansion(
            """
            #color("#FFF")
            """,
            expandedSource: """
            SwiftUI.Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0 )
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #color("#000")
            """,
            expandedSource: """
            SwiftUI.Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0 )
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #color(0xFFF)
            """,
            expandedSource: """
            SwiftUI.Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0 )
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #color(0x000)
            """,
            expandedSource: """
            SwiftUI.Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0 )
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testUIColorMacro() throws {
        #if canImport(UIKit)
        assertMacroExpansion(
            """
            #uiColor("#FFF")
            """,
            expandedSource: """
            UIKit.UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #uiColor(0xFFF)
            """,
            expandedSource: """
            UIKit.UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    
    func testNSColorMacro() throws {
        #if canImport(AppKit)
        assertMacroExpansion(
            """
            #nsColor("#FFF")
            """,
            expandedSource: """
            AppKit.NSColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #nsColor(0xFFF)
            """,
            expandedSource: """
            AppKit.NSColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    
    func testCGColorMacro() throws {
        #if canImport(CoreGraphics)
        assertMacroExpansion(
            """
            #cgColor("#FFF")
            """,
            expandedSource: """
            CoreGraphics.CGColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
            """,
            macros: testMacros
        )
        assertMacroExpansion(
            """
            #cgColor(0xFFF)
            """,
            expandedSource: """
            CoreGraphics.CGColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
