import Foundation

func printTypes() {
    let numbers = ["One", "Two", "Three", "Four", "Five", "Six", "Seven"]
    
    for i in 1...7 {
        let generics = (0...i).map({ "L" + ( $0 == 0 ? "" : "\($0)") }).dropLast()
        print("""
    public struct \(numbers[i-1])Layout<\(generics.joined(separator: ", "))>: Layout {
    \(generics.map({ "let \($0.lowercased()): \($0)" }).joined(separator: "\n"))
    }
    
    """)
    }
    
    print("@resultBuilder")
    print("public struct LayoutBuilder {")
    for i in 1...7 {
        let generics = (0...i).map({ "L" + ( $0 == 0 ? "" : "\($0)") }).dropLast()
        print("""
    public static func buildBlock<\(generics.joined(separator: ", "))>(\(generics.map({ "_ \($0.lowercased()): \($0)" }).joined(separator: ", "))) -> \(numbers[i-1])Layout<\(generics.joined(separator: ", "))> {
        \(numbers[i-1])Layout<\(generics.joined(separator: ", "))>(\(generics.map({ "\($0.lowercased()): \($0.lowercased())" }).joined(separator: ", ")))
    }
    
    """)
    }
    print("}")
}
