# 🧩 EquatableMacro for SwiftUI Views

This Swift macro package provides a convenient `@Equatable` macro for SwiftUI views that automatically synthesizes `Equatable` conformance — excluding transient state like `@State`, `@Environment`, or `@Binding`. It also includes a `@SkipEquatable` macro to explicitly exclude properties from comparison.

## ✨ Why

This macro was inspired by Airbnb’s excellent article on SwiftUI performance:

👉 [Understanding and Improving SwiftUI Performance](https://medium.com/airbnb-engineering/understanding-and-improving-swiftui-performance-37b77ac61896)

> SwiftUI compares view structs using `==` when marked `Equatable`. Excluding irrelevant properties (like `@State`) from comparison is crucial for performance — and easy to get wrong by hand.

I was eager to learn Swift macros and this article gave me the perfect excuse to build something useful.

## 🚀 What It Does

- Adds an `extension YourView: Equatable { ... }`
- Automatically generates a `static func ==(...)` implementation
- Ignores transient SwiftUI property wrappers:
  - `@State`, `@Binding`, `@Environment`, `@ObservedObject`, `@EnvironmentObject`, `@FocusState`
- Ignores `body` if the struct conforms to `View`
- Lets you explicitly skip properties with `@SkipEquatable`
- Respects the access modifier of the original struct (`public`, etc.)
- Skips generating the extension entirely if there are no relevant properties

## 📦 Example

```swift
import SwiftUI
import Equatable

@Equatable
public struct ProfileView: View {
    let name: String
    let age: Int

    @State private var count = 0
    @SkipEquatable var debugId: UUID = UUID()

    public var body: some View {
        VStack {
            Text(name)
            Text("Age: \(age)")
        }
    }
}
```

The macro expands to:

```swift
extension ProfileView: Equatable {
    public static func ==(lhs: ProfileView, rhs: ProfileView) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}
```

It skips:

- @State var count
- @SkipEquatable var debugId
- the body property

## 🔧 Installation

This is a Swift macro package. You’ll need:

- ✅ Swift 5.10 or higher
- ✅ Xcode 16.3 or higher
- ✅ Add it as a dependency in your Package.swift:

```swift
.package(url: "https://github.com/Macjon/EquatableMacro.git", from: "1.0.0"),
```

And link it in your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Equatable", package: "EquatableMacro")
    ]
)
```

💡 Don’t forget to `import Equatable` in the file where you use `@Equatable`.

## 🙏 Acknowledgments

Huge thanks to [Airbnb Engineering](https://medium.com/airbnb-engineering/understanding-and-improving-swiftui-performance-37b77ac61896) for their article that inspired this idea.

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
