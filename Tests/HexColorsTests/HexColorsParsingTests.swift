import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HexColorsMacros)
@testable import HexColorsMacros
#endif

final class HexColorsParsingTests: XCTestCase {
        
    //MARK: #RGB
    func testRGBHexStringParsingForWhite() throws {
        switch rgba(for: "#FFF"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 1.0 )
            XCTAssertEqual( g, 1.0 )
            XCTAssertEqual( b, 1.0 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    
    func testRGBHexStringParsingForRed() throws {
        switch rgba(for: "#F00"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 1.0 )
            XCTAssertEqual( g, 0 )
            XCTAssertEqual( b, 0 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    func testRGBHexStringParsingForGreen() throws {
        switch rgba(for: "#0F0"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 0 )
            XCTAssertEqual( g, 1.0 )
            XCTAssertEqual( b, 0 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    func testRGBHexStringParsingForBlue() throws {
        switch rgba(for: "#00F"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 0 )
            XCTAssertEqual( g, 0 )
            XCTAssertEqual( b, 1.0 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }

    //MARK: #RGBA
    func testRGBAHexStringParsingFFF0() throws {
        switch rgba(for: "#FFF0"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 1.0 )
            XCTAssertEqual( g, 1.0 )
            XCTAssertEqual( b, 1.0 )
            XCTAssertEqual( a, 0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    //Test colors
    //Red-ish: #DE3163, rgb( 222, 49, 99 )
    //Green-ish: #9FE2BF, rgb( 159, 226, 191 )
    //Blue-ish: #6495ED, rgb( 100, 149, 237 )
    
    //MARK: #RRGGBB
    func testRRGGBBHexStringParsingRedTestColor() throws {
        switch rgba(for: "#DE3163"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 222/255 )
            XCTAssertEqual( g, 49/255 )
            XCTAssertEqual( b, 99/255 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    func testRRGGBBHexStringParsingGreenTestColor() throws {
        switch rgba(for: "#9FE2BF"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 159/255 )
            XCTAssertEqual( g, 226/255 )
            XCTAssertEqual( b, 191/255 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    func testRRGGBBHexStringParsingBlueTestColor() throws {
        switch rgba(for: "#6495ED"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 100/255 )
            XCTAssertEqual( g, 149/255 )
            XCTAssertEqual( b, 237/255 )
            XCTAssertEqual( a, 1.0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    //Test colors
    //Red-ish-opaque-ish: #DE3163FA, rgba( 222, 49, 99, 250 )
    //Green-ish-clear-ish: #9FE2BF25, rgb( 159, 226, 191, 37 )
    //Blue-ish-clear: #6495ED00, rgb( 100, 149, 237, 0 )
    
    //MARK: #RRGGBBAA
    func testRRGGBBAAHexStringParsingRedTestColor() throws {
        switch rgba(for: "#DE3163FA"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 222/255 )
            XCTAssertEqual( g, 49/255 )
            XCTAssertEqual( b, 99/255 )
            XCTAssertEqual( a, 250/255 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    func testRRGGBBAAHexStringParsingGreenTestColor() throws {
        switch rgba(for: "#9FE2BF25"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 159/255 )
            XCTAssertEqual( g, 226/255 )
            XCTAssertEqual( b, 191/255 )
            XCTAssertEqual( a, 37/255 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    func testRRGGBBAAHexStringParsingBlueTestColor() throws {
        switch rgba(for: "#6495ED00"){
        case .success(( let r, let g, let b, let a )):
            XCTAssertEqual( r, 100/255 )
            XCTAssertEqual( g, 149/255 )
            XCTAssertEqual( b, 237/255 )
            XCTAssertEqual( a, 0 )
        case .failure( let error ):
            XCTFail( error.message )
        }
    }
    
    //
    func testStringLiteralMustStartWithHashtag() {
        // Arrange
        let hexString = "FF5733"
        
        // Act
        let result = rgba(for: hexString)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            guard case HexColorsError.stringLiteralMustStartWithHashtag(let string) = error else {
                XCTFail("Expected HexColorsError.stringLiteralMustStartWithHashtag, but got \(error.localizedDescription)")
                return
            }
        }
    }

    func testInvalidLength() {
        // Arrange
        let hexStrings = [ "#FF573", "#", "#FF", "#001122334455" ]
        
        // Act
        for hexString in hexStrings {
            let result = rgba(for: hexString)
            
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                guard case HexColorsError.invalidLength(let string) = error else {
                    XCTFail("Expected HexColorsError.invalidLength, but got \(error.localizedDescription)")
                    return
                }
            }
        }
    }

    func testInvalidCharacters() {
        // Arrange
        let hexString = "#FFG733"
        
        // Act
        let result = rgba(for: hexString)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            guard case HexColorsError.invalidCharacters(let string) = error else {
                return XCTFail("Expected HexColorsError.invalidCharacters, but got \(error.localizedDescription)")
                return
            }
        }
    }


    
}
