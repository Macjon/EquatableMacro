//
//  SkipEquatable.swift
//  swift-equatableMacro
//
//  Created by Jonah Hulselmans on 03/07/2025.
//

import SwiftSyntax
import SwiftSyntaxMacros

public enum SkipEquatableMacro: PeerMacro {}

extension SkipEquatableMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // It doesn't generate any code, just used as a marker
        return []
    }
}
