import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import IssueReporting

public enum EquatableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            reportIssue("⚠️ @Equatable can only be applied to structs")
            return []
        }

        let structName = structDecl.name.text

        // Check if the struct conforms to `View`
        let conformsToView = structDecl.inheritanceClause?.inheritedTypes.contains(where: {
            $0.type.trimmedDescription == "View"
        }) ?? false

        let members = structDecl.memberBlock.members

        let properties = members.compactMap { member -> VariableDeclSyntax? in
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { return nil }
            
            // Skip static vars
            if varDecl.modifiers.contains(where: { $0.name.text == "static" }) == true {
                return nil
            }
            
            // Skip SwiftUI wrappers
            let wrappers = ["State", "Environment", "ObservedObject", "EnvironmentObject", "Binding", "FocusState"]
            let hasIgnoredWrapper = varDecl.attributes.contains(where: {
                let name = $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription
                return name.map(wrappers.contains) ?? false
            })
            
            if hasIgnoredWrapper { return nil }
            
            // Skip @SkipEquatable
            let isSkipped = varDecl.attributes.contains(where: {
                $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "SkipEquatable"
            })
            if isSkipped { return nil }
            
            // Skip `body` if View
            if conformsToView,
               let binding = varDecl.bindings.first,
               let ident = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
               ident == "body" {
                return nil
            }

            return varDecl
        }

        // No properties, ignore
        if properties.isEmpty {
            return []
        }

        // Build the body of the == function
        let comparisons = properties.compactMap { property -> String? in
            guard let binding = property.bindings.first,
                  let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
                return nil
            }
            return "lhs.\(name) == rhs.\(name)"
        }

        // Detect access level of the original struct
        let accessModifier = structDecl.modifiers
            .first(where: { ["public", "package", "internal", "fileprivate", "private"].contains($0.name.text) })
            .map { "\($0.name.text) " } ?? ""

        let function: DeclSyntax = """
        \(raw: accessModifier)static func ==(lhs: \(raw: structName), rhs: \(raw: structName)) -> Bool {
            return \(raw: comparisons.joined(separator: " && "))
        }
        """

        let ext: DeclSyntax = """
        extension \(raw: structName): Equatable {
            \(function)
        }
        """

        guard let ext = ext.as(ExtensionDeclSyntax.self) else {
            reportIssue("‼️ @Equatable failed to build extension syntax")
            return []
        }

        return [ext]
    }
}
