@attached(extension, names: arbitrary, conformances: Equatable)
public macro Equatable() = #externalMacro(module: "EquatableMacros", type: "EquatableMacro")

@attached(peer)
public macro SkipEquatable() = #externalMacro(module: "EquatableMacros", type: "SkipEquatableMacro")
