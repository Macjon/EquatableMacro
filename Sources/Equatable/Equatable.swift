/// A macro that synthesizes `Equatable` conformance for Swift structs by generating
/// a `static func ==(...)` implementation based on stored properties.
///
/// This macro is especially useful for SwiftUI `View` structs where you want to control
/// update behavior using the `EquatableView` optimization pattern.
///
/// - Ignores properties marked with SwiftUI state wrappers such as:
///   - `@State`, `@Binding`, `@Environment`, `@ObservedObject`, `@EnvironmentObject`, `@FocusState`
/// - Ignores the `body` property if the type conforms to `View`
/// - Skips properties explicitly marked with `@SkipEquatable`
/// - Respects the original access level (`public`, `internal`, etc.)
/// - Skips generating anything if there are no relevant properties to compare
///
/// Inspired by: [Understanding and Improving SwiftUI Performance](https://medium.com/airbnb-engineering/understanding-and-improving-swiftui-performance-37b77ac61896)
@attached(extension, names: arbitrary, conformances: Equatable)
public macro Equatable() = #externalMacro(module: "EquatableMacros", type: "EquatableMacro")

/// A macro that marks a property to be excluded from `Equatable` synthesis by the `@Equatable` macro.
///
/// Use this when a property is not relevant to view identity, such as debug IDs or derived values.
///
/// ```swift
/// @Equatable
/// struct MyView: View {
///     let title: String
///
///     @SkipEquatable
///     var debugId: UUID = UUID()
///
///     var body: some View { ... }
/// }
/// ```
///
/// In the example above, `debugId` will be ignored in the synthesized `==` function.
@attached(peer)
public macro SkipEquatable() = #externalMacro(module: "EquatableMacros", type: "SkipEquatableMacro")
