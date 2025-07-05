import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct EquatableMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EquatableMacro.self,
        SkipEquatableMacro.self,
    ]
}
