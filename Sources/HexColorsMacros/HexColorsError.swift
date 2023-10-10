//
//  HexColorError.swift
//
//
//  Created by Hemma on 2023-09-27.
//

import Foundation
import SwiftSyntax
import SwiftDiagnostics

public enum HexColorsError: LocalizedError, DiagnosticMessage {
    
    case integerLiteralMustBeHexadecimal( String )
    case stringLiteralMustStartWithHashtag( String )
    case invalidLength( String )
    case failedToScanHex( String )
    case invalidCharacters( String )
    
    //MARK: LocalizedError
    public var errorDescription: String? { message }
    
    //MARK: DiagnosticMessage
    public var severity: DiagnosticSeverity { .error }

    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "Localized.\(self)")
    }

    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    public var message: String {
        switch self {
        case .integerLiteralMustBeHexadecimal( let string ):
            return "\"\(string)\" did not start with 0x"
        case .stringLiteralMustStartWithHashtag(let string):
            return "\"\(string)\" did not start with #"
        case .invalidLength(let string):
            return "\"\(string)\" is not the expected length of a hex color"
        case .failedToScanHex(let string):
            return "Failed to convert hex str \"\(string)\" to a number"
        case .invalidCharacters( let string ):
            return "\"\(string)\" contains invalid characters for a hex color"
        }
    }
    
}
