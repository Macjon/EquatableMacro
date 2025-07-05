import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(Equatable)
import Equatable
import EquatableMacros

let testMacros: [String: Macro.Type] = [
    "equatable": EquatableMacro.self,
]
#endif

final class EquatableMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(Equatable)
        assertMacroExpansion(
            """
            @equatable
            struct TestView: View {
                let title: String
                let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            """,
            expandedSource: """
            struct TestView: View {
                let title: String
                let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            
            extension TestView: Equatable {
                static func ==(lhs: TestView, rhs: TestView) -> Bool {
                    return lhs.title == rhs.title && lhs.isSkipable == rhs.isSkipable
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testPublicStructMacro() throws {
        #if canImport(Equatable)
        assertMacroExpansion(
            """
            @equatable
            public struct TestView: View {
                let title: String
                let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            """,
            expandedSource: """
            public struct TestView: View {
                let title: String
                let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            
            extension TestView: Equatable {
                public static func ==(lhs: TestView, rhs: TestView) -> Bool {
                    return lhs.title == rhs.title && lhs.isSkipable == rhs.isSkipable
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testSkipOfPropertyMacro() throws {
        #if canImport(Equatable)
        assertMacroExpansion(
            """
            @equatable
            struct TestView: View {
                let title: String
                @SkipEquatable let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            """,
            expandedSource: """
            struct TestView: View {
                let title: String
                @SkipEquatable let isSkipable: Bool
            
                var body: some View {
                    Text("Test")
                }
            }
            
            extension TestView: Equatable {
                static func ==(lhs: TestView, rhs: TestView) -> Bool {
                    return lhs.title == rhs.title
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testIgnoreSwiftUIDefaultAttributesMacro() throws {
        #if canImport(Equatable)
        assertMacroExpansion(
            """
            @equatable
            struct TestView: View {
                let title: String
                @SkipEquatable let isSkipable: Bool
                @State let message: String = ""
            
                var body: some View {
                    Text("Test")
                }
            }
            """,
            expandedSource: """
            struct TestView: View {
                let title: String
                @SkipEquatable let isSkipable: Bool
                @State let message: String = ""
            
                var body: some View {
                    Text("Test")
                }
            }
            
            extension TestView: Equatable {
                static func ==(lhs: TestView, rhs: TestView) -> Bool {
                    return lhs.title == rhs.title
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testWhenNoProperties() throws {
        #if canImport(Equatable)
        assertMacroExpansion(
            """
            @equatable
            struct TestView: View {
                var body: some View {
                    Text("Test")
                }
            }
            """,
            expandedSource: """
            struct TestView: View {
                var body: some View {
                    Text("Test")
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
